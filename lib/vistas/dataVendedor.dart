import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

class InsertarDatosVendedor{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void guardarDatos({
    required io.File imagen,
    required String apellido,
    required String ciudad,
    required String direccion,
    required String correo,
    required String descripcion,
    required String nombre,
    required String emprendimiento,
    required int telefono,
  }) async {
    Reference ref = _storage.ref().child('imgvendedores/${DateTime.now().toString()}');
    UploadTask uploadTask = ref.putFile(imagen);
    TaskSnapshot snapshot = await uploadTask;
    String img = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection('vendedores').add({
      'nombre': nombre,
      'apellido': apellido,
      'logo_emprendimiento': img,
      'telefono': telefono,
      'correo': correo,
      'nombre_emprendimiento': emprendimiento,
      'descripcion_emprendimiento': descripcion,
      'direccion': direccion,
      'ciudad': ciudad,
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