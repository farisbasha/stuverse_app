import 'product_category.dart';

class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.isActive,
    required this.isBoosted,
    required this.createdAt,
    required this.updatedAt,
    required this.seller,
    required this.categories,
  });
  late final int id;
  late final String title;
  late final String description;
  late final String price;
  late final String image;
  late final bool isActive;
  late final bool isBoosted;

  late final String createdAt;
  late final String updatedAt;
  late final Seller seller;
  late final List<ProductCategory> categories;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    isActive = json['is_active'];
    isBoosted = json['is_boosted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    seller = Seller.fromJson(json['seller']);
    categories = List.from(json['categories'])
        .map((e) => ProductCategory.fromJson(e))
        .toList();
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    _data['image'] = image;
    _data['is_active'] = isActive;
    _data['is_boosted'] = isBoosted;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['seller'] = seller.toJson();
    _data['categories'] = categories.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Seller {
  Seller({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.district,
    required this.image,
    required this.mobile,
    required this.institutionName,
    required this.showContact,
    required this.dateJoined,
  });
  late final int id;
  late final String firstName;
  late final String lastName;
  late final String city;
  late final String district;
  late final String image;
  late final String mobile;
  late final String institutionName;
  late final String dateJoined;
  late final bool showContact;

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    city = json['city'];
    district = json['district'];
    image = json['image'];
    dateJoined = json['date_joined'];
    mobile = json['mobile'];
    institutionName = json['institution_name'];
    showContact = json['show_contact'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['city'] = city;
    _data['district'] = district;
    _data['image'] = image;
    _data['date_joined'] = dateJoined;
    return _data;
  }
}
