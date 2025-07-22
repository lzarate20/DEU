class Equipo {
  final String nombre;
  final int cantidadMiembros;

  Equipo({required this.nombre, required this.cantidadMiembros});

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      nombre: json['nombre'],
      cantidadMiembros: json['cantidad_miembros'],
    );
  }
}