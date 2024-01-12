import 'package:offline_pos/components/export_files.dart';

class CreateOrEditEmployeeScreen extends StatefulWidget {
  const CreateOrEditEmployeeScreen({super.key});

  @override
  State<CreateOrEditEmployeeScreen> createState() =>
      _CreateOrEditEmployeeScreenState();
}

class _CreateOrEditEmployeeScreenState
    extends State<CreateOrEditEmployeeScreen> {
  final TextEditingController _employeeNameTextController =
      TextEditingController();
  final TextEditingController _jobPositionTextController =
      TextEditingController();
  final TextEditingController _workEmailTextController =
      TextEditingController();
  final TextEditingController _pinCodeTextController = TextEditingController();
  bool? isTabletMode;
  bool? isMobileMode;

  @override
  void dispose() {
    _employeeNameTextController.dispose();
    _jobPositionTextController.dispose();
    _workEmailTextController.dispose();
    _pinCodeTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      isMobileMode = CommonUtils.isMobileMode(context);
      _employeeNameTextController.text =
          context.read<EmployeeListController>().creatingEmployee.name ?? '';
      _jobPositionTextController.text =
          context.read<EmployeeListController>().creatingEmployee.jobTitle ??
              '';
      _workEmailTextController.text =
          context.read<EmployeeListController>().creatingEmployee.workEmail ??
              '';
      _pinCodeTextController.text =
          context.read<EmployeeListController>().creatingEmployee.pin ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withOpacity(0.6),
          width: 0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: Constants.greyColor2.withOpacity(0.6),
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Form(
          key: context.read<EmployeeListController>().formKey,
          child: Column(
            children: [
              _employeeNameWidget(),
              _jobPositionWidget(),
              _workEmailWidget(),
              _pinCodeWidget(),
            ],
          )),
    );
  }

  Widget _employeeNameWidget() {
    return TextFormField(
      controller: _employeeNameTextController,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
      decoration: InputDecoration(
        hintText: "Employee's Name",
        hintStyle: TextStyle(
          color: Constants.disableColor.withOpacity(0.9),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the employee's name!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<EmployeeListController>().creatingEmployee.name = newValue;
      },
    );
  }

  Widget _jobPositionWidget() {
    return TextFormField(
      controller: _jobPositionTextController,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        color: primaryColor,
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
      decoration: InputDecoration(
        hintText: "Job Position",
        hintStyle: TextStyle(
          color: Constants.disableColor.withOpacity(0.9),
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the employee's job position!";
        }
        return null;
      },
      onSaved: (newValue) {
        context.read<EmployeeListController>().creatingEmployee.jobTitle =
            newValue;
      },
    );
  }

  Widget _workEmailWidget() {
    return Row(
      children: [
        Text('Work Email'),
        SizedBox(width: 6),
        Expanded(
          child: TextFormField(
            controller: _workEmailTextController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: "Work Email",
              hintStyle: TextStyle(
                color: Constants.disableColor.withOpacity(0.9),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
              labelStyle: TextStyle(
                color: primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
              border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the work email!";
              }
              return null;
            },
            onSaved: (newValue) {
              context
                  .read<EmployeeListController>()
                  .creatingEmployee
                  .workEmail = newValue;
            },
          ),
        ),
      ],
    );
  }

  Widget _pinCodeWidget() {
    return Row(
      children: [
        Text('Pin Code'),
        SizedBox(width: 6),
        Expanded(
          child: TextFormField(
            controller: _pinCodeTextController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: "pin",
              hintStyle: TextStyle(
                color: Constants.disableColor.withOpacity(0.9),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
              labelStyle: TextStyle(
                color: primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
              border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the pin code!";
              }
              return null;
            },
            onSaved: (newValue) {
              context.read<EmployeeListController>().creatingEmployee.pin =
                  newValue;
            },
          ),
        ),
      ],
    );
  }
}
