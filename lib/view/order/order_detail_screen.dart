import 'dart:developer';

import 'package:offline_pos/components/export_files.dart';
import 'package:offline_pos/controller/order_detail_controller.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  static const String routeName = "/order_detail_screen";
  final int orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Future<void> _getOrder() async {
    OrderHistory? orderHistory =
        await OrderHistoryTable.getOrderById(widget.orderId);
    log("Hello");
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<OrderDetailController>().resetOrderDetailController();
      _getOrder();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Container(
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 2,
          minWidth: (MediaQuery.of(context).size.width / 2) -
              MediaQuery.of(context).size.width / 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Constants.greyColor2.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 30, vertical: 10),
      padding: EdgeInsets.all(20),
    );
  }
}
