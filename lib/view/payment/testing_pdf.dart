// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart' as lib;
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// Future<dynamic> generateOrderReceipt(Receipt receipt, User user) async {
//   var myTheme = pw.ThemeData.withFont(
//     base:
//         pw.Font.ttf(await rootBundle.load("assets/fonts/Poppins-Regular.ttf")),
//     bold: pw.Font.ttf(await rootBundle.load("assets/fonts/Poppins-Bold.ttf")),
//   );

//   final doc = pw.Document(
//     theme: myTheme,
//   );

//   List<int> byteList = [];

//   if (receipt.orderItemsByVendor.first.logo != null ||
//       receipt.orderItemsByVendor.first.logo != '') {
//     var imageUrl = receipt.orderItemsByVendor.first.logo;
//     byteList = (await NetworkAssetBundle(Uri.parse(imageUrl ?? ""))
//             .load(imageUrl ?? ""))
//         .buffer
//         .asInt8List();
//   } else {
//     final ByteData bytes = await rootBundle.load('assets/images/walmart.png');
//     byteList = bytes.buffer.asInt8List();
//   }

//   doc.addPage(pw.Page(
//     build: (pw.Context context) {
//       return pw.Container(
//           color: lib.PdfColor.fromHex("#ffffff"),
//           child: pw.Padding(
//               padding: const pw.EdgeInsets.all(16.0),
//               child: pw.ListView(children: [
//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   children: [
//                     pw.SizedBox(
//                         width: 40,
//                         height: 40,
//                         child: pw.Image(
//                             pw.MemoryImage(
//                               Uint8List.fromList(byteList),
//                             ),
//                             fit: pw.BoxFit.fitHeight)),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(3.0),
//                       child: pw.Text(
//                         " ${receipt.orderItemsByVendor.first.vendorName}",
//                         style: pw.TextStyle(
//                           color: lib.PdfColor.fromHex("#000000"),
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(3.0),
//                       child: pw.Text(
//                         " ${receipt.orderItemsByVendor.first.vendorAddress}",
//                         style: pw.TextStyle(
//                           color: lib.PdfColor.fromHex("#000000"),
//                         ),
//                         textAlign: pw.TextAlign.center,
//                       ),
//                     )
//                   ],
//                 ),
//                 pw.SizedBox(height: 15),
//                 pw.Divider(),
//                 pw.SizedBox(height: 15),
//                 pw.Table(children: [
//                   pw.TableRow(
//                       decoration: const pw.BoxDecoration(
//                           border: pw.Border(bottom: pw.BorderSide())),
//                       children: [
//                         pw.SizedBox(
//                             width: 40,
//                             child: pw.Text(
//                               "Qty",
//                               style: pw.TextStyle(
//                                   color: lib.PdfColor.fromHex("#000000"),
//                                   fontSize: 14,
//                                   fontBold: pw.Font()),
//                             )),
//                         pw.Text(
//                           "Item",
//                           style: pw.TextStyle(
//                               color: lib.PdfColor.fromHex("#000000"),
//                               fontSize: 14,
//                               fontBold: pw.Font()),
//                         ),
//                         pw.Container(
//                           width: 150,
//                           child: pw.Text(
//                             "Amount",
//                             textAlign: pw.TextAlign.right,
//                             style: pw.TextStyle(
//                               color: lib.PdfColor.fromHex("#000000"),
//                               fontSize: 14,
//                               fontBold: pw.Font(),
//                             ),
//                           ),
//                         )
//                       ]),

//                   // item rows
//                   ...receipt.orderItemsByVendor.first.orderItems.map((e) {
//                     bool isSelfDiscount = e.isSelfDiscount;
//                     String nametext = (isSelfDiscount &&
//                             e.parentDiscountItems.isNotEmpty)
//                         ? " - (${e.parentDiscountItems.first.discountLable})"
//                         : "";
//                     return pw.TableRow(children: [
//                       pw.Padding(
//                           padding: const pw.EdgeInsets.only(top: 5.0),
//                           child: pw.SizedBox(
//                               width: 40, child: pw.Text("${e.qty}x"))),
//                       pw.Padding(
//                           padding: const pw.EdgeInsets.only(top: 5.0),
//                           child: pw.RichText(
//                               text: pw.TextSpan(
//                                 text: "${e.itemName}",
//                                 children: [
//                                   pw.TextSpan(
//                                       text: nametext,
//                                       style: pw.TextStyle(
//                                           color:
//                                               lib.PdfColor.fromHex("#000000"),
//                                           fontSize: 12,
//                                           fontBold: pw.Font())),
//                                   pw.TextSpan(
//                                     text: (isSelfDiscount &&
//                                             e.parentDiscountItems.isNotEmpty)
//                                         ? " (${numberFormatter.format(e.price)}Ks)"
//                                         : "",
//                                     style: pw.TextStyle(
//                                         color: lib.PdfColor.fromHex("#000000"),
//                                         fontSize: 12,
//                                         decoration:
//                                             pw.TextDecoration.lineThrough,
//                                         fontBold: pw.Font()),
//                                   ),
//                                   pw.TextSpan(
//                                     text: (isSelfDiscount &&
//                                             e.parentDiscountItems.isNotEmpty)
//                                         ? " ${numberFormatter.format(e.discountedPrice)}Ks"
//                                         : " ${numberFormatter.format(e.price)}Ks",
//                                     style: pw.TextStyle(
//                                         color: lib.PdfColor.fromHex("#000000"),
//                                         fontSize: 12,
//                                         fontBold: pw.Font()),
//                                   ),
//                                 ],
//                                 style: pw.TextStyle(
//                                   color: lib.PdfColor.fromHex("#000000"),
//                                   fontSize: 12,
//                                   fontBold: pw.Font(),
//                                 ),
//                               ),
//                               maxLines: 2)),
//                       pw.Padding(
//                           padding: const pw.EdgeInsets.only(top: 5.0),
//                           child: pw.SizedBox(
//                             width: 150,
//                             child: pw.Text(
//                               (isSelfDiscount &&
//                                       e.parentDiscountItems.isNotEmpty)
//                                   ? "${currencyFormatter.format(e.discountedPrice * e.qty)} Ks"
//                                   : "${currencyFormatter.format(e.price * e.qty)} Ks",
//                               textAlign: pw.TextAlign.right,
//                             ),
//                           )),
//                     ]);
//                   }).toList(),

//                   // promo item rows
//                   ...receipt.orderItemsByVendor.first.orderItems.map((e) {
//                     GiftItem? giftItem =
//                         e.promotion != null && e.promotion?.promoItem != null
//                             ? e.promotion?.promoItem
//                             : null;
//                     return giftItem != null
//                         ? pw.TableRow(children: [
//                             pw.Padding(
//                                 padding: const pw.EdgeInsets.only(top: 5.0),
//                                 child: pw.SizedBox(
//                                     width: 40,
//                                     child: pw.Text(
//                                         "${e.promotion?.freeItemQuantity ?? 1}x"))),
//                             pw.Padding(
//                                 padding: const pw.EdgeInsets.only(top: 5.0),
//                                 child: pw.RichText(
//                                     text: pw.TextSpan(
//                                       text: giftItem.name,
//                                       style: pw.TextStyle(
//                                         color: lib.PdfColor.fromHex("#000000"),
//                                         fontSize: 12,
//                                         fontBold: pw.Font(),
//                                       ),
//                                     ),
//                                     maxLines: 2)),
//                             pw.Padding(
//                                 padding: const pw.EdgeInsets.only(top: 5.0),
//                                 child: pw.SizedBox(
//                                   width: 150,
//                                   child: pw.Text(
//                                     "FOC",
//                                     textAlign: pw.TextAlign.right,
//                                   ),
//                                 )),
//                           ])
//                         : const pw.TableRow(
//                             children: [],
//                           );
//                   }).toList(),
//                 ]),

//                 // divider
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.symmetric(vertical: 5.0),
//                   child: pw.Container(child: pw.LayoutBuilder(
//                     builder: (context, constraints) {
//                       final boxWidth = constraints!.constrainWidth();
//                       const dashWidth = 5.0;
//                       const dashHeight = 1.0;
//                       final dashCount = (boxWidth / (2 * dashWidth)).floor();
//                       return pw.Flex(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         direction: pw.Axis.horizontal,
//                         children: List.generate(dashCount, (_) {
//                           return pw.SizedBox(
//                             width: dashWidth,
//                             height: dashHeight,
//                             child: pw.DecoratedBox(
//                               decoration: pw.BoxDecoration(
//                                 color: lib.PdfColor.fromHex("#898989"),
//                               ),
//                             ),
//                           );
//                         }),
//                       );
//                     },
//                   )),
//                 ),

//                 pw.Padding(
//                   padding: const pw.EdgeInsets.only(top: 3.0),
//                   child: pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text("Subtotal"),
//                       pw.Text(
//                         "${currencyFormatter.format(receipt.subTotal)} Ks",
//                         textAlign: pw.TextAlign.right,
//                       )
//                     ],
//                   ),
//                 ),
//                 receipt.deliveryFee > 0
//                     ? pw.Padding(
//                         padding: const pw.EdgeInsets.only(top: 3.0),
//                         child: pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text("Delivery Fee"),
//                             pw.Text(
//                               "${currencyFormatter.format(receipt.deliveryFee)} Ks",
//                               textAlign: pw.TextAlign.right,
//                             )
//                           ],
//                         ),
//                       )
//                     : pw.SizedBox(),
//                 receipt.deliveryTip > 0
//                     ? pw.Padding(
//                         padding: const pw.EdgeInsets.only(top: 3.0),
//                         child: pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text("Delivery Tips"),
//                             pw.Text(
//                               "${currencyFormatter.format(receipt.deliveryTip)} Ks",
//                               textAlign: pw.TextAlign.right,
//                             )
//                           ],
//                         ),
//                       )
//                     : pw.SizedBox(),

//                 receipt.couponAmount > 0
//                     ? pw.Padding(
//                         padding: const pw.EdgeInsets.only(top: 3.0),
//                         child: pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text("Coupon discount"),
//                             pw.Text(
//                               "- ${currencyFormatter.format(receipt.couponAmount)} Ks",
//                               textAlign: pw.TextAlign.right,
//                             )
//                           ],
//                         ),
//                       )
//                     : pw.SizedBox(),

//                 // divider
//                 pw.Padding(
//                     padding: const pw.EdgeInsets.symmetric(vertical: 5.0),
//                     child: pw.Container(child: pw.LayoutBuilder(
//                       builder: (context, constraints) {
//                         final boxWidth = constraints!.constrainWidth();
//                         const dashWidth = 5.0;
//                         const dashHeight = 1.0;
//                         final dashCount = (boxWidth / (2 * dashWidth)).floor();
//                         return pw.Flex(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           direction: pw.Axis.horizontal,
//                           children: List.generate(dashCount, (_) {
//                             return pw.SizedBox(
//                               width: dashWidth,
//                               height: dashHeight,
//                               child: pw.DecoratedBox(
//                                 decoration: pw.BoxDecoration(
//                                   color: lib.PdfColor.fromHex("#898989"),
//                                 ),
//                               ),
//                             );
//                           }),
//                         );
//                       },
//                     ))),

//                 pw.Padding(
//                   padding: const pw.EdgeInsets.only(top: 3.0),
//                   child: pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text("Total"),
//                       pw.Text(
//                         "${currencyFormatter.format(receipt.grandTotal)} Ks",
//                         style: pw.TextStyle(
//                             color: lib.PdfColor.fromHex("#000000"),
//                             fontBold: pw.Font(),
//                             fontSize: 16),
//                         textAlign: pw.TextAlign.right,
//                       )
//                     ],
//                   ),
//                 ),

//                 // divider
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.symmetric(vertical: 5.0),
//                   child: pw.Container(child: pw.LayoutBuilder(
//                     builder: (context, constraints) {
//                       final boxWidth = constraints!.constrainWidth();
//                       const dashWidth = 5.0;
//                       const dashHeight = 1.0;
//                       final dashCount = (boxWidth / (2 * dashWidth)).floor();
//                       return pw.Flex(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         direction: pw.Axis.horizontal,
//                         children: List.generate(dashCount, (_) {
//                           return pw.SizedBox(
//                             width: dashWidth,
//                             height: dashHeight,
//                             child: pw.DecoratedBox(
//                               decoration: pw.BoxDecoration(
//                                 color: lib.PdfColor.fromHex("#898989"),
//                               ),
//                             ),
//                           );
//                         }),
//                       );
//                     },
//                   )),
//                 ),

//                 pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Flexible(
//                           child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Padding(
//                             padding:
//                                 const pw.EdgeInsets.symmetric(vertical: 5.0),
//                             child: pw.Row(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               children: [
//                                 pw.Text(
//                                   "Payment method",
//                                   style: pw.TextStyle(
//                                     color: lib.PdfColor.fromHex("#000000"),
//                                     fontBold: pw.Font(),
//                                   ),
//                                 ),
//                                 pw.Text(
//                                   receipt.paymentMethod.toString(),
//                                   style: pw.TextStyle(
//                                     color: lib.PdfColor.fromHex("#000000"),
//                                     fontBold: pw.Font(),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           pw.Padding(
//                             padding:
//                                 const pw.EdgeInsets.symmetric(vertical: 5.0),
//                             child: pw.Row(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               children: [
//                                 pw.Text(
//                                   "Date",
//                                   style: pw.TextStyle(
//                                     color: lib.PdfColor.fromHex("#000000"),
//                                     fontBold: pw.Font(),
//                                   ),
//                                 ),
//                                 pw.Text(
//                                   dateFormatter.format(receipt.createdDate!),
//                                   style: pw.TextStyle(
//                                     color: lib.PdfColor.fromHex("#000000"),
//                                     fontBold: pw.Font(),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           pw.Padding(
//                             padding:
//                                 const pw.EdgeInsets.symmetric(vertical: 5.0),
//                             child: pw.Row(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               children: [
//                                 pw.Text(
//                                   "Transaction ID",
//                                   style: pw.TextStyle(
//                                     color: lib.PdfColor.fromHex("#000000"),
//                                     fontBold: pw.Font(),
//                                   ),
//                                 ),
//                                 pw.Text(
//                                   receipt.transactionRef,
//                                   style: pw.TextStyle(
//                                     color: lib.PdfColor.fromHex("#000000"),
//                                     fontBold: pw.Font(),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ))
//                     ]),

//                 // barcode widget
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
//                   child: pw.Column(
//                     children: [
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(8.0),
//                         child: pw.Text("Thank you for choosing us."),
//                       ),
//                       pw.SizedBox(
//                         width: 200,
//                         height: 100,
//                         child: pw.BarcodeWidget(
//                           data: receipt.transactionRef,
//                           barcode: pw.Barcode.code128(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ])));
//     },
//   ));

//   // for pdf
//   List<int> d = await doc.save();
//   Uint8List byte = Uint8List.fromList(d);
//   // Get temporary directory
//   final dir = await getTemporaryDirectory();

//   // for download receipt image
//   await for (var page in Printing.raster(byte, pages: [0])) {
//     var file = File('${dir.path}/order_id_${receipt.transactionRef}.png');
//     final byteData = await page.toPng();
//     await file.writeAsBytes(byteData, flush: true);
//     final result =
//         await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
//     print(result);
//   }
//   return;
// }
