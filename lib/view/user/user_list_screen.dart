import 'package:offline_pos/components/export_files.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});
  static const String routeName = "/employee_list_screen";

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController _searchEmployeeTextController =
      TextEditingController();
  bool? isTabletMode;
  bool? isMobileMode;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      isMobileMode = CommonUtils.isMobileMode(context);
      context.read<EmployeeListController>().resetEmployeeListController();
      getAllEmployee();
    });
    super.initState();
  }

  Future<void> getAllEmployee() async {
    context.read<EmployeeListController>().employeeList = [];
    EmployeeTable.getAll().then((list) {
      context.read<EmployeeListController>().employeeList.addAll(list);
      context.read<EmployeeListController>().notify();
    });
  }

  @override
  void dispose() {
    _searchEmployeeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: context.read<EmployeeListController>().mode == ViewMode.view,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.read<EmployeeListController>().mode = ViewMode.view;

          context.read<EmployeeListController>().creatingEmployee = Employee();
        }
      },
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: InventoryAppBar(),
        body: _bodyWidget(),
      ),
    );
  }

  Widget _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 16),
              Text(
                'Employees',
                style: TextStyle(
                  color: Constants.textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(flex: isTabletMode == true ? 1 : 2, child: SizedBox()),
              if (context.watch<EmployeeListController>().mode !=
                      ViewMode.create &&
                  context.watch<EmployeeListController>().mode != ViewMode.edit)
                Expanded(child: _searchEmployeeWidget()),
              SizedBox(width: 16),
            ],
          ),
          _filtersWidget(),
          Expanded(
              child: context.watch<EmployeeListController>().mode ==
                          ViewMode.create ||
                      context.watch<EmployeeListController>().mode ==
                          ViewMode.edit
                  ? CreateOrEditEmployeeScreen()
                  : _employeeListWidget()),
        ],
      ),
    );
  }

  Widget _searchEmployeeWidget() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
        ),
        child: TextField(
          controller: _searchEmployeeTextController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            contentPadding: EdgeInsets.all(16),
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: 14),
            filled: true,
            fillColor: Constants.greyColor,
            prefixIcon: UnconstrainedBox(
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                width: 25,
                height: 25,
                colorFilter: ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: InkWell(
              onTap: () {
                _searchEmployeeTextController.clear();
              },
              child: UnconstrainedBox(
                child: SvgPicture.asset(
                  'assets/svg/close.svg',
                  width: 25,
                  height: 25,
                  colorFilter: ColorFilter.mode(
                    Constants.alertColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filtersWidget() {
    return (context.watch<EmployeeListController>().mode == ViewMode.create ||
            context.watch<EmployeeListController>().mode == ViewMode.edit)
        ? Row(
            children: [
              BorderContainer(
                text: 'Save',
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                containerColor: primaryColor,
                textColor: Colors.white,
                width: 150,
                textSize: 20,
                radius: 16,
                onTap: () async {
                  if (context.read<EmployeeListController>().mode ==
                      ViewMode.create) {
                    if (context
                            .read<EmployeeListController>()
                            .formKey
                            .currentState
                            ?.validate() ??
                        false) {
                      context
                          .read<EmployeeListController>()
                          .formKey
                          .currentState
                          ?.save();
                      await EmployeeTable.insert(context
                              .read<EmployeeListController>()
                              .creatingEmployee)
                          .then((value) {
                        if (value > 0) {
                          context
                              .read<EmployeeListController>()
                              .creatingEmployee = Employee();
                          context.read<EmployeeListController>().mode =
                              ViewMode.view;
                          EmployeeTable.getEmployeeByEmployeeId(value)
                              .then((employee) {
                            if (employee == null) {
                              CommonUtils.showSnackBar(
                                context: context,
                                message: 'Inserting '
                                      '"${context.read<EmployeeListController>().creatingEmployee.name}"'
                                    ' does not have! Something was wrong!',
                              );
                              return;
                            }
                            int index = context
                                .read<EmployeeListController>()
                                .employeeList
                                .indexWhere((element) =>
                                    element.id == employee.id);
                            if (index != -1) {
                              context
                                  .read<EmployeeListController>()
                                  .employeeList[index] = employee;
                            } else {
                              context
                                  .read<EmployeeListController>()
                                  .employeeList
                                  .add(employee);
                            }

                            context.read<EmployeeListController>().notify();
                          });
                        } else {
                          CommonUtils.showSnackBar(
                            message: 'Creating '
                                  '"${context.read<EmployeeListController>().creatingEmployee.name}"'
                                ' is failed!',
                          );
                        }
                      });
                    }
                    return;
                  }
                  if (context.read<EmployeeListController>().mode ==
                      ViewMode.edit) {
                    if (context
                            .read<EmployeeListController>()
                            .formKey
                            .currentState
                            ?.validate() ??
                        false) {
                      context
                          .read<EmployeeListController>()
                          .formKey
                          .currentState
                          ?.save();
                      await EmployeeTable.update(context
                              .read<EmployeeListController>()
                              .creatingEmployee)
                          .then((value) {
                        if (value > 0) {
                          context
                              .read<EmployeeListController>()
                              .creatingEmployee = Employee();
                          context.read<EmployeeListController>().mode =
                              ViewMode.view;
                          EmployeeTable.getEmployeeByEmployeeId(value)
                              .then((employee) {
                            if (employee == null) {
                              CommonUtils.showSnackBar(
                                message: 'Updating '
                                      '"${context.read<EmployeeListController>().creatingEmployee.name}"'
                                    ' does not have! Something was wrong!',
                              );
                              return;
                            }
                            int index = context
                                .read<EmployeeListController>()
                                .employeeList
                                .indexWhere((element) =>
                                    element.id == employee.id);
                            if (index != -1) {
                              context
                                  .read<EmployeeListController>()
                                  .employeeList[index] = employee;
                            } else {
                              context
                                  .read<EmployeeListController>()
                                  .employeeList
                                  .add(employee);
                            }

                            context.read<EmployeeListController>().notify();
                          });
                        } else {
                          CommonUtils.showSnackBar(
                            message: 'Updating '
                                  '"${context.read<EmployeeListController>().creatingEmployee.name}"'
                                ' is failed!',
                          );
                        }
                      });
                    }
                    return;
                  }
                  context.read<EmployeeListController>().mode = ViewMode.edit;
                },
              ),
              SizedBox(width: 4),
              BorderContainer(
                text: 'Discard',
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                width: 150,
                textSize: 20,
                radius: 16,
                onTap: () {
                  if (context.read<EmployeeListController>().mode ==
                          ViewMode.create ||
                      context.read<EmployeeListController>().mode ==
                          ViewMode.edit) {
                    context.read<EmployeeListController>().mode = ViewMode.view;

                    context.read<EmployeeListController>().creatingEmployee =
                        Employee();
                    return;
                  }
                  context.read<EmployeeListController>().mode = ViewMode.create;
                },
              ),
            ],
          )
        : Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    BorderContainer(
                      text: 'Create',
                      containerColor: primaryColor,
                      textColor: Colors.white,
                      width: 150,
                      onTap: () {
                        context.read<EmployeeListController>().mode =
                            ViewMode.create;
                      },
                    ),
                    SizedBox(width: 4),
                    CommonUtils.svgIconActionButton(
                        'assets/svg/export_notes.svg'),
                    (isTabletMode != true && isMobileMode != true)
                        ? Expanded(child: SizedBox())
                        : SizedBox(),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (isTabletMode != true && isMobileMode != true)
                      Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CommonUtils.appBarActionButtonWithText(
                            'assets/svg/filter_alt.svg', 'Filters',
                            width: 35, height: 35),
                        SizedBox(width: 4),
                        CommonUtils.appBarActionButtonWithText(
                          'assets/svg/ad_group.svg',
                          'Group By',
                          // width: 25,
                        ),
                        SizedBox(width: 4),
                        CommonUtils.appBarActionButtonWithText(
                          'assets/svg/favorite.svg',
                          'Favorites',
                          // width: 25,
                        ),
                        SizedBox(width: 4),
                        CommonUtils.svgIconActionButton(
                            'assets/svg/view_list.svg'),
                        SizedBox(width: 4),
                        CommonUtils.svgIconActionButton(
                            'assets/svg/grid_view.svg'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
            ],
          );
  }

  Widget _employeeListWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobileMode == true ? 2 : 4,
          childAspectRatio: 4.2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: context.watch<EmployeeListController>().employeeList.isEmpty
            ? []
            : context
                .read<EmployeeListController>()
                .employeeList
                .asMap()
                .map((i, e) => MapEntry(
                    i,
                    InkWell(
                      onTap: () {
                        context
                            .read<EmployeeListController>()
                            .creatingEmployee = e;
                        context.read<EmployeeListController>().mode =
                            ViewMode.edit;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black.withOpacity(0.7),
                            width: 0.3,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Constants.accentColor.withOpacity(0.6),
                                ),
                                child: Center(
                                    child: Text(
                                  e.name?.characters.first.toUpperCase() ?? '',
                                  style: TextStyle(
                                    fontSize: 45,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          e.name ?? '',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          e.workEmail ?? '',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 2,
                                      right: 10,
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: i.isEven
                                                ? Constants.successColor
                                                : Constants.accentColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )))
                .values
                .toList(),
      ),
    );
  }
}
