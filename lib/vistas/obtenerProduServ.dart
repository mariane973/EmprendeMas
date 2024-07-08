import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> obtenerProductosDelVendedor(String idVendedor) async {
  List<Map<String, dynamic>> productos = [];
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('vendedores')
        .doc(idVendedor)
        .collection('productos')
        .get();
    for (var doc in snapshot.docs) {
      productos.add(doc.data() as Map<String, dynamic>);
    }
  } catch (e) {
    print("Error obteniendo productos: $e");
  }
  return productos;
}

Future<List<Map<String, dynamic>>> obtenerServiciosDelVendedor(String idVendedor) async {
  List<Map<String, dynamic>> servicios = [];
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('vendedores')
        .doc(idVendedor)
        .collection('servicios')
        .get();
    for (var doc in snapshot.docs) {
      servicios.add(doc.data() as Map<String, dynamic>);
    }
  } catch (e) {
    print("Error obteniendo servicios: $e");
  }
  return servicios;
}