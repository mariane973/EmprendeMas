import 'package:EmprendeMas/vistas/emprendedores/serviciosVendedor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

class InsertarDatosServicio{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void guardarServicioDatos({
    required io.File imagen,
    required String descripcion,
    required String nombre,
    required int precio,
    required String correo,
    required BuildContext context,
    required int descuento,
    required int precioTotal,
    required String oferta,
  }) async {
    Reference ref = _storage.ref().child('imgservicios/${DateTime.now().toString()}');
    UploadTask uploadTask = ref.putFile(imagen);
    TaskSnapshot snapshot = await uploadTask;
    String img = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection('vendedores')
        .doc(correo)
        .collection('servicios')
        .add({
      'nombre': nombre,
      'imagen': img,
      'descripcion': descripcion,
      'precio': precio,
      'descuento': descuento,
      'precioTotal': precioTotal,
      'oferta': oferta,
    }).then((value){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Servicio Agregado'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ServiciosV(correo: correo)),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Servicio no Agregado'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}