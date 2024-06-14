import 'package:emprende_mas/vistas/emprendedores/productosVendedor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:emprende_mas/material.dart';

class EditarProductoVendedor extends StatefulWidget {
  final String correo;
  final String uidProducto;

  EditarProductoVendedor({required this.uidProducto, required this.correo});

  @override
  State<EditarProductoVendedor> createState() => _EditarProductoVendedorState();
}

class _EditarProductoVendedorState extends State<EditarProductoVendedor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _categoriaController;
  late TextEditingController _stockController;
  late TextEditingController _precioController;
  io.File? imagen;
  String? imageUrl;
  final picker = ImagePicker();

  String? categoriaElegida;
  List<String> listCategoria = [
    "Accesorios", "Comida", "Ropa", "Manualidades", "Plantas", "Cuidado Personal", "Servicios", "Venta de Garaje"
  ];

  @override
  void initState(){
    super.initState();
    _nombreController = TextEditingController();
    _descripcionController = TextEditingController();
    _categoriaController = TextEditingController();
    _stockController = TextEditingController();
    _precioController = TextEditingController();
    _cargarDatosProductoV();
  }

  Future<void> _cargarDatosProductoV() async {
    try {
      DocumentSnapshot productoSnapshot = await FirebaseFirestore.instance
          .collection('vendedores')
          .doc(widget.correo)
          .collection('productos')
          .doc(widget.uidProducto)
          .get();
      if(productoSnapshot.exists){
        Map<String, dynamic>? datosProductoV = productoSnapshot.data() as Map<String, dynamic>?;

        if(datosProductoV != null){
          setState(() {
            _nombreController.text = datosProductoV['nombre'] ?? '';
            _descripcionController.text = datosProductoV['descripcion'] ?? '';
            _categoriaController.text = datosProductoV['categoria'] ?? '';
            categoriaElegida = datosProductoV['categoria'] ?? '';
            _stockController.text = (datosProductoV['stock'] != null) ? datosProductoV['stock'].toString() : '';
            _precioController.text = (datosProductoV['precio'] != null) ? datosProductoV['precio'].toString() : '';
            imageUrl = datosProductoV['imagen'];
          });
        }else{
          print('No se encontraron datos para el producto con el UID: ${widget.uidProducto}');
        }
      } else{
        print('El producto con el UID ${widget.uidProducto} no existe');
      }
    } catch(error) {
      print('Error al cargar los datos del producto: $error');
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
          String imagePath = 'imgproductos/${widget.uidProducto}/${DateTime.now().toString()}.jpg';
          TaskSnapshot uploadTask = await FirebaseStorage.instance.ref(imagePath).putFile(imagen!);
          newImageUrl = await uploadTask.ref.getDownloadURL();
        }

        await FirebaseFirestore.instance
            .collection('vendedores')
            .doc(widget.correo)
            .collection('productos')
            .doc(widget.uidProducto)
            .update({
          'nombre': _nombreController.text.trim(),
          'descripcion': _descripcionController.text.trim(),
          'categoria': categoriaElegida,
          'precio': _precioController.text.trim(),
          'stock': _stockController.text.trim(),
          if (newImageUrl != null) 'imagen': newImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto actualizado'),
              backgroundColor: AppMaterial().getColorAtIndex(2)),
        );
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ProductosV(correo: widget.correo)),
        );
      } catch (error) {
        print('Error al actualizar el Producto: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el producto')));
      }
    }
  }

  @override
  void dispose(){
    _nombreController.dispose();
    _descripcionController.dispose();
    _categoriaController.dispose();
    _stockController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Producto'),
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
                              "Editar Imagen Producto",
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
                      left: 20, right: 20, bottom: 40),
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
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: DropdownButtonFormField<String>(
                    value: categoriaElegida,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.category),
                      labelText: "Categoría",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    dropdownColor: Colors.grey[200],
                    items: listCategoria.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        categoriaElegida = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecciona una categoría';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 40),
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 40),
                  child: TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                      labelText: "Stock",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value==null||value.isEmpty) {
                        return 'Por favor, introduce el stock';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: actualizarVendedor,
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                      backgroundColor: AppMaterial().getColorAtIndex(1)
                  ),
                  child: Text("Actualizar Producto",
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
