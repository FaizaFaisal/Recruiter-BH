class Job {
  late String industry;
  Job(this.industry);

  Job.fromJSON(Map<String, dynamic> json) {
    industry = json['industry'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['industry'] = this.industry;

    return data;
  }
}
