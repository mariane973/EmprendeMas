import 'package:EmprendeMas/vistas/dataServicio.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

class FormServicio extends StatefulWidget {
  final String correo;

  const FormServicio({required this.correo});

  @override
  State<FormServicio> createState() => _FormServicioState();
}

class _FormServicioState extends State<FormServicio> {
  final InsertarDatosServicio insertarDatos = InsertarDatosServicio();

  io.File? imagen;
  final picker = ImagePicker();
  final form = GlobalKey<FormState>();
  late String _descripcion;
  late String _nombre;
  late int _precio;
  late int _precioTotal = 0;
  final TextEditingController _precioTotalController = TextEditingController();
  String? ofertaElegida;
  int _descuento = 0;

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
  void initState() {
    super.initState();
    _descuento = 0;
    _precioTotal = 0;
    _precioTotalController.text = _precioTotal.toString();
    ofertaElegida = null;
  }

  void calcularPrecioTotal() {
    setState(() {
      if (ofertaElegida == 'Sí' && _descuento > 0) {
        _precioTotal = _precio - ((_precio * _descuento) ~/ 100);
      } else {
        _precioTotal = _precio;
      }
      _precioTotalController.text = _precioTotal.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registar Servicio"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: form,
            child: Column(
                children: [
                  Center(
                    child: imagen != null
                        ? Image.file(imagen!, height: 300)
                        : Image.asset('img/tucanemp.png', height: 100),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      opciones(context);
                    },
                    style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                        backgroundColor: AppMaterial().getColorAtIndex(1)
                    ),
                    child: Text("Imagen Servicio",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 35),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                        labelText: "Nombre",
                        hintText: "Ingrese el nombre",
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 35),
                    child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.description_outlined),
                          labelText: "Descripción",
                          hintText: "Ingrese la descripción",
                          filled: true,
                          fillColor: Colors.grey[200],
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
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money_outlined),
                          labelText: "Precio",
                          hintText: "Ingrese el precio",
                          filled: true,
                          fillColor: Colors.grey[200],
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
                        onChanged: (value) {
                          _precio = int.tryParse(value) ?? 0;
                          calcularPrecioTotal();
                        },
                        onSaved: (value){
                          _precio = int.tryParse(value!) ?? 0;
                          calcularPrecioTotal();
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Container(
                      padding: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: DropdownButtonFormField<String>(
                        hint: Text("¿Servicio en oferta?"),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.local_offer_outlined),
                        ),
                        dropdownColor: Colors.grey[200],
                        value: ofertaElegida,
                        onChanged: (newValue) {
                          setState(() {
                            ofertaElegida = newValue ?? 'No';
                            if (ofertaElegida == 'No') {
                              _descuento = 0;
                              calcularPrecioTotal();
                            } else if (ofertaElegida == 'Sí') {
                              _descuento = 0;
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Seleccione si el servicio está en oferta';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _descuento = (value == 'Sí') ? _descuento : 0;
                        },
                        items: ["Sí", "No"].map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (ofertaElegida == "Sí")
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.percent),
                          labelText: "Descuento",
                          hintText: "Ingrese el descuento (%)",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingrese el descuento";
                          } else{
                            return null;
                          }
                        },
                        onChanged: (value) {
                          _descuento = int.tryParse(value) ?? 0;
                          calcularPrecioTotal();
                        },
                        onSaved: (value) {
                          _descuento = int.tryParse(value!) ?? 0;
                          calcularPrecioTotal();
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 35, top: 15),
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.attach_money_outlined),
                        labelText: "Precio Total",
                        hintText: "Precio total con descuento",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                      controller: _precioTotalController,
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    if(form.currentState!.validate()){
                      form.currentState!.save();
                      insertarDatos.guardarServicioDatos (
                          imagen: imagen!,
                          descripcion: _descripcion,
                          nombre: _nombre,
                          precio: _precio,
                          correo: widget.correo,
                          context: context,
                          descuento: _descuento,
                          precioTotal: _precioTotal,
                          oferta: ofertaElegida!,
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
                ]
            ),
          ),
        ),
      ),
    );
  }
}