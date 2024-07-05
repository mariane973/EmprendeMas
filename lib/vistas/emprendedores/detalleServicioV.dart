import 'package:EmprendeMas/vistas/emprendedores/actualizarServicio.dart';
import 'package:EmprendeMas/vistas/emprendedores/serviciosVendedor.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

class DetalleServicioV extends StatefulWidget {
  final Map<String, dynamic> servicio;
  final String uidServicio;
  final String correo;

  DetalleServicioV ({required this.servicio, required this.uidServicio, required this.correo});

  @override
  State<DetalleServicioV> createState() => _DetalleServicioVState();
}

class _DetalleServicioVState extends State<DetalleServicioV> {

  void ShowAlert(){
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: "Confirmar eliminación",
        text: "¿Estás seguro de que deseas eliminar este servicio?",
        confirmBtnText: "Eliminar",
        cancelBtnText: "Cancelar",
        onConfirmBtnTap: () {
          _eliminarServicio(widget.correo, widget.uidServicio, context);
        }
    );
  }

  Future<void> _eliminarServicio (String correo, String uidProducto, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('vendedores')
          .doc(correo)
          .collection('servicios')
          .doc(uidProducto)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El servicio ha sido eliminado exitosamente'),
            backgroundColor: AppMaterial().getColorAtIndex(2)
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ServiciosV(correo: correo)),
      );

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el servicio: $error')),
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
          title: Text(widget.servicio['nombre'],
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white
            ),
          ),
          backgroundColor: AppMaterial().getColorAtIndex(2),
        ),
        body: Column(
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
                          TextSpan(text: 'Detalles del servicio',style: TextStyle(fontWeight: FontWeight.w500)),
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
            Padding(
              padding: const EdgeInsets.only( left: 10, right: 10, bottom: 10, top: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(widget.servicio['imagen'],
                      width: 200, height: 200)
              ),
            ),
            RichText(
              text: TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.normal
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '${widget.servicio['nombre']} ',style: TextStyle(fontWeight: FontWeight.bold)),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: AppMaterial().getColorAtIndex(1),
                        fontSize: 22,
                        fontWeight: FontWeight.normal
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '\$${widget.servicio['precioTotal']}',style: TextStyle(
                          fontWeight: FontWeight.bold, height: 1.6,
                          fontSize: 19
                      ),
                      ),
                    ]
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                          TextSpan(text: '${widget.servicio['descripcion']}'),
                        ]
                    ),
                  ),
                  if (widget.servicio['oferta'] == 'Sí') ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Descuento: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.2)),
                              TextSpan(text: '${widget.servicio['descuento']}%'),
                            ]
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ElevatedButton(
                              onPressed: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => EditarServicioVendedor(uidServicio: widget.uidServicio, correo: widget.correo))
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
    );
  }
}