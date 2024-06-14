import 'package:emprende_mas/vistas/emprendedores/actualizarProducto.dart';
import 'package:emprende_mas/vistas/emprendedores/productosVendedor.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';
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
        SnackBar(content: Text('El producto ha sido eliminado exitosamente'),
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
        gradient: LinearGradient(
          colors: [AppMaterial().getColorAtIndex(0),AppMaterial().getColorAtIndex(0),Colors.white, Colors.white ],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.producto['nombre'],
            style: TextStyle(
                fontWeight: FontWeight.w500
            ),
          ),
          backgroundColor: AppMaterial().getColorAtIndex(0),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 50),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(widget.producto['imagen'],
                        width: 200, height: 200)
                ),
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.normal
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '${widget.producto['nombre']} ',style: TextStyle(fontWeight: FontWeight.bold)),
                    ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.normal
                      ),
                      children: <TextSpan>[
                        TextSpan(text: '\$${widget.producto['precio']}',style: TextStyle(
                            fontWeight: FontWeight.bold, height: 1.6,
                            fontSize: 19
                        ),
                        ),
                      ]
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Descripción: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.6)),
                          TextSpan(text: '${widget.producto['descripcion']}'),
                        ]
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
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
                            fontSize: 18,
                            fontWeight: FontWeight.normal
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Stock: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.6)),
                          TextSpan(text: '${widget.producto['stock']}'),
                        ]
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => EditarProductoVendedor(uidProducto: widget.uidProducto, correo: widget.correo))
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
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
