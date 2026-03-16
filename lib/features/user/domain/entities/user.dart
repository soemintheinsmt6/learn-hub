class User {
  int id;
  String name;
  String company;
  String username;
  String email;
  String address;
  String zip;
  String state;
  String country;
  String phone;
  String? photo;

  String get fullAddress => '$address, $state, $zip, $country';

  User({
    required this.id,
    required this.name,
    required this.company,
    required this.username,
    required this.email,
    required this.address,
    required this.zip,
    required this.state,
    required this.country,
    required this.phone,
    this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    company: json["company"],
    username: json["username"],
    email: json["email"],
    address: json["address"],
    zip: json["zip"],
    state: json["state"],
    country: json["country"],
    phone: json["phone"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "company": company,
    "username": username,
    "email": email,
    "address": address,
    "zip": zip,
    "state": state,
    "country": country,
    "phone": phone,
    "photo": photo,
  };

  static User placeHolder = User(
    id: 0,
    name: '',
    company: '',
    username: '',
    email: '',
    address: '',
    zip: '',
    state: '',
    country: '',
    phone: '',
  );
}
