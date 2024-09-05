import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  String clee;
  String id;
  String nombre;
  String razonSocial;
  String claseActividad;
  String estrato;
  String tipoVialidad;
  String calle;
  String numExterior;
  String numInterior;
  String colonia;
  String cp;
  String ubicacion;
  String telefono;
  String correoE;
  String sitioInternet;
  String tipo;
  String longitud;
  String latitud;
  String centroComercial;
  String tipoCentroComercial;
  String numLocal;

  Welcome({
    required this.clee,
    required this.id,
    required this.nombre,
    required this.razonSocial,
    required this.claseActividad,
    required this.estrato,
    required this.tipoVialidad,
    required this.calle,
    required this.numExterior,
    required this.numInterior,
    required this.colonia,
    required this.cp,
    required this.ubicacion,
    required this.telefono,
    required this.correoE,
    required this.sitioInternet,
    required this.tipo,
    required this.longitud,
    required this.latitud,
    required this.centroComercial,
    required this.tipoCentroComercial,
    required this.numLocal,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    clee: json["CLEE"],
    id: json["Id"],
    nombre: json["Nombre"],
    razonSocial: json["Razon_social"],
    claseActividad: json["Clase_actividad"],
    estrato: json["Estrato"],
    tipoVialidad: json["Tipo_vialidad"],
    calle: json["Calle"],
    numExterior: json["Num_Exterior"],
    numInterior: json["Num_Interior"],
    colonia: json["Colonia"],
    cp: json["CP"],
    ubicacion: json["Ubicacion"],
    telefono: json["Telefono"],
    correoE: json["Correo_e"],
    sitioInternet: json["Sitio_internet"],
    tipo: json["Tipo"],
    longitud: json["Longitud"],
    latitud: json["Latitud"],
    centroComercial: json["CentroComercial"],
    tipoCentroComercial: json["TipoCentroComercial"],
    numLocal: json["NumLocal"],
  );

  Map<String, dynamic> toJson() => {
    "CLEE": clee,
    "Id": id,
    "Nombre": nombre,
    "Razon_social": razonSocial,
    "Clase_actividad": claseActividad,
    "Estrato": estrato,
    "Tipo_vialidad": tipoVialidad,
    "Calle": calle,
    "Num_Exterior": numExterior,
    "Num_Interior": numInterior,
    "Colonia": colonia,
    "CP": cp,
    "Ubicacion": ubicacion,
    "Telefono": telefono,
    "Correo_e": correoE,
    "Sitio_internet": sitioInternet,
    "Tipo": tipo,
    "Longitud": longitud,
    "Latitud": latitud,
    "CentroComercial": centroComercial,
    "TipoCentroComercial": tipoCentroComercial,
    "NumLocal": numLocal,
  };
}