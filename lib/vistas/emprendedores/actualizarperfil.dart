import 'package:emprende_mas/vistas/emprendedores/homevendedor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:emprende_mas/material.dart';

class EditarPerfilVendedor extends StatefulWidget {
  final String correo;

  EditarPerfilVendedor({required this.correo});

  @override
  State<EditarPerfilVendedor> createState() => _EditarPerfilVendedorState();
}

class _EditarPerfilVendedorState extends State<EditarPerfilVendedor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _descripcionController;
  late TextEditingController _emprendimientoController;
  late TextEditingController _ciudadController;
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
    _descripcionController = TextEditingController();
    _emprendimientoController = TextEditingController();
    _ciudadController = TextEditingController();
    _direccionController = TextEditingController();
    _telefonoController = TextEditingController();
    _cargarDatosVendedor();
  }

  Future<void> _cargarDatosVendedor() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('vendedores')
          .where('correo', isEqualTo: widget.correo)
          .limit(1)
          .get();
      if(querySnapshot.docs.isNotEmpty){
        DocumentSnapshot vendedorSnapshot = querySnapshot.docs.first;
        _docId = vendedorSnapshot.id;
        Map<String, dynamic>? datosVendedor = vendedorSnapshot.data() as Map<String, dynamic>?;

        if(datosVendedor != null){
          setState(() {
            _nombreController.text = datosVendedor['nombre'] ?? '';
            _apellidoController.text = datosVendedor['apellido'] ?? '';
            _descripcionController.text = datosVendedor['descripcion_emprendimiento'] ?? '';
            _emprendimientoController.text = datosVendedor['nombre_emprendimiento'] ?? '';
            _ciudadController.text = datosVendedor['ciudad'] ?? '';
            _direccionController.text = datosVendedor['direccion'] ?? '';
            _telefonoController.text = (datosVendedor['telefono'] != null) ? datosVendedor['telefono'].toString() : '';
            imageUrl = datosVendedor['logo_emprendimiento'];
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

  Future<void> actualizarVendedor() async {
    if(_formKey.currentState!.validate()) {
      try {
        String? newImageUrl;
        if (imagen != null) {
          String imagePath = 'imgvendedores/${widget.correo}/${DateTime.now().toString()}.jpg';
          TaskSnapshot uploadTask = await FirebaseStorage.instance.ref(imagePath).putFile(imagen!);
          newImageUrl = await uploadTask.ref.getDownloadURL();
        }

        await FirebaseFirestore.instance.collection('vendedores').doc(_docId).update({
          'nombre': _nombreController.text.trim(),
          'apellido': _apellidoController.text.trim(),
          'descripcion_emprendimiento': _descripcionController.text.trim(),
          'nombre_emprendimiento': _emprendimientoController.text.trim(),
          'ciudad': _ciudadController.text.trim(),
          'telefono': _telefonoController.text.trim(),
          'direccion': _direccionController.text.trim(),
          if (newImageUrl != null) 'logo_emprendimiento': newImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vendedor actualizado'),
              backgroundColor: AppMaterial().getColorAtIndex(2)),
        );
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeVendedor(correo: widget.correo)),
        );
      } catch (error) {
        print('Error al actualizar el vendedor: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el vendedor')));
      }
    }
  }

  @override
  void dispose(){
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _descripcionController.dispose();
    _emprendimientoController.dispose();
    _ciudadController.dispose();
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
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
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
                              "Editar Logo Emprendimiento",
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                    controller: _emprendimientoController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.business),
                      labelText: "Nombre Emprendimiento",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty){
                        return "Por favor, introduce el nombre del emprendimiento";
                      }else{
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                    controller: _descripcionController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description_rounded),
                      labelText: "Descripción Emprendimiento",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty){
                        return "Por favor, introduce la descripción del emprendimiento";
                      }else{
                        return null;
                      }
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
                    controller: _ciudadController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_city_rounded),
                      labelText: "Ciudad",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty){
                        return "Por favor, introduce su ciudad";
                      }else{
                        return null;
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: actualizarVendedor,
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
