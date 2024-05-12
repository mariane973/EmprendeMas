import 'package:emprende_mas/vistas/dataVendedor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

class FormVendedor extends StatefulWidget {
  const FormVendedor({super.key});

  @override
  State<FormVendedor> createState() => _FormVendedorState();
}

class _FormVendedorState extends State<FormVendedor> {
  final InsertarDatosVendedor insertarDatos = InsertarDatosVendedor();

  final String defaultimg = 'img/tucan2.png';
  late io.File? imagen = io.File('img/tucan2.png');
  final picker = ImagePicker();
  final form = GlobalKey<FormState>();
  late String _apellido;
  late String _ciudad;
  late String _direccion;
  late String _correo;
  late String _descripcion;
  late String _nombre;
  late String _emprendimiento;
  late int _telefono;

  Future<void> obtenerimagen() async {
    final imgurl = await picker.pickImage(source: ImageSource.gallery);
    if (imgurl != null) {
      setState(() {
        imagen = io.File(imgurl!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registar Vendedores"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Form(
            key: form,
            child: Column(
              children: [
                /*Center(
                  child: imagen != null ?
                  Image.file(imagen!) :
                  Image.asset(('img/tucan2.png'), height: 100),
                ),*/
              Center(
                child: imagen != null && imagen!.path.isNotEmpty ?
                Image.file(imagen!) :
                Image.asset('img/tucan2.png', height: 300, width: 300,),
              ),
                ElevatedButton(onPressed: obtenerimagen,
                    child: Text("Logo Emprendimiento")
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nombres",
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
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Apellidos",
                      hintText: "Ingrese sus apellidos",
                      filled: true,
                      fillColor: AppMaterial().getColorAtIndex(0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                      validator: (value) {
                        if (value==null || value.isEmpty){
                          return "Ingrese sus apellidos";
                        }else{
                          return null;
                        }
                      },
                      onSaved: (value){
                        _apellido=value!;
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Correo",
                        hintText: "Ingrese su correo",
                        filled: true,
                        fillColor: AppMaterial().getColorAtIndex(0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese su correo";
                        } else if(!value.contains("@")){
                          return "El correo no es válido";
                        }
                        else {
                          return null;
                        }
                      },
                      onSaved: (value){
                        _correo=value!;
                      }
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
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Nombre Emprendimiento",
                        hintText: "Ingrese el nombre del emprendimiento",
                        filled: true,
                        fillColor: AppMaterial().getColorAtIndex(0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                      validator: (value) {
                        if (value==null || value.isEmpty){
                          return "Ingrese el nombre del emprendimiento";
                        }else{
                          return null;
                        }
                      },
                      onSaved: (value){
                        _emprendimiento=value!;
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Descripción Emprendimiento",
                        hintText: "Ingrese la descripción del emprendimiento",
                        filled: true,
                        fillColor: AppMaterial().getColorAtIndex(0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                      validator: (value) {
                        if (value==null || value.isEmpty){
                          return "Ingrese la descripción del emprendimiento";
                        }else{
                          return null;
                        }
                      },
                      onSaved: (value){
                        _descripcion=value!;
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
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
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Ciudad",
                        hintText: "Ingrese su ciudad",
                        filled: true,
                        fillColor: AppMaterial().getColorAtIndex(0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                      validator: (value) {
                        if (value==null || value.isEmpty){
                          return "Ingrese su ciudad";
                        }else{
                          return null;
                        }
                      },
                      onSaved: (value){
                        _ciudad =value!;
                      }
                  ),
                ),
                ElevatedButton(onPressed: (){
                  if(form.currentState!.validate()){
                    form.currentState!.save();
                    insertarDatos.guardarDatos(
                        imagen: imagen!,
                        apellido: _apellido,
                        ciudad: _ciudad,
                        direccion: _direccion,
                        correo: _correo,
                        descripcion: _descripcion,
                        nombre: _nombre,
                        emprendimiento: _emprendimiento,
                        telefono: _telefono
                    );
                  }
                },

                    child: Text("Guardar")
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
