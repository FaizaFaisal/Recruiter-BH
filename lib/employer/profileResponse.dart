

class profileResponse
{
  late String company_name;
  late String company_email;
  late String company_phone;
  late String profile;

  profileResponse(
      this.company_name,
      this.company_email,
      this.company_phone,
      this.profile
      );

  profileResponse.fromJson(Map<String, dynamic> json) {
    company_name = json['company_name'] ?? "";
    company_email = json['company_email'] ?? "";
    company_phone = json['company_phone'] ?? "";
    profile = json['photoURL'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_name'] = this.company_name;
    data['company_email'] = this.company_email;
    data['company_phone'] = this.company_phone;
    data['photoURL'] = this.profile;

    return data;
  }

}