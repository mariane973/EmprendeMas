import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

class InsertarDatosPerfil {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  void guardarDatos({
    required io.File imagen,
    required String nombre,
    required String apellido,
    required String direccion,
    required int telefono,
    required String id,
  }) async {
    Reference ref = _storage.ref().child('imgusuarios/${DateTime.now().toString()}');
    UploadTask uploadTask = ref.putFile(imagen);
    TaskSnapshot snapshot = await uploadTask;
    String img = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection('usuarios').add({
      'nombre': nombre,
      'imgusuario': img,
      'direccion': direccion,
      'telefono': telefono,
      'apellido' : apellido,
      'id' : id,
    }).then((value){
      Fluttertoast.showToast(
          msg: "Datos Guardados",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Colors.green,
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