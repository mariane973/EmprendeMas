import 'package:EmprendeMas/vistas/emprendedores/actualizarServicio.dart';
import 'package:EmprendeMas/vistas/emprendedores/homevendedor.dart';
import 'package:EmprendeMas/vistas/emprendedores/servicioOfertaV.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

class DetalleServOfertaV extends StatefulWidget {
  final Map<String, dynamic> servicio;
  final String uidServicio;
  final String correo;

  DetalleServOfertaV({required this.servicio,required this.uidServicio, required this.correo});

  @override
  State<DetalleServOfertaV> createState() => _DetalleServOfertaVState();
}

class _DetalleServOfertaVState extends State<DetalleServOfertaV> {

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
        SnackBar(content: Text('El servicio ha sido eliminado exitosamente',
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
        MaterialPageRoute(builder: (context) => ServiciosOfertaV(correo: correo)),
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
                            color: AppMaterial()
                                .getColorAtIndex(2),
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
                  child: widget.servicio['imagen'] != null
                      ? Image.network(
                    widget.servicio['imagen'],
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
                        TextSpan(text: '${widget.servicio['nombre']} ',style: TextStyle(fontWeight: FontWeight.bold)),
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
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Descuento: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.6)),
                            TextSpan(text: '${widget.servicio['descuento']}% dcto', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                          ]
                      ),
                    ),
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