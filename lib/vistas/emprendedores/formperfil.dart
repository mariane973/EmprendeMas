import 'package:EmprendeMas/vistas/emprendedores/homevendedor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:EmprendeMas/material.dart';

class FormPerfilV extends StatefulWidget {
  final String dato;

  const FormPerfilV({Key? key, required this.dato}) : super(key: key);

  @override
  State<FormPerfilV> createState() => _FormPerfilVState();
}

class _FormPerfilVState extends State<FormPerfilV> {
  final InsertarDatosPerfil insertarDatos = InsertarDatosPerfil();

  io.File? imagen;
  final picker = ImagePicker();
  final form = GlobalKey<FormState>();
  late String _nombre;
  late String _apellido;
  late String _direccion;
  late String _ciudad;
  late String _descripcion;
  late String _emprendimiento;
  late int _telefono;
  late String _correo = '';

  @override
  void initState() {
    super.initState();
    _obtenerCorreo();
  }

  Future<void> _obtenerCorreo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _correo = user.email ?? '';
      });
    } else {
      print('No hay usuario autenticado.');
    }
  }

  Future<void> selImagen(int op) async {
    final pickedFile = await picker.getImage(
      source: op == 1 ? ImageSource.camera : ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        imagen = io.File(pickedFile.path);
      } else {
        print('No seleccionaste ninguna foto');
      }
    });
  }

  void opciones(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    selImagen(1);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text('Tomar una foto')),
                        Icon(Icons.camera_alt, color: Colors.green),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    selImagen(2);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(child: Text('Seleccionar Foto')),
                        Icon(Icons.image, color: Colors.green),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registro de datos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Form(
            key: form,
            child: Column(
              children: [
                Center(
                  child: imagen != null
                      ? Image.file(imagen!, height: 300)
                      : Image.asset('img/tucanemp.png', height: 100),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      opciones(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                      backgroundColor: Colors.green,
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: FaIcon(
                            FontAwesomeIcons.cameraAlt,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Seleccionar Logo Emprendimiento",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'Información',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 40, bottom: 30),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Nombre",
                      hintText: "Ingrese su nombre",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese su(s) nombre(s)";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nombre = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Apellido",
                      hintText: "Ingrese su(s) apellido(s)",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese su apellido";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _apellido = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone_android),
                      labelText: "Teléfono",
                      hintText: "Ingrese su teléfono",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese su teléfono";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _telefono = int.parse(value!);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.store),
                      labelText: "Nombre Emprendimiento",
                      hintText: "Ingrese el nombre del emprendimiento",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese el nombre del emprendimiento";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _emprendimiento = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description_rounded),
                      labelText: "Descripción Emprendimiento",
                      hintText: "Ingrese la descripción del emprendimiento",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese la descripcion del emprendimiento";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _descripcion = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on),
                      labelText: "Dirección",
                      hintText: "Ingrese su dirección",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese su dirección";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _direccion = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_city_rounded),
                      labelText: "Ciudad",
                      hintText: "Ingrese ciudad de residencia",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese la ciudad";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _ciudad = value!;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (form.currentState!.validate()) {
                      form.currentState!.save();
                      await insertarDatos.insertarDatos(_nombre, _direccion, _ciudad, _emprendimiento, _descripcion, _telefono, _apellido, _correo, imagen);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeVendedor(correo: _correo)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                      backgroundColor: AppMaterial().getColorAtIndex(1)
                  ),
                  child: Text("Registrar",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InsertarDatosPerfil {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> insertarDatos(
      String nombre,
      String direccion,
      String ciudad,
      String emprendimiento,
      String descripcion,
      int telefono,
      String apellido,
      String correo,
      io.File? imagen,
      ) async {
    try {
      String? imageUrl;
      if (imagen != null) {
        String imagePath = 'imgvendedores/$correo/${DateTime.now().toString()}.jpg';
        TaskSnapshot uploadTask = await _storage.ref(imagePath).putFile(imagen);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      await _firestore.collection('vendedores').doc(correo).set({
        'nombre': nombre,
        'direccion': direccion,
        'telefono': telefono,
        'apellido': apellido,
        'correo': correo,
        'ciudad': ciudad,
        'nombre_emprendimiento': emprendimiento,
        'descripcion_emprendimiento': emprendimiento,
        'logo_emprendimiento': imageUrl,
      });
    } catch (e) {
      print('Error al insertar los datos: $e');
    }
  }
}