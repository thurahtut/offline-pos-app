import 'package:offline_pos/components/export_files.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  static const String routeName = "/product_detail_screen";

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _searchProductTextController =
      TextEditingController();
  bool? isTabletMode;
  bool? isMobileMode;

  @override
  void dispose() {
    _searchProductTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isTabletMode = CommonUtils.isTabletMode(context);
      isMobileMode = CommonUtils.isMobileMode(context);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: InventoryAppBar(),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    var spacer = SizedBox(height: 15);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 16),
              Text(
                'Product/ [${CommonUtils.demoProduct.package ?? ''}]'
                '${CommonUtils.demoProduct.productName ?? ''}',
                style: TextStyle(
                  color: Constants.textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(flex: isTabletMode == true ? 1 : 2, child: SizedBox()),
              Expanded(child: _searchProductWidget()),
              SizedBox(width: 16),
            ],
          ),
          ProductDetailFilter(),
          spacer,
          ProductCommonActionTitle(),
          spacer,
          context.watch<ProductDetailController>().mode ==
                      ProductDetailMode.create ||
                  context.watch<ProductDetailController>().mode ==
                      ProductDetailMode.edit
              ? ProductCreateOrEditScreen()
              : ProductInfoView(),
        ],
      ),
    );
  }

  Widget _searchProductWidget() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
        ),
        child: TextField(
          controller: _searchProductTextController,
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
                  Constants.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: InkWell(
              onTap: () {
                _searchProductTextController.clear();
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
}
