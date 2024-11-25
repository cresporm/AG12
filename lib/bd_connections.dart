import 'package:http/http.dart' as http;
import 'student.dart';
import 'dart:convert';

class BDConnections {
  static const SERVER = "http://192.168.1.66/students/sqloperations.php";
  static const _CREATE_TABLE_COMMNAND = "CREATE_TABLE";
  static const _SELECT_TABLE_COMMNAND = "SELECT_TABLE";
  static const _INSERT_TABLE_COMMNAND = "INSERT_DATA";

  static Future<String> createTable() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _CREATE_TABLE_COMMNAND;
      final response = await http.post(Uri.parse(SERVER), body: map);
      print('Table response: ${response.body}');

      if (response.statusCode == 200) {
        print(response.body.toString());
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print("Error creando la tabla o la tabla ya existe");
      print(e.toString());
      return "error";
    }
  }

  static Future<List<Student>> selectData() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _SELECT_TABLE_COMMNAND;
      final response = await http.post(Uri.parse(SERVER), body: map);
      print('Select response: ${response.body}');

      if (response.statusCode == 200) {
        List<Student> list = parseResponse(response.body);
        return list;
      } else {
        return []; 
      }
    } catch (e) {
      print("Error obteniendo los datos");
      print(e.toString());
      return []; 
    }
  }

  static List<Student> parseResponse(String responseBody) {
    final parsedData = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsedData.map<Student>((json) => Student.fromJson(json)).toList();
  }

 
static Future<bool> checkIfControlNumberExists(String controlNumber) async {
  var map = <String, dynamic>{};
  map['action'] = 'CHECK_CONTROL_NUMBER';
  map['control_number'] = controlNumber;

  final response = await http.post(Uri.parse(SERVER), body: map);
  if (response.statusCode == 200) {
    return response.body == 'true';
  }
  return false;
}

static Future<String> deleteData(String id) async {
  var map = <String, dynamic>{};
  map['action'] = 'DELETE_DATA';
  map['id'] = id;

  final response = await http.post(Uri.parse(SERVER), body: map);
  return response.statusCode == 200 ? 'success' : 'error';
}

static Future<String> updateData(String id, String firstName, String lastNamePaterno, String lastNameMaterno, String phone, String email, String controlNumber) async {
  var map = <String, dynamic>{
    'action': 'UPDATE_DATA',
    'id': id,
    'first_name': firstName.toUpperCase(),
    'last_name_paterno': lastNamePaterno.toUpperCase(),
    'last_name_materno': lastNameMaterno.toUpperCase(),
    'phone': phone,
    'email': email,
    'control_number': controlNumber,
  };

  final response = await http.post(Uri.parse(SERVER), body: map);
  return response.statusCode == 200 ? 'success' : 'error';
}

static Future<String> insertData(
    String firstName, String lastNamePaterno, String lastNameMaterno,
    String phone, String email, String controlNumber) async {
  try {
    //  datos a mayúsculas
    firstName = firstName.toUpperCase();
    lastNamePaterno = lastNamePaterno.toUpperCase();
    lastNameMaterno = lastNameMaterno.toUpperCase();

    bool exists = await checkIfControlNumberExists(controlNumber);
    if (exists) return 'exists';

    var map = <String, dynamic>{
      'action': _INSERT_TABLE_COMMNAND,
      'first_name': firstName,
      'last_name_paterno': lastNamePaterno,
      'last_name_materno': lastNameMaterno,
      'phone': phone,
      'email': email,
      'control_number': controlNumber,
    };

    final response = await http.post(Uri.parse(SERVER), body: map);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error";
    }
  } catch (e) {
    print("Error agregando datos a la tabla");
    print(e.toString());
    return "error";
  }
}

}
