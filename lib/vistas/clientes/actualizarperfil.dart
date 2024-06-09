import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:emprende_mas/vistas/clientes/homeusuario.dart';
import 'package:emprende_mas/material.dart';

class EditarPerfilCliente extends StatefulWidget {
  final String correo;

  EditarPerfilCliente({required this.correo});

  @override
  State<EditarPerfilCliente> createState() => _EditarPerfilClienteState();
}

class _EditarPerfilClienteState extends State<EditarPerfilCliente> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _correoController;
  late TextEditingController _direccionController;
  late TextEditingController _telefonoController;
  late String _docId;
  io.File? imagen;
  String? imageUrl;
  final picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    _nombreController = TextEditingController();
    _apellidoController = TextEditingController();
    _correoController = TextEditingController();
    _direccionController = TextEditingController();
    _telefonoController = TextEditingController();
    _cargarDatosCliente();
  }

  Future<void> _cargarDatosCliente() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: widget.correo)
          .limit(1)
          .get();
      if(querySnapshot.docs.isNotEmpty){
        DocumentSnapshot clienteSnapshot = querySnapshot.docs.first;
        _docId = clienteSnapshot.id;
        Map<String, dynamic>? datosCliente = clienteSnapshot.data() as Map<String, dynamic>?;

        if(datosCliente != null){
          setState(() {
            _nombreController.text = datosCliente['nombre'] ?? '';
            _apellidoController.text = datosCliente['apellido'] ?? '';
            _direccionController.text = datosCliente['direccion'] ?? '';
            _telefonoController.text = datosCliente['telefono'] ?? '';
            imageUrl = datosCliente['imagen'];
          });
        }else{
          print('No se encontraron datos en el correo del cliente.');
        }
      } else{
        print('El cliente con el correo ${widget.correo} no existe');
      }
    } catch(error) {
      print('Error al cargar los datos del cliente: $error');
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

  Future<void> actualizarCliente() async {
    if(_formKey.currentState!.validate()) {
      try {
        String? newImageUrl;
        if (imagen != null) {
          String imagePath = 'perfil/${widget.correo}/${DateTime.now().toString()}.jpg';
          TaskSnapshot uploadTask = await FirebaseStorage.instance.ref(imagePath).putFile(imagen!);
          newImageUrl = await uploadTask.ref.getDownloadURL();
        }

        await FirebaseFirestore.instance.collection('usuarios').doc(_docId).update({
          'nombre': _nombreController.text.trim(),
          'apellido': _apellidoController.text.trim(),
          'telefono': _telefonoController.text.trim(),
          'direccion': _direccionController.text.trim(),
          if (newImageUrl != null) 'imagen': newImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente actualizado'),
              backgroundColor: AppMaterial().getColorAtIndex(2)),
        );
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeUsuario(correo: widget.correo)),
        );
      } catch (error) {
        print('Error al actualizar el cliente: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el cliente')));
      }
    }
  }

  @override
  void dispose(){
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: imagen != null
                      ? Image.file(imagen!, height: 300)
                      : imageUrl != null
                      ? Image.network(imageUrl!, height: 300)
                      : Image.asset('img/tucanemp.png', height: 100),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: ElevatedButton(
                    onPressed: () {
                      opciones(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      backgroundColor: Colors.green,
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: FaIcon(
                            FontAwesomeIcons.cameraAlt,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Editar imagen de perfil",
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
                    'Información personal',
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
                    controller: _nombreController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Nombre",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value==null||value.isEmpty) {
                        return 'Por favor, introduce un nombre';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 40),
                  child: TextFormField(
                    controller: _apellidoController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Apellido",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value==null||value.isEmpty) {
                        return 'Por favor, introduce un apellido';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                    controller: _direccionController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.home_sharp),
                      labelText: "Dirección",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value==null||value.isEmpty) {
                        return 'Por favor, introduce una dirección';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                    controller: _telefonoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone_android),
                      labelText: "Teléfono",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value==null||value.isEmpty) {
                        return 'Por favor, introduce un telefono';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: actualizarCliente,
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                      backgroundColor: AppMaterial().getColorAtIndex(1)
                  ),
                  child: Text("Actualizar Perfil",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
