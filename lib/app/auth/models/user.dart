class User {
  User({
    required this.id,
    required this.firstName,
    required this.username,
    required this.mobile,
    required this.email,
    required this.city,
    required this.district,
    required this.institutionName,
    required this.image,
    required this.isActive,
    required this.showContact,
    required this.token,
  });
  late final int id;
  late final String firstName;

  late final String username;
  late final String mobile;
  late final String email;
  late final String city;
  late final String district;
  late final String institutionName;
  late final String image;
  late final bool showContact;
  late final bool isActive;
  late final String token;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];

    username = json['username'];
    mobile = json['mobile'];
    email = json['email'];
    city = json['city'];
    district = json['district'];
    institutionName = json['institution_name'];
    image = json['image'];

    isActive = json['is_active'];
    token = json['token'];
    showContact = json['show_contact'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;

    data['username'] = username;
    data['mobile'] = mobile;
    data['email'] = email;
    data['city'] = city;
    data['district'] = district;
    data['institution_name'] = institutionName;
    data['image'] = image;

    data['is_active'] = isActive;
    data['token'] = token;
    return data;
  }
}
