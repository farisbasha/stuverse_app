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
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['first_name'] = firstName;

    _data['username'] = username;
    _data['mobile'] = mobile;
    _data['email'] = email;
    _data['city'] = city;
    _data['district'] = district;
    _data['institution_name'] = institutionName;
    _data['image'] = image;

    _data['is_active'] = isActive;
    _data['token'] = token;
    return _data;
  }
}
