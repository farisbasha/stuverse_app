import 'package:stuverse_app/app/core/models/product.dart';
import 'dart:convert';

const String PRODUCT_PAYMENT_PENDING = 'pending';
const String PRODUCT_PAYMENT_CREATED = 'created';
const String PRODUCT_PAYMENT_ATTEMPTED = 'attempted';
const String PRODUCT_PAYMENT_PAID = 'paid';
const String PRODUCT_PAYMENT_FAILED = 'failed';
// To parse this JSON data, do
//
//     final productOrder = productOrderFromJson(jsonString);

ProductOrder productOrderFromJson(String str) =>
    ProductOrder.fromJson(json.decode(str));

String productOrderToJson(ProductOrder data) => json.encode(data.toJson());
// To parse this JSON data, do
//
//     final productOrder = productOrderFromJson(jsonString);

class ProductOrder {
  int id;
  String price;
  String orderNote;
  bool isPaymentInitiated;
  bool isPaid;
  String razorpayOrderId;
  String razorpayPaymentId;
  String paymentStatus;
  DateTime createdAt;
  DateTime updatedAt;
  Product product;
  int seller;

  ProductOrder({
    required this.id,
    required this.price,
    required this.orderNote,
    required this.isPaymentInitiated,
    required this.isPaid,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
    required this.seller,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) => ProductOrder(
        id: json["id"],
        price: json["price"],
        orderNote: json["order_note"],
        isPaymentInitiated: json["is_payment_initiated"],
        isPaid: json["is_paid"],
        razorpayOrderId: json["razorpay_order_id"],
        razorpayPaymentId: json["razorpay_payment_id"],
        paymentStatus: json["payment_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: Product.fromJson(json["product"]),
        seller: json["seller"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "order_note": orderNote,
        "is_payment_initiated": isPaymentInitiated,
        "is_paid": isPaid,
        "razorpay_order_id": razorpayOrderId,
        "razorpay_payment_id": razorpayPaymentId,
        "payment_status": paymentStatus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product,
        "seller": seller,
      };
}
