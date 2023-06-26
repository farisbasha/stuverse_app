import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stuverse_app/app/auth/models/user.dart';
import 'package:stuverse_app/app/core/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/boost/boost_cubit.dart';

class BoostAdScreen extends StatelessWidget {
  const BoostAdScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boost Ad"),
      ),
      body: Center(
        child: Text("Boost Ad Screen"),
      ),
    );
  }
}

// class BoostPage extends StatefulWidget {
//   final int orderId;
//   const BoostPage({super.key, required this.orderId});

//   @override
//   _BoostPageState createState() => _BoostPageState();
// }

// class _BoostPageState extends State<BoostPage>
//     with SingleTickerProviderStateMixin {
//   static const platform = const MethodChannel("razorpay_flutter");

//   late AnimationController animationController, fadeController;
//   late Animation<Offset> animation;
//   late User user;

//   late Razorpay _razorpay;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Boost Payment'),
//       ),
//       body: BlocBuilder<BoostCubit, BoostState>(
//         builder: (context, state) {
//           if (state is BoostLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (state is BoostError) {
//             return Center(
//               child: Text(
//                 "Could'nt load the order",
//               ),
//             );
//           }
//           return Padding(
//             padding: EdgeInsets.all(10),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                       padding: EdgeInsets.only(top: 10),
//                       child: ListTile(
//                         title: Text("mm"),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Order Note",
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         state.roomOrder!.orderNote ?? "",
//                         softWrap: true,
//                         maxLines: 20,
//                       ),
//                     ],
//                   ),
//                   FbSpacing.height(10.h),
//                   RoomBillingCard(order: state.roomOrder!),
//                   FbSpacing.height(10.h),
//                   FbButton.block(
//                       onPressed: openCheckout,
//                       backgroundColor: theme.colorScheme.primary,
//                       elevation: 0,
//                       borderRadiusAll: 4,
//                       child: Row(
//                         children: [
//                           SlideTransition(
//                               position: animation,
//                               child: const Icon(Icons.arrow_forward)),
//                           Expanded(
//                             child: Center(
//                               child: FbText.bodyMedium(
//                                 'Pay Now',
//                                 fontWeight: 600,
//                                 color: theme.colorScheme.onPrimary,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),
//                   FbSpacing.height(20.h),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     animationController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//     animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(15, 0)).animate(
//       CurvedAnimation(
//         parent: animationController,
//         curve: Curves.easeIn,
//       ),
//     );
//     user = getAuthUser(context);
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }

//   void openCheckout() async {
//     animationController.forward();
//     await Future.delayed(Duration(seconds: 1));
//     context.read<BoostCubit>().openCheckoutPressed(
//         orderId: widget.orderId, user: user, razorpay: _razorpay);
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     final respBool = await context.read<BoostCubit>().onPaymentSuccessful(
//           response: response,
//           roomOrderId: widget.orderId,
//           user: user,
//         );
//     if (respBool) {
//       FbPopUps.showToast(message: "Payment Successful");
//     } else {
//       FbPopUps.showToast(message: "oops something went wrong", isError: true);
//     }
//     context.read<RoomOrderCubit>().getRoomOrderList(user: user);
//     context.router.replaceAll([RoomMainRoute(selectedIndex: 2)]);
//   }

//   void _handlePaymentError(PaymentFailureResponse response) async {
//     final respBool = await context.read<BoostCubit>().onPaymentFailure(
//         response: response, roomOrderId: widget.orderId, user: user);
//     if (response.code == Razorpay.PAYMENT_CANCELLED) {
//       FbPopUps.showToast(message: "CANCELLED: ");
//       return;
//     }
//     if (respBool) {
//       FbPopUps.showToast(message: "Payment Failed", isError: true);
//     } else {
//       FbPopUps.showToast(message: "oops something went wrong", isError: true);
//     }
//     context.read<RoomOrderCubit>().getRoomOrderList(user: user);
//     context.router.replaceAll([RoomMainRoute(selectedIndex: 2)]);
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     FbPopUps.showToast(
//       message: "EXTERNAL_WALLET: " + response.walletName.toString(),
//     );
//   }
// }

// class RoomBillingCard extends StatelessWidget {
//   final RoomOrder order;
//   const RoomBillingCard({Key? key, required this.order}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = AppTheme.theme;
//     return FbContainer(
//       borderRadiusAll: 4,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           FbText.bodyMedium(
//             'Order Information',
//             muted: true,
//             fontWeight: 700,
//           ),
//           FbSpacing.height(20),
//           getBillItem(title: 'Order Id', value: '#R${order.id}'),
//           FbSpacing.height(4),
//           getBillItem(
//               title: 'Created At',
//               value: FbTimeUtils.getDateWithTime(order.createdAt!)),
//           FbSpacing.height(4),
//           getBillItem(
//               title: 'Updated At',
//               value: FbTimeUtils.getDateWithTime(order.updatedAt!)),
//           FbSpacing.height(12),
//           Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Container(),
//               ),
//               Expanded(
//                 child: FbDashedDivider(
//                   dashSpace: 4,
//                   dashWidth: 8,
//                   color: theme.colorScheme.onBackground.withAlpha(180),
//                   height: 1.2,
//                 ),
//               )
//             ],
//           ),
//           FbSpacing.height(12),
//           getBillItem(
//               title: 'Order Total', value: '₹' + order.price.toString()),
//         ],
//       ),
//     );
//   }

//   Row getBillItem({required String title, required String value}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         FbText.bodyMedium(
//           title,
//           fontWeight: 600,
//         ),
//         FbText.bodyMedium(
//           value,
//           fontWeight: 700,
//         ),
//       ],
//     );
//   }
// }
