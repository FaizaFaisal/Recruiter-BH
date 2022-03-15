

 class myJobsResponse {
  late String city;
  late String company;
  late String company_id;
  late String job_id;
  late String jobTitle;
  late String candidate_status;
  late String feedback;

    myJobsResponse(
      this.company_id,
      this.job_id,
      this.company,
      this.city,
      this.jobTitle,
      this.candidate_status,
        this.feedback);

  myJobsResponse.fromJson(Map<String, dynamic> json) {
    city = json['city'] ?? "";
    company = json['company_name'] ?? "";
    job_id = json['job_id'] ?? "";
    company_id = json['company_id'] ?? "";
    jobTitle = json['job_title'] ?? "";
    candidate_status = json['candidate_status'].toString() ?? "";
    feedback = json['feedback'].toString() ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['company'] = this.company;
    data['job_id'] = this.job_id;
    data['company_id'] = this.company_id;
    data['job_title'] = this.jobTitle;
    data['candidate_status'] = this.candidate_status;
    data['feedback'] = this.feedback;

    return data;
  }
}
