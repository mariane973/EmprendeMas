import 'package:EmprendeMas/vistas/emprendedores/actualizarProducto.dart';
import 'package:EmprendeMas/vistas/emprendedores/homevendedor.dart';
import 'package:EmprendeMas/vistas/emprendedores/productosVendedor.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

class DetalleProductoV extends StatefulWidget {
  final Map<String, dynamic> producto;
  final String uidProducto;
  final String correo;

  DetalleProductoV ({required this.producto, required this.uidProducto, required this.correo});

  @override
  State<DetalleProductoV> createState() => _DetalleProductoVState();
}

class _DetalleProductoVState extends State<DetalleProductoV> {

  void ShowAlert(){
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "Confirmar eliminación",
      text: "¿Estás seguro de que deseas eliminar este producto?",
      confirmBtnText: "Eliminar",
      cancelBtnText: "Cancelar",
      onConfirmBtnTap: () {
        _eliminarProducto(widget.correo, widget.uidProducto, context);
      }
    );
  }

  Future<void> _eliminarProducto (String correo, String uidProducto, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('vendedores')
          .doc(correo)
          .collection('productos')
          .doc(uidProducto)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El producto ha sido eliminado exitosamente',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
            backgroundColor: AppMaterial().getColorAtIndex(2)
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProductosV(correo: correo)),
      );

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el producto: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            widget.producto['nombre'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppMaterial().getColorAtIndex(2),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  Text(
                    'Regresar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.home),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeVendedor(correo: widget.correo)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 130),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: AppMaterial().getColorAtIndex(2),
                              fontSize: 16,
                              fontWeight: FontWeight.normal
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Detalles del producto',style: TextStyle(fontWeight: FontWeight.w500)),
                          ]
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 22),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: AppMaterial().getColorAtIndex(2),
                            size: 17,
                          ),
                          onPressed: () {
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 200,
                height: 230,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: widget.producto['imagen'] != null
                      ? Image.network(
                    widget.producto['imagen'],
                    fit: BoxFit.cover,
                  )
                      : Placeholder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.normal
                      ),
                      children: <TextSpan>[
                        TextSpan(text: '${widget.producto['nombre']} ',style: TextStyle(fontWeight: FontWeight.bold)),
                      ]
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: AppMaterial().getColorAtIndex(1),
                          fontSize: 22,
                          fontWeight: FontWeight.normal
                      ),
                      children: <TextSpan>[
                        TextSpan(text: '\$${widget.producto['precioTotal']}',style: TextStyle(
                            fontWeight: FontWeight.bold, height: 1.6,
                            fontSize: 19
                        ),
                        ),
                      ]
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Descripción: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.2)),
                            TextSpan(text: '${widget.producto['descripcion']}'),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.normal
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Categoría: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.6)),
                            TextSpan(text: '${widget.producto['categoria']}'),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.normal
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Stock: ', style: TextStyle(fontWeight: FontWeight.bold, height: 1.6)),
                            TextSpan(text: '${widget.producto['stock']}'),
                          ]
                      ),
                    ),
                    if (widget.producto['oferta'] == 'Sí') ...[
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Descuento: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.2)),
                              TextSpan(text: '${widget.producto['descuento']}% dcto', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                            ]
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ElevatedButton(
                                onPressed: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => EditarProductoVendedor(uidProducto: widget.uidProducto, correo: widget.correo)
                                    )
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                      Color>(AppMaterial().getColorAtIndex(1)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.white),
                                    SizedBox(width: 25),
                                    Text(
                                      "Editar",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: (){
                                    ShowAlert();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                      Color>(Colors.red),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.white),
                                    SizedBox(width: 20),
                                    Text(
                                      "Eliminar",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}