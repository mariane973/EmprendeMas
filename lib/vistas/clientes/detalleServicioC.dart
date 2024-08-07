import 'package:EmprendeMas/vistas/clientes/detallesEmprendimiento.dart';
import 'package:EmprendeMas/vistas/clientes/homeusuario.dart';
import 'package:EmprendeMas/vistas/obtenerProduServ.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetalleServicioC extends StatelessWidget {
  final String correo;
  final Map<String, dynamic> servicio;

  DetalleServicioC ({required this.servicio, required this.correo});

  Future<List<DocumentSnapshot>> obtenerServiciosSimilares() async {
    QuerySnapshot vendedoresSnapshot =
    await FirebaseFirestore.instance.collection('vendedores').get();

    List<QuerySnapshot> allServicesSnapshots = await Future.wait(
      vendedoresSnapshot.docs.map((vendedorDoc) {
        return vendedorDoc.reference
            .collection('servicios')
            .get();
      }).toList(),
    );

    List<DocumentSnapshot> serviciosSimilares = [];

    allServicesSnapshots.forEach((snapshot) {
      serviciosSimilares.addAll(snapshot.docs);
    });

    return serviciosSimilares;
  }

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
          'correoV': servicio['correoV'],
          'imagen': servicio['imagen'],
          'precio': servicio['precioTotal'],
          'descripcion': servicio['descripcion'],
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
          title: Text(
            servicio['nombre'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppMaterial().getColorAtIndex(1),
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
                        MaterialPageRoute(builder: (context) => HomeUsuario(correo: correo)),
                      );
                    },
                  ),
                ],
              ),
            ),

          ],
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
                child: servicio['imagen'] != null
                    ? Image.network(
                  servicio['imagen'],
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
                      TextSpan(text: '${servicio['nombre']} ',style: TextStyle(fontWeight: FontWeight.bold)),
                    ]
                ),
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
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
                height: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26, right: 26),
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
                            TextSpan(text: '${servicio['descuento']}% dcto', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red)),
                          ]
                      ),
                    ),
                  ]
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async{
                              final String idVendedor = servicio['correoV'];
                              List<Map<String, dynamic>> productos = await obtenerProductosDelVendedor(idVendedor);
                              List<Map<String, dynamic>> servicios = await obtenerServiciosDelVendedor(idVendedor);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubDetallesC(productosdata: productos, serviciosData: servicios, correo: correo)
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<
                                  Color>(AppMaterial().getColorAtIndex(3)),
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
                                  "Emprendedor",
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
                                        Icons.work_history_rounded,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: SingleChildScrollView(
                    child: Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 375,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppMaterial().getColorAtIndex(1),
                        ),
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
                            FutureBuilder<List<DocumentSnapshot>>(
                              future: obtenerServiciosSimilares(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Text('No se encontraron productos similares.');
                                } else {
                                  List<DocumentSnapshot>  serviciosSimilares = snapshot.data!;

                                  String nombreServicioActual = servicio['nombre'];
                                  serviciosSimilares =  serviciosSimilares.where((producto) =>
                                  producto['nombre'] != nombreServicioActual).toList();

                                  serviciosSimilares =  serviciosSimilares.take(10).toList();
                                  return SizedBox(
                                    height: 312,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:  serviciosSimilares.length,
                                      itemBuilder: (context, index) {
                                        var servicioSimilar =  serviciosSimilares[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DetalleServicioC(
                                                  servicio: servicioSimilar.data() as Map<String, dynamic>,
                                                  correo: correo,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Container(
                                              width: 180,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(18),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    spreadRadius: 4,
                                                    blurRadius: 7,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(18),
                                                      child: Image.network(
                                                        servicioSimilar['imagen'],
                                                        width: 160,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only( left: 10),
                                                    child: Text(
                                                      servicioSimilar['nombre'],
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 2, left: 10),
                                                    child: Text(
                                                      servicioSimilar['descripcion'],
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 17,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Center(
                                                      child: Text(
                                                        '\$${servicioSimilar['precioTotal']} COP',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: AppMaterial().getColorAtIndex(2),
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}