import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'boost_state.dart';

class BoostCubit extends Cubit<BoostState> {
  BoostCubit() : super(BoostInitial());

  // void addProductOrder({required Product product, required User user}) async {
  //   try {
  //     final resp = await dioClient.post(createProductOrderAPI,
  //         options: Options(
  //           headers: {
  //             'Authorization': 'Token ${user.token}',
  //           },
  //         ),
  //         data: {
  //           "customer": user.id,
  //           "product": product.id,
  //           "price": product.price,
  //         });

  //     emit(BoostSuccess());
  //   } on DioException catch (e) {
  //     print(e.response ?? e.toString());
  //     emit(BoostError("Something went wrong"));
  //   } catch (e) {
  //     emit(BoostError("Something went wrong"));
  //   }
  // }

  // @override
  // void getProductOrderList(
  //     {required String query, required String token}) async {
  //   try {
  //     try {
  //       final resp = await dioClient.get(
  //         getProductOrderListAPI + query,
  //         options: Options(
  //           headers: {
  //             'Authorization': 'Token $token',
  //           },
  //         ),
  //       );

  //       if (resp.statusCode == 200 || resp.statusCode == 201) {
  //         return right(
  //           (resp.data as List)
  //               .map((e) => ProductOrder.fromJson(e as Map<String, dynamic>))
  //               .toList(),
  //         );
  //       }

  //       return left(const ProductFailure.serverError());
  //     } on DioError catch (e) {
  //       final response = e.response;
  //       if (response == null) {
  //         print(e.toString());
  //         return left(const ProductFailure.clientError());
  //       } else {
  //         return left(const ProductFailure.serverError());
  //       }
  //     } catch (e) {
  //       return left(const ProductFailure.serverError());
  //     }
  //   } catch (e) {
  //     return left(const ProductFailure.clientError());
  //   }
  // }

  // @override
  // Future<Either<ProductFailure, ProductOrder>> initiatePayment(
  //     {required String id, required String token}) async {
  //   try {
  //     final resp =
  //         await dioClient.patch(updateProductOrderAPI.replaceFirst("<id>", id),
  //             options: Options(
  //               headers: {
  //                 'Authorization': 'Token $token',
  //               },
  //             ),
  //             data: {
  //           "is_payment_initiated": true,
  //         });

  //     if (resp.statusCode == 200 || resp.statusCode == 201) {
  //       return await getProductOrder(id: id, token: token);
  //     }

  //     return left(const ProductFailure.serverError());
  //   } on DioError catch (e) {
  //     final response = e.response;
  //     if (response == null) {
  //       return left(const ProductFailure.clientError());
  //     } else {
  //       return left(const ProductFailure.serverError());
  //     }
  //   } catch (e) {
  //     return left(const ProductFailure.clientError());
  //   }
  // }

  // @override
  // Future<Either<ProductFailure, ProductOrder>> getProductOrder(
  //     {required String id, required String token}) async {
  //   try {
  //     final resp = await dioClient.get(
  //       getProductOrderAPI.replaceFirst("<id>", id),
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Token $token',
  //         },
  //       ),
  //     );

  //     if (resp.statusCode == 200 || resp.statusCode == 201) {
  //       return right(
  //         ProductOrder.fromJson(resp.data as Map<String, dynamic>),
  //       );
  //     }

  //     return left(const ProductFailure.serverError());
  //   } on DioError catch (e) {
  //     final response = e.response;
  //     if (response == null) {
  //       return left(const ProductFailure.clientError());
  //     } else {
  //       return left(const ProductFailure.serverError());
  //     }
  //   } catch (e) {
  //     return left(const ProductFailure.clientError());
  //   }
  // }

  // @override
  // Future<Either<ProductFailure, ProductOrder>> completePayment(
  //     {required String id,
  //     required String token,
  //     required String razorpayPaymentId,
  //     required String razorpayOrderId,
  //     required String razorpaySignature}) async {
  //   try {
  //     final resp =
  //         await dioClient.patch(updateProductOrderAPI.replaceFirst("<id>", id),
  //             options: Options(
  //               headers: {
  //                 'Authorization': 'Token $token',
  //               },
  //             ),
  //             data: {
  //           'razorpay_order_id': razorpayOrderId,
  //           'razorpay_payment_id': razorpayPaymentId,
  //           'razorpay_signature': razorpaySignature
  //         });

  //     if (resp.statusCode == 200 || resp.statusCode == 201) {
  //       return await getProductOrder(id: id, token: token);
  //     }

  //     return left(const ProductFailure.serverError());
  //   } on DioError catch (e) {
  //     final response = e.response;
  //     if (response == null) {
  //       return left(const ProductFailure.clientError());
  //     } else {
  //       return left(const ProductFailure.serverError());
  //     }
  //   } catch (e) {
  //     return left(const ProductFailure.clientError());
  //   }
  // }

  // @override
  // Future<Either<ProductFailure, ProductOrder>> failedPayment(
  //     {required String id,
  //     required String paymentStatus,
  //     required String orderNote,
  //     required String token}) async {
  //   try {
  //     final resp =
  //         await dioClient.patch(updateProductOrderAPI.replaceFirst("<id>", id),
  //             options: Options(
  //               headers: {
  //                 'Authorization': 'Token $token',
  //               },
  //             ),
  //             data: {'payment_status': paymentStatus, 'order_note': orderNote});

  //     if (resp.statusCode == 200 || resp.statusCode == 201) {
  //       return await getProductOrder(id: id, token: token);
  //     }

  //     return left(const ProductFailure.serverError());
  //   } on DioError catch (e) {
  //     final response = e.response;
  //     if (response == null) {
  //       return left(const ProductFailure.clientError());
  //     } else {
  //       return left(const ProductFailure.serverError());
  //     }
  //   } catch (e) {
  //     return left(const ProductFailure.clientError());
  //   }
  // }
}
