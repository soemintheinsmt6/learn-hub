class Company {
  int id;
  String name;
  String address;
  String zip;
  String country;
  int employeeCount;
  String industry;
  int marketCap;
  String domain;
  String logo;
  String ceoName;

  String get fullAddress => '$address, $zip, $country';

  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.zip,
    required this.country,
    required this.employeeCount,
    required this.industry,
    required this.marketCap,
    required this.domain,
    required this.logo,
    required this.ceoName,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    zip: json["zip"],
    country: json["country"],
    employeeCount: json["employeeCount"],
    industry: json["industry"],
    marketCap: json["marketCap"],
    domain: json["domain"],
    logo: json["logo"],
    ceoName: json["ceoName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "zip": zip,
    "country": country,
    "employeeCount": employeeCount,
    "industry": industry,
    "marketCap": marketCap,
    "domain": domain,
    "logo": logo,
    "ceoName": ceoName,
  };

  static Company placeHolder = Company(
    id: 0,
    name: '',
    address: '',
    zip: '',
    country: '',
    employeeCount: 0,
    industry: '',
    marketCap: 0,
    domain: '',
    logo: '',
    ceoName: '',
  );
}
