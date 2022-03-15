


class scheduledInterviewResponse {
  late String job_id;
  late String title;
  late String dateOpen;
  late String userid;
  late String username;

  scheduledInterviewResponse(
      this.job_id,
      this.title,
      this.dateOpen,
      this.userid,
      this.username);

  scheduledInterviewResponse.fromJson(Map<String, dynamic> json) {
    title = json['job_title'] ?? "";
    job_id = json['job_id'] ?? "";
    dateOpen = json['date_time'] ?? "";
    userid = json['user_id'] ?? "";
    username = json['user_name'] ?? "";

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_id'] = this.job_id;
    data['job_title'] = this.title;
    data['date_time'] = this.dateOpen;
    data['user_id'] = this.userid;
    data['user_name'] = this.username;


    return data;
  }
}
