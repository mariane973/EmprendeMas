import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  }) async {
    Reference ref = _storage.ref().child('imgproductos/${DateTime.now().toString()}');
    UploadTask uploadTask = ref.putFile(imagen);
    TaskSnapshot snapshot = await uploadTask;
    String img = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection('productos').add({
      'nombre': nombre,
      'categoria': categoria,
      'imagen': img,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
    }).then((value){
      Fluttertoast.showToast(
          msg: "Datos Guardados",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Colors.lightBlueAccent,
          fontSize: 18
      );
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Datos no guardados",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Colors.red,
          fontSize: 18
      );
    }
    );
  }
}