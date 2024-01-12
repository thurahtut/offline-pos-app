import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/model/pos_session.dart';

class SelectInventoryScreen extends StatefulWidget {
  const SelectInventoryScreen(
      {super.key, required this.mainContext, required this.bContext});
  final BuildContext mainContext;
  final BuildContext bContext;

  @override
  State<SelectInventoryScreen> createState() => _SelectInventoryScreenState();
}

class _SelectInventoryScreenState extends State<SelectInventoryScreen> {
  final ValueNotifier<int> _inventoryIdNotifier = ValueNotifier(0);

  @override
  void dispose() {
    _inventoryIdNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.mainContext
                .read<LoginUserController>()
                .loginUser
                ?.configData
                ?.isEmpty ??
            true
        ? SizedBox()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dropDownWidget(
                widget.mainContext,
                widget.mainContext
                    .read<LoginUserController>()
                    .loginUser!
                    .configData!,
                _inventoryIdNotifier,
              ),
              SizedBox(height: 20),
              BorderContainer(
                text: "Choose",
                containerColor: primaryColor,
                textColor: Colors.white,
                onTap: () {
                  LoginUserController controller =
                      widget.mainContext.read<LoginUserController>();
                  for (var i = 0;
                      i < (controller.loginUser?.configData?.length ?? 0);
                      i++) {
                    if (_inventoryIdNotifier.value == 0 ||
                        controller.loginUser!.configData![i].id ==
                            _inventoryIdNotifier.value) {
                      int index = _inventoryIdNotifier.value == 0 ? 0 : i;
                      controller.selectedInventory =
                          controller.loginUser!.configData![index];
                      int? inventoryId = controller.selectedInventory?.id;
                      Api.getPosConfigByID(inventoryId: inventoryId)
                          .then((configResponse) {
                        if (configResponse != null &&
                            configResponse.statusCode == 200 &&
                            configResponse.data != null &&
                            configResponse.data is List &&
                            (configResponse.data as List).isNotEmpty) {
                          controller.posConfig = POSConfig.fromJson(
                              (configResponse.data as List).first);
                          int? configId = controller.posConfig?.id;
                          Api.getPosSessionByID(configId: configId)
                              .then((sessionResponse) {
                            if (sessionResponse != null &&
                                sessionResponse.statusCode == 200 &&
                                sessionResponse.data != null &&
                                sessionResponse.data is List &&
                                (sessionResponse.data as List).isNotEmpty) {
                              controller.posSession = POSSession.fromJson(
                                  (sessionResponse.data as List).first);
                              Navigator.pop(widget.bContext, true);
                            } else {
                              Navigator.pop(widget.bContext, false);
                            }
                          });
                        }
                      });
                      break;
                    }
                  }
                },
              ),
            ],
          );
  }

  static _dropDownWidget(
    BuildContext mainContext,
    List<ConfigData> list,
    ValueNotifier<int> inventoryIdNotifier,
  ) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(mainContext).size.width / 4.8,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Constants.greyColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor, width: 1.7)),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton(
              value: list.first,
              icon: SizedBox(),
              underline: Container(),
              items: list.map((ConfigData items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items.name ?? ''),
                );
              }).toList(),
              onChanged: (ConfigData? newValue) {
                inventoryIdNotifier.value = newValue?.id ?? 0;
              },
            ),
          ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
