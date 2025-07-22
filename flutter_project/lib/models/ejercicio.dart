class Ejercicio {
  final String nombre;
  final String descripcion;

  Ejercicio({required this.nombre, required this.descripcion});

  factory Ejercicio.fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }
}