import 'package:emprende_mas/vistas/clientes/dataPerfil.dart';
import 'package:emprende_mas/vistas/clientes/homeperfil.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emprende_mas/material.dart';
import 'dart:io' as io;

class FormPerfil extends StatefulWidget {
  const FormPerfil({super.key});

  @override
  State<FormPerfil> createState() => _FormPerfilState();
}

class _FormPerfilState extends State<FormPerfil> {
  final InsertarDatosPerfil insertarDatos = InsertarDatosPerfil();

  final String defaultimg = 'img/tucanemp.png';
  io.File? imagen;
  final picker = ImagePicker();
  final form = GlobalKey<FormState>();
  late String _nombre;
  late String _direccion;
  late int _telefono;

  Future<void> selImagen(op) async {
    var pickedFile;
    if(op == 1){
      pickedFile = await picker.getImage(source: ImageSource.camera);
    }else{
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }
    setState(() {
      if(pickedFile != null){
        imagen = io.File(pickedFile.path);
      }else{
        print('No seleccionaste ninguna foto');
      }
    });
  }

  opciones(context){
    showDialog(context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  selImagen(1);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Colors.grey))
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text('Tomar una foto')),
                      Icon(Icons.camera_alt, color: Colors.green)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  selImagen(2);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(child: Text('Seleccionar Foto')),
                      Icon(Icons.image, color: Colors.green)
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
                      top: BorderSide(width: 1, color: Colors.grey)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text('Cancelar', style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                      ), textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Registrar Datos Usuario"),
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: form,
            child: Column(
              children: [
                Center(
                  child: imagen != null ?
                  Image.file(imagen!, height: 300) :
                  Image.asset(('img/tucanemp.png'), height: 100),
                ),
                ElevatedButton(
                  onPressed: () {
                    opciones(context);
                  },
                  style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                      backgroundColor: AppMaterial().getColorAtIndex(1)
                  ),
                  child: Text("Imagen Usuario",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nombre",
                      hintText: "Ingrese su nombre",
                      filled: true,
                      fillColor: AppMaterial().getColorAtIndex(0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty){
                        return "Ingrese su nombre";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (value){
                      _nombre=value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20,bottom: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Dirección",
                      hintText: "Ingrese su dirección",
                      filled: true,
                      fillColor: AppMaterial().getColorAtIndex(0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty){
                        return "Ingrese su dirección";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (value){
                      _direccion=value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Teléfono",
                        hintText: "Ingrese su teléfono",
                        filled: true,
                        fillColor: AppMaterial().getColorAtIndex(0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                      validator: (value) {
                        if (value==null || value.isEmpty){
                          return "Ingrese su teléfono";
                        }else{
                          return null;
                        }
                      },
                      onSaved: (value){
                        _telefono=int.parse(value!);
                      }
                  ),
                ),
                ElevatedButton(onPressed: (){
                  if(form.currentState!.validate()){
                    form.currentState!.save();
                    insertarDatos.guardarDatos(
                        imagen: imagen!,
                        direccion: _direccion,
                        nombre: _nombre,
                        telefono: _telefono
                    );
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeUsario(nombre: _nombre, imagen: imagen!))
                    );
                  }
                },
                  style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 45),
                      backgroundColor: AppMaterial().getColorAtIndex(1)
                  ),
                  child: Text("Guardar",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
