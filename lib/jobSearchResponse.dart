class jobSearchResponse {
  late String industry;
  late String recruiter;
  late String skills;
  late String city;
  late String company;
  late String company_id;
  late String jobType;
  late String title;
  late String description;
  late String country;
  late String role;
  late String dateOpen;
  late String dateClose;
  late String responsibility;
  late String salary;
  late String experience;
  late String job_id;
  late String category;
  late String jobStatus;

  jobSearchResponse(
      this.industry,
      this.recruiter,
      this.skills,
      this.city,
      this.company,
      this.jobType,
      this.title,
      this.description,
      this.country,
      this.role,
      this.dateOpen,
      this.dateClose,
      this.responsibility,
      this.salary,
      this.experience,
      this.category,
      this.company_id,
      this.job_id,
      this.jobStatus);

  jobSearchResponse.fromJson(Map<String, dynamic> json) {
    industry = json['industry'] ?? "";
    recruiter = json['recruiter'] ?? "";
    skills = json['skills'] ?? "";
    city = json['city'] ?? "";
    company = json['company_name'] ?? "";
    jobType = json['job_type'] ?? "";
    title = json['job_title'] ?? "";
    description = json['description'] ?? "";
    country = json['country'] ?? "";
    role = json['role'] ?? "";
    dateOpen = json['date_start'] ?? "";
    dateClose = json['date_end'] ?? "";
    responsibility = json['responsibility'] ?? "";
    salary = json['salary'].toString() ?? "";
    experience = json['experience'] ?? "";
    job_id = json['job_id'] ?? "";
    company_id = json['company_id'] ?? "";
    category = json['category'] ?? "";
    jobStatus = json['job_status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['industry'] = this.industry;
    data['recruiter'] = this.recruiter;
    data['skills'] = this.skills;
    data['city'] = this.city;
    data['company'] = this.company;
    data['job_type'] = this.jobType;
    data['title'] = this.title;
    data['description'] = this.description;
    data['country'] = this.country;
    data['role'] = this.role;
    data['dateOpen'] = this.dateOpen;
    data['dateClose'] = this.dateClose;
    data['responsibility'] = this.responsibility;
    data['salary'] = this.salary;
    data['experience'] = this.experience;
    data['job_id'] = this.job_id;
    data['category'] = this.category;
    data['company_id'] = this.company_id;
    data['job_status'] = this.jobStatus;

    return data;
  }
}
