import 'package:emprende_mas/vistas/emprendedores/actualizarServicio.dart';
import 'package:emprende_mas/vistas/emprendedores/serviciosVendedor.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';
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
        gradient: LinearGradient(
          colors: [AppMaterial().getColorAtIndex(0),AppMaterial().getColorAtIndex(0),Colors.white, Colors.white ],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.servicio['nombre'],
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
                    child: Image.network(widget.servicio['imagen'],
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
                      TextSpan(text: '${widget.servicio['nombre']} ',style: TextStyle(fontWeight: FontWeight.bold)),
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
                        TextSpan(text: '\$${widget.servicio['precio']}',style: TextStyle(
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
                          TextSpan(text: '${widget.servicio['descripcion']}'),
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
                          TextSpan(text: '${widget.servicio['categoria']}'),
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
      ),
    );
  }
}