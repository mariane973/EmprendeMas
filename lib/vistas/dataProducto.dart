import 'package:EmprendeMas/vistas/emprendedores/productosVendedor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

class InsertarDatosProducto{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void guardarDatos({
    required io.File imagen,
    required String categoria,
    required String descripcion,
    required String nombre,
    required int precio,
    required int stock,
    required String correo,
    required BuildContext context,
  }) async {
    Reference ref = _storage.ref().child('imgproductos/${DateTime.now().toString()}');
    UploadTask uploadTask = ref.putFile(imagen);
    TaskSnapshot snapshot = await uploadTask;
    String img = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection('vendedores')
        .doc(correo)
        .collection('productos')
        .add({
      'nombre': nombre,
      'categoria': categoria,
      'imagen': img,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
    }).then((value){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Producto Agregado'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProductosV(correo: correo)),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Producto no Agregado'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}