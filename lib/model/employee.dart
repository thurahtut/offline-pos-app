class Employee {
  int? id;
  String? name;
  String? pin;
  String? workEmail;
  String? workPhone;
  String? jobTitle;

  Employee(
      {this.id,
      this.name,
      this.pin,
      this.workEmail,
      this.workPhone,
      this.jobTitle});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pin = json['pin'];
    workEmail = json['work_email'];
    workPhone = json['work_phone'];
    jobTitle = json['job_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pin'] = pin;
    data['work_email'] = workEmail;
    data['work_phone'] = workPhone;
    data['job_title'] = jobTitle;
    return data;
  }
}
