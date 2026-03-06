class Person {
  final int? id;
  final String nombre;
  final String apellido;
  final String cedula;
  final int edad;
  final String ciudad;

  Person({this.id, required this.nombre, required this.apellido, required this.cedula, required this.edad, required this.ciudad});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'apellido': apellido, 'cedula': cedula, 'edad': edad, 'ciudad': ciudad};
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      cedula: map['cedula'],
      edad: map['edad'],
      ciudad: map['ciudad'],
    );
  }
}