import 'package:emprende_mas/vistas/dataProducto.dart';
import 'package:emprende_mas/vistas/emprendedores/homevendedor.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

class FormProducto extends StatefulWidget {
  const FormProducto({super.key});

  @override
  State<FormProducto> createState() => _FormProductoState();
}

class _FormProductoState extends State<FormProducto> {
  final InsertarDatosProducto insertarDatos = InsertarDatosProducto();

  final String defaultimg = 'img/tucan2.png';
  io.File? imagen;
  final picker = ImagePicker();
  final form = GlobalKey<FormState>();
  late String _categoria;
  late String _descripcion;
  late String _nombre;
  late int _precio;
  late int _stock;

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
        title: Text("Registar Productos"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: form,
            child: Column(
                children: [
                  Center(
                    child: imagen != null ?
                    Image.file(imagen!, height: 300) :
                    Image.asset(('img/tucanemp.png'), height: 100),
                  ),
                  ElevatedButton(onPressed: obtenerimagen,
                      style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                          backgroundColor: AppMaterial().getColorAtIndex(1)
                      ),
                      child: Text("Imagen Producto",
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
                        hintText: "Ingrese el nombre",
                        filled: true,
                        fillColor: AppMaterial().getColorAtIndex(0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                      validator: (value) {
                        if (value==null || value.isEmpty){
                          return "Ingrese el nombre";
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
                          labelText: "Descripción",
                          hintText: "Ingrese la descripción",
                          filled: true,
                          fillColor: AppMaterial().getColorAtIndex(0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                        validator: (value) {
                          if (value==null || value.isEmpty){
                            return "Ingrese la descripción";
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
                          labelText: "Categoría",
                          hintText: "Ingrese la categoría",
                          filled: true,
                          fillColor: AppMaterial().getColorAtIndex(0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingrese la categoría";
                          }
                          else {
                            return null;
                          }
                        },
                        onSaved: (value){
                          _categoria=value!;
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Precio",
                          hintText: "Ingrese el precio",
                          filled: true,
                          fillColor: AppMaterial().getColorAtIndex(0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                        validator: (value) {
                          if (value==null || value.isEmpty){
                            return "Ingrese el precio";
                          }else{
                            return null;
                          }
                        },
                        onSaved: (value){
                          _precio=int.parse(value!);
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Stock",
                          hintText: "Ingrese el stock",
                          filled: true,
                          fillColor: AppMaterial().getColorAtIndex(0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                        validator: (value) {
                          if (value==null || value.isEmpty){
                            return "Ingrese el stock";
                          }else{
                            return null;
                          }
                        },
                        onSaved: (value){
                          _stock=int.parse(value!);
                        }
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    if(form.currentState!.validate()){
                      form.currentState!.save();
                      insertarDatos.guardarDatos(
                          imagen: imagen!,
                          categoria: _categoria,
                          descripcion: _descripcion,
                          nombre: _nombre,
                          precio: _precio,
                          stock: _stock
                      );
                    }Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeVendedor()));
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
                ]
            ),
          ),
        ),
      ),
    );
  }
}
