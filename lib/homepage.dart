import 'package:flutter/material.dart';
import 'student.dart';
import 'bd_connections.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Student> _students;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNamePaternoController;
  late TextEditingController _lastNameMaternoController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _controlNumberController;

  Student? _selectedStudent;

  @override
  void initState() {
    super.initState();
    _students = [];
    _firstNameController = TextEditingController();
    _lastNamePaternoController = TextEditingController();
    _lastNameMaternoController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _controlNumberController = TextEditingController();
  }

  _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  _createTable() {
    BDConnections.createTable().then((result) {
      if (result == 'success') {
        _showSnackBar("Tabla creada correctamente");
      } else {
        _showSnackBar("Error al crear la tabla o ya existe");
      }
    });
  }

  _selectData() {
    BDConnections.selectData().then((students) {
      setState(() {
        _students = students;
      });
      _showSnackBar("Datos obtenidos correctamente");
    }).catchError((error) {
      _showSnackBar("Error al obtener los datos");
    });
  }

  _insertData() async {
    String firstName = _firstNameController.text.trim();
    String lastNamePaterno = _lastNamePaternoController.text.trim();
    String lastNameMaterno = _lastNameMaternoController.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();
    String controlNumber = _controlNumberController.text.trim();

    if (_validateFields(firstName, lastNamePaterno, lastNameMaterno, phone, email, controlNumber)) {
      var result = await BDConnections.insertData(firstName, lastNamePaterno, lastNameMaterno, phone, email, controlNumber);
      if (result == 'exists') {
        _showSnackBar("Número de control ya existe");
      } else if (result == 'success') {
        _showSnackBar("Registro insertado correctamente");
        _clearFields();
        _selectData(); 
      } else {
        _showSnackBar("Error al insertar datos. Prueba con crear tabla");
      }
    }
  }

  bool _validateFields(String firstName, String lastNamePaterno, String lastNameMaterno, String phone, String email, String controlNumber) {
    if (firstName.isEmpty || lastNamePaterno.isEmpty || lastNameMaterno.isEmpty || phone.isEmpty || email.isEmpty || controlNumber.isEmpty) {
      _showSnackBar("Todos los campos son obligatorios");
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      _showSnackBar("Teléfono solo debe contener números");
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(controlNumber)) {
      _showSnackBar("Número de control solo debe contener números");
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showSnackBar("Correo no es válido");
      return false;
    }
    return true;
  }

  _updateData() async {
    if (_selectedStudent == null) {
      _showSnackBar("Seleccione un estudiante para actualizar");
      return;
    }

    String firstName = _firstNameController.text.trim();
    String lastNamePaterno = _lastNamePaternoController.text.trim();
    String lastNameMaterno = _lastNameMaternoController.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();
    String controlNumber = _controlNumberController.text.trim();

    if (_validateFields(firstName, lastNamePaterno, lastNameMaterno, phone, email, controlNumber)) {
      var result = await BDConnections.updateData(_selectedStudent!.id, firstName, lastNamePaterno, lastNameMaterno, phone, email, controlNumber);
      if (result == 'success') {
        _showSnackBar("Registro actualizado correctamente");
        _clearFields();
        _selectData();
      } else {
        _showSnackBar("Error al actualizar datos");
      }
    }
  }

  _deleteData() async {
    if (_selectedStudent == null) {
      _showSnackBar("Seleccione un estudiante para eliminar");
      return;
    }

    var result = await BDConnections.deleteData(_selectedStudent!.id);
    if (result == 'success') {
      _showSnackBar("Registro eliminado correctamente");
      _clearFields();
      _selectData();
    } else {
      _showSnackBar("Error al eliminar datos");
    }
  }

  void _clearFields() {
    _firstNameController.clear();
    _lastNamePaternoController.clear();
    _lastNameMaternoController.clear();
    _phoneController.clear();
    _emailController.clear();
    _controlNumberController.clear();
    _selectedStudent = null;
  }

  void _populateFields(Student student) {
    _firstNameController.text = student.firstName;
    _lastNamePaternoController.text = student.lastNamePaterno;
    _lastNameMaternoController.text = student.lastNameMaterno;
    _phoneController.text = student.phone;
    _emailController.text = student.email;
    _controlNumberController.text = student.controlNumber;
    _selectedStudent = student;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MySQL Remote basic operations")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(title: const Text('Insertar'), onTap: _insertData),
            ListTile(title: const Text('Actualizar'), onTap: _updateData),
            ListTile(title: const Text('Eliminar'), onTap: _deleteData),
            ListTile(title: const Text('Seleccionar'), onTap: _selectData),
            ListTile(title: const Text('Crear Tabla'), onTap: _createTable),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildTextField(_firstNameController, "Primer nombre"),
            _buildTextField(_lastNamePaternoController, "Apellido paterno"),
            _buildTextField(_lastNameMaternoController, "Apellido materno"),
            _buildTextField(_phoneController, "Teléfono"),
            _buildTextField(_emailController, "Correo electrónico"),
            _buildTextField(_controlNumberController, "Número de control"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: _insertData, child: const Text("Insertar")),
                ElevatedButton(onPressed: _updateData, child: const Text("Actualizar")),
                ElevatedButton(onPressed: _deleteData, child: const Text("Eliminar")),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildStudentTable()), // Cambiado a Expanded para un ajuste adecuado
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildStudentTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("ID")),
          DataColumn(label: Text("Nombre")),
          DataColumn(label: Text("Apellido Paterno")),
          DataColumn(label: Text("Apellido Materno")),
          DataColumn(label: Text("Teléfono")),
          DataColumn(label: Text("Correo")),
          DataColumn(label: Text("Núm. Control")),
        ],
        rows: _students.map((student) {
          return DataRow(
            selected: _selectedStudent == student,
            onSelectChanged: (isSelected) {
              setState(() {
                _populateFields(student);
              });
            },
            cells: [
              DataCell(Text(student.id)),
              DataCell(Text(student.firstName)),
              DataCell(Text(student.lastNamePaterno)),
              DataCell(Text(student.lastNameMaterno)),
              DataCell(Text(student.phone)),
              DataCell(Text(student.email)),
              DataCell(Text(student.controlNumber)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
