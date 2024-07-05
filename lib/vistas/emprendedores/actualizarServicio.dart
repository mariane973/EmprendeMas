import 'package:EmprendeMas/vistas/emprendedores/serviciosVendedor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:EmprendeMas/material.dart';

class EditarServicioVendedor extends StatefulWidget {
  final String correo;
  final String uidServicio;

  EditarServicioVendedor({required this.uidServicio, required this.correo});

  @override
  State<EditarServicioVendedor> createState() => _EditarServicioVendedorState();
}

class _EditarServicioVendedorState extends State<EditarServicioVendedor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _descuentoController;
  late TextEditingController _precioFinalController;
  io.File? imagen;
  String? imageUrl;
  final picker = ImagePicker();
  String? ofertaElegida;
  int _descuento = 0;

  @override
  void initState(){
    super.initState();
    _nombreController = TextEditingController();
    _descripcionController = TextEditingController();
    _precioController = TextEditingController();
    _descuentoController = TextEditingController();
    _precioFinalController = TextEditingController();
    _cargarDatosServicioV();
  }

  Future<void> _cargarDatosServicioV() async {
    try {
      DocumentSnapshot servicioSnapshot = await FirebaseFirestore.instance
          .collection('vendedores')
          .doc(widget.correo)
          .collection('servicios')
          .doc(widget.uidServicio)
          .get();
      if(servicioSnapshot.exists){
        Map<String, dynamic>? datosServicioV = servicioSnapshot.data() as Map<String, dynamic>?;

        if(datosServicioV != null){
          setState(() {
            _nombreController.text = datosServicioV['nombre'] ?? '';
            _descripcionController.text = datosServicioV['descripcion'] ?? '';
            _precioController.text = (datosServicioV['precio'] != null) ? datosServicioV['precio'].toString() : '';
            imageUrl = datosServicioV['imagen'];
            ofertaElegida = datosServicioV['oferta'] ?? 'No';
            _descuento = datosServicioV['descuento'] ?? 0;
            _descuentoController.text = _descuento.toString();
            _precioFinalController.text = (datosServicioV['precioTotal'] != null)
                ? datosServicioV['precioTotal'].toString()
                : '';
          });
        }else{
          print('No se encontraron datos para el servicio con el UID: ${widget.uidServicio}');
        }
      } else{
        print('El servico con el UID ${widget.uidServicio} no existe');
      }
    } catch(error) {
      print('Error al cargar los datos del servicio: $error');
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

  void _calcularPrecioFinal() {
    final precio = int.tryParse(_precioController.text.trim()) ?? 0;
    final descuento = int.tryParse(_descuentoController.text.trim()) ?? 0;
    final precioFinal = precio - (precio * descuento / 100);

    setState(() {
      _precioFinalController.text = precioFinal.toStringAsFixed(0);
    });
  }

  Future<void> actualizarServicio() async {
    if(_formKey.currentState!.validate()) {
      try {
        String? newImageUrl;
        if (imagen != null) {
          String imagePath = 'imgservicios/${widget.uidServicio}/${DateTime.now().toString()}.jpg';
          TaskSnapshot uploadTask = await FirebaseStorage.instance.ref(imagePath).putFile(imagen!);
          newImageUrl = await uploadTask.ref.getDownloadURL();
        }

        await FirebaseFirestore.instance
            .collection('vendedores')
            .doc(widget.correo)
            .collection('servicios')
            .doc(widget.uidServicio)
            .update({
          'nombre': _nombreController.text.trim(),
          'descripcion': _descripcionController.text.trim(),
          'precio': _precioController.text.trim(),
          'oferta': ofertaElegida,
          'descuento': _descuento,
          'precioTotal': int.tryParse(_precioFinalController.text.trim()) ?? 0,
          if (newImageUrl != null) 'imagen': newImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Servicio actualizado'),
              backgroundColor: AppMaterial().getColorAtIndex(2)),
        );
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ServiciosV(correo: widget.correo)),
        );
      } catch (error) {
        print('Error al actualizar el Servicio: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el Servicio')));
      }
    }
  }

  @override
  void dispose(){
    _nombreController.dispose();
    _descripcionController.dispose();
    _descuentoController.dispose();
    _precioController.dispose();
    _precioFinalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Servicio'),
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
                              "Editar Imagen Servicio",
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
                      prefixIcon: Icon(Icons.inventory_2_outlined),
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
                      left: 20, right: 20, bottom: 35),
                  child: TextFormField(
                    controller: _descripcionController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description_outlined),
                      labelText: "Descripción",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty){
                        return "Por favor, introduce la descripción del producto";
                      }else{
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 35),
                  child: TextFormField(
                    controller: _precioController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money_outlined),
                      labelText: "Precio",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value==null||value.isEmpty) {
                        return 'Por favor, introduce un precio';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _calcularPrecioFinal();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: DropdownButtonFormField<String>(
                    value: ofertaElegida,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.local_offer),
                      labelText: "Oferta",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    dropdownColor: Colors.grey[200],
                    items: ['Sí', 'No'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        ofertaElegida = newValue;
                        if (ofertaElegida == 'No') {
                          _descuento = 0;
                          _descuentoController.clear();
                        }
                        _calcularPrecioFinal();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecciona una opción';
                      }
                      return null;
                    },
                  ),
                ),
                if (ofertaElegida == 'Sí')
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 35),
                    child: TextFormField(
                      controller: _descuentoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.percent),
                        labelText: "Descuento (%)",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce el porcentaje de descuento';
                        }
                        if (int.tryParse(value) == null || int.parse(value) < 0 || int.parse(value) > 100) {
                          return 'Introduce un descuento válido entre 0 y 100';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _descuento = int.tryParse(value) ?? 0;
                          _calcularPrecioFinal();
                        });
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: TextFormField(
                    controller: _precioFinalController,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.price_check),
                      labelText: "Precio Final",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: actualizarServicio,
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                      backgroundColor: AppMaterial().getColorAtIndex(1)
                  ),
                  child: Text("Actualizar Servicio",
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