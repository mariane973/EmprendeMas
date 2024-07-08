import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubDetalleServicioC extends StatelessWidget {
  final String correo;
  final Map<String, dynamic> servicio;

  SubDetalleServicioC ({required this.servicio, required this.correo});

  void agregarAlCarrito(BuildContext context) async {
    try {
      String userEmail = correo;

      var carritoSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userEmail)
          .collection('carrito')
          .where('nombre', isEqualTo: servicio['nombre'])
          .get();

      if (carritoSnapshot.docs.isEmpty) {

        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userEmail)
            .collection('carrito')
            .add({
          'nombre': servicio['nombre'],
          'imagen': servicio['imagen'],
          'precio': servicio['precioTotal'],
          'descripcion': servicio['descripcion'],
          'categoria': servicio['categoria'],
          'cantidad': 1,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('¡Servicio agregado al carrito!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: AppMaterial().getColorAtIndex(2),
        ));
      } else {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('¡Este servicio ya está en tu carrito!',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                )),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      print('Error al agregar servicio al carrito: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al agregar servicio al carrito'),
        duration: Duration(seconds: 2),
      ));
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
          title: Text(servicio['nombre'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
          backgroundColor: AppMaterial().getColorAtIndex(1),
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
                            color: AppMaterial().getColorAtIndex(1),
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
                              .getColorAtIndex(1),
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
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(servicio['imagen'],
                    width: 200, height: 200,)),
            ),
            RichText(
              text: TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.normal
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '${servicio['nombre']} ',style: TextStyle(fontWeight: FontWeight.bold)),
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
                      TextSpan(text: '\$${servicio['precioTotal']}',style: TextStyle(
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
                          TextSpan(text: '${servicio['descripcion']}'),
                        ]
                    ),
                  ),
                  if (servicio['oferta'] == 'Sí') ...[
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
                            TextSpan(text: '${servicio['descuento']}%'),
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
                  padding: const EdgeInsets.only(top: 30),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal:120),
                    child: ElevatedButton(
                        onPressed: (){
                          agregarAlCarrito(context);
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
                            Text(
                              "Añadir al carrito",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                        width: double.infinity,
                        height: 700,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppMaterial().getColorAtIndex(1),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'También te puede interesar',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 18, top: 15),
                                  child: Row(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 120,
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
                                            child: servicio['imagen'] != null
                                                ? Image.network(
                                              servicio['imagen'],
                                              fit: BoxFit.cover,
                                            )
                                                : Placeholder(),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 18),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width *
                                                0.56,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  servicio['nombre'],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.white
                                                  ),
                                                ),
                                                Text(
                                                  servicio['descripcion'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppMaterial().getColorAtIndex(2)
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(top: 5),
                                                  child: Text(
                                                    ' \$${servicio['precioTotal']} COP',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 18, top: 15),
                                  child: Row(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 120,
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
                                            child: servicio['imagen'] != null
                                                ? Image.network(
                                              servicio['imagen'],
                                              fit: BoxFit.cover,
                                            )
                                                : Placeholder(),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 18),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width *
                                                0.56,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  servicio['nombre'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  servicio['descripcion'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(top: 18),
                                                  child: Text(
                                                    ' \$${servicio['precioTotal']} COP',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppMaterial()
                                                          .getColorAtIndex(2),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),
                                )
                              ]
                          ),
                        ))
                ))
          ],
        ),

      ),
    );
  }
}