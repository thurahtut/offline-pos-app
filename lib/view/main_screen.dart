import '/components/export_files.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String routeName = "/main_screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> categoryList = [
    "Dry Grocery",
    "Food To Go",
    "Men Wears",
    "Women Wears",
    "B.W.S , Wine, Accessories and Tabacco",
    "Basic Grocery",
    "Beverage",
    "Bakery",
    "Butchery"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        _headerWidget(),
      ],
    );
  }

  Widget _headerWidget() {
    return Row(
      children: [
        CommonUtils.appBarActionButtonWithSrcIn('assets/svg/grid_view.svg'),
        CommonUtils.appBarActionButton('assets/svg/List View.svg'),
        CommonUtils.appBarActionButtonWithSrcIn('assets/svg/home.svg'),
        ...categoryList
            .map((e) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Constants.primaryColor,
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }
}
