import 'package:offline_pos/components/export_files.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({
    super.key,
    required this.mainContext,
    required this.bContext,
  });
  final BuildContext mainContext;
  final BuildContext bContext;

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  bool? isTabletMode;
  bool? isMobileMode;
  final TextEditingController _searchEmployeeTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

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

  @override
  void dispose() {
    _searchEmployeeTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Future<void> getAllEmployee() async {
    context.read<EmployeeListController>().employeeList = [];
    EmployeeTable.getAll().then((list) {
      context.read<EmployeeListController>().employeeList.addAll(list);
      context.read<EmployeeListController>().notify();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(
      thickness: 1.3,
      color: Constants.disableColor.withOpacity(0.96),
    );
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...context.watch<EmployeeListController>().employeeList.isEmpty
              ? [
                  divider,
                  _searchEmployeeWidget(),
                  _emptyUserWidget(),
                ]
              : [
                  _searchEmployeeWidget(),
                  ...context
                      .read<EmployeeListController>()
                      .employeeList
                      .map(
                        (e) => _eachChooseCashierRowWidget(
                          widget.bContext,
                          widget.mainContext,
                          _passwordTextController,
                          divider,
                          e,
                        ),
                      )
                      .toList()
                ]
        ],
      ),
    );
  }

  Widget _emptyUserWidget() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Center(
        child: Text(
          'No User',
          style: TextStyle(
            fontSize: 16,
            color: Constants.primaryColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _searchEmployeeWidget() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _searchEmployeeTextController,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            contentPadding: EdgeInsets.all(16),
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: 14),
            filled: true,
            fillColor: Constants.unselectedColor.withOpacity(0.7),
            prefixIcon: UnconstrainedBox(
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                width: 25,
                height: 25,
                colorFilter: ColorFilter.mode(
                  Constants.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: InkWell(
              onTap: () {
                _searchEmployeeTextController.clear();
                getAllEmployee();
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
          onChanged: (value) {
            EmployeeTable.getEmployeeWithFilter(value).then((result) {
              context.read<EmployeeListController>().employeeList = result;
            });
          },
        ),
      ),
    );
  }

  Widget _eachChooseCashierRowWidget(
      BuildContext dialogContext,
      BuildContext mainContext,
      TextEditingController passwordTextController,
      Widget spacer,
      Employee e) {
    return InkWell(
      onTap: () {
        mainContext.read<EmployeeListController>().toSelectEmployee = e;
        PasswordDialog.enterPasswordWidget(mainContext, passwordTextController)
            .then((value) {
          if (value == true) {
            EmployeeTable.checkEmployeeWithIdAndPassword(
              e.employeeId ?? 0,
              passwordTextController.text,
            ).then((result) {
              if (result != null) {
                ScaffoldMessenger.of(mainContext).showSnackBar(SnackBar(
                    content: Text('Login with '
                        '"${e.name}"'
                        ' successful!')));

                Navigator.pop(dialogContext, true);
              } else {
                ScaffoldMessenger.of(mainContext).showSnackBar(SnackBar(
                    content: Text('Login with '
                        '"${e.name}"'
                        ' is failed. Invalid Password !')));

                Navigator.pop(dialogContext, false);
              }
            });
          } else {
            Navigator.pop(dialogContext, false);
          }
          passwordTextController.clear();
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          spacer,
          SizedBox(height: 10),
          Text(
            e.name ?? '',
            style: TextStyle(
              color: Constants.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
