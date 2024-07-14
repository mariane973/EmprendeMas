import 'package:EmprendeMas/vistas/clientes/detallesEmprendimiento.dart';
import 'package:EmprendeMas/vistas/obtenerProduServ.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetalleProduOfertaC extends StatelessWidget {
  final Map<String, dynamic> producto;
  final String correo;

  DetalleProduOfertaC({required this.producto, required this.correo});

  Future<List<DocumentSnapshot>> obtenerProductosSimilares() async {
    String categoriaProducto = producto['categoria'];

    QuerySnapshot vendedoresSnapshot =
    await FirebaseFirestore.instance.collection('vendedores').get();

    List<QuerySnapshot> allProductsSnapshots = await Future.wait(
      vendedoresSnapshot.docs.map((vendedorDoc) {
        return vendedorDoc.reference
            .collection('productos')
            .where('categoria', isEqualTo: categoriaProducto)
            .get();
      }).toList(),
    );

    List<DocumentSnapshot> productosSimilares = [];

    allProductsSnapshots.forEach((snapshot) {
      productosSimilares.addAll(snapshot.docs);
    });

    return productosSimilares;
  }

  void agregarAlCarrito(BuildContext context) async {
    try {
      String userEmail = correo;

      var carritoSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userEmail)
          .collection('carrito')
          .where('nombre', isEqualTo: producto['nombre'])
          .get();

      if (carritoSnapshot.docs.isEmpty) {

        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userEmail)
            .collection('carrito')
            .add({
          'nombre': producto['nombre'],
          'correoV': producto['correoV'],
          'imagen': producto['imagen'],
          'precio': producto['precioTotal'],
          'descripcion': producto['descripcion'],
          'categoria': producto['categoria'],
          'cantidad': 1,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('¡Producto agregado al carrito!',
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
            child: Text('¡Este producto ya está en tu carrito!',
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
      print('Error al agregar producto al carrito: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al agregar producto al carrito'),
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
          title: Text(producto['nombre'],
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white
            ),
          ),
          backgroundColor: AppMaterial().getColorAtIndex(1),
        ),
        body: SingleChildScrollView(
          child: Column(
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
                  child: producto['imagen'] != null
                      ? Image.network(
                    producto['imagen'],
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
                        TextSpan(text: '${producto['nombre']} ',style: TextStyle(fontWeight: FontWeight.bold)),
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
                        TextSpan(text: '\$${producto['precioTotal']}',style: TextStyle(
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
                            TextSpan(text: '${producto['descripcion']}'),
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
                            TextSpan(text: '${producto['categoria']}'),
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
                            TextSpan(text: 'Stock: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.6)),
                            TextSpan(text: '${producto['stock']}'),
                          ]
                      ),
                    ),
                    if (producto['oferta'] == 'Sí') ...[
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
                              TextSpan(text: '${producto['descuento']}% dcto', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red) ),
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
                    padding: const EdgeInsets.only(top: 25, left: 20, right: 25),
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
                                final String idVendedor = producto['correoV'];
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
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 335,
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
                          future: obtenerProductosSimilares(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('No se encontraron productos similares.');
                            } else {
                              List<DocumentSnapshot> productosSimilares = snapshot.data!;

                              String nombreProductoActual = producto['nombre'];
                              productosSimilares = productosSimilares.where((producto) =>
                              producto['nombre'] != nombreProductoActual).toList();

                              productosSimilares = productosSimilares.take(10).toList();
                              return SizedBox(
                                height: 275,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productosSimilares.length,
                                  itemBuilder: (context, index) {
                                    var productoSimilar = productosSimilares[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetalleProduOfertaC(
                                              producto: productoSimilar.data() as Map<String, dynamic>,
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
                                                    productoSimilar['imagen'],
                                                    width: 160,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only( left: 10),
                                                child: Text(
                                                  productoSimilar['nombre'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 2, left: 10),
                                                child: Text(
                                                  productoSimilar['descripcion'],
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
                                                    '\$${productoSimilar['precioTotal']} COP',
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
            ],
          ),
        ),
      ),
    );
  }
}
