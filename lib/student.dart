class Student {
  String id;
  String firstName;
  String lastNamePaterno;
  String lastNameMaterno;
  String phone;
  String email;
  String controlNumber;

  Student({
    required this.id,
    required this.firstName,
    required this.lastNamePaterno,
    required this.lastNameMaterno,
    required this.phone,
    required this.email,
    required this.controlNumber,
  });

 
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastNamePaterno: json['last_name_paterno'] as String,
      lastNameMaterno: json['last_name_materno'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      controlNumber: json['control_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name_paterno': lastNamePaterno,
      'last_name_materno': lastNameMaterno,
      'phone': phone,
      'email': email,
      'control_number': controlNumber,
    };
  }
}
