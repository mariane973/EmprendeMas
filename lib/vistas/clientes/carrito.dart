import 'package:EmprendeMas/home.dart';
import 'package:EmprendeMas/vistas/clientes/pedidosC.dart';
import 'package:EmprendeMas/vistas/clientes/productosCliente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class ProductosCarrito extends StatefulWidget {
  final String correo;


  const ProductosCarrito({required this.correo});

  @override
  _ProductosCarritoState createState() => _ProductosCarritoState();
}

class _ProductosCarritoState extends State<ProductosCarrito> {
  late List<dynamic> _productos = [];

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    try {
      var userDocRef = FirebaseFirestore.instance.collection('usuarios').doc(
          widget.correo);
      var carritoCollection = userDocRef.collection('carrito');
      var carritoSnapshot = await carritoCollection.get();

      if (carritoSnapshot.docs.isNotEmpty) {
        setState(() {
          _productos = carritoSnapshot.docs.map((doc) => doc.data()).toList();
        });
      } else {
        print('El carrito para ${widget.correo} está vacío');
      }
    } catch (e) {
      print('Error al cargar productos del carrito: $e');
    }
  }

  Future<void> _finalizarCompra(BuildContext context) async {
    try {
      var userDocRef = FirebaseFirestore.instance.collection('usuarios').doc(widget.correo);
      var carritoCollection = userDocRef.collection('carrito');
      var carritoSnapshot = await carritoCollection.get();

      if (carritoSnapshot.docs.isNotEmpty) {
        var pedidoId = FirebaseFirestore.instance.collection('pedidos').doc().id;
        var pedidoDocRef = userDocRef.collection('pedidos').doc(pedidoId);

        await pedidoDocRef.set({
          'pedidoId': pedidoId,
          'fecha': FieldValue.serverTimestamp(),
          'total': _calcularTotal(),
          'usuarioId': widget.correo,
          'estado': 'Pedido solicitado'
        });

        List<Map<String, dynamic>> productos = carritoSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        for (var producto in productos) {
          print('Producto del carrito: $producto');

          if (producto.containsKey('correoV') && producto['correoV'] != null) {
            String correoVendedor = producto['correoV'];

            var vendedorQuerySnapshot = await FirebaseFirestore.instance.collection('vendedores')
                .where('correo', isEqualTo: correoVendedor)
                .get();

            if (vendedorQuerySnapshot.docs.isNotEmpty) {
              var vendedorDoc = vendedorQuerySnapshot.docs[0];
              var vendedorId = vendedorDoc.id;

              await pedidoDocRef.collection('productos').doc(producto['nombre']).set({
                'nombre': producto['nombre'],
                'descripcion': producto['descripcion'],
                'precio': producto['precio'],
                'cantidad': producto['cantidad'],
                'imagen': producto['imagen'],
                'vendedorId': vendedorId,
              });

              print('Producto agregado a la subcolección de productos del cliente: ${producto['nombre']}');

              var vendedorPedidosCollection = FirebaseFirestore.instance.collection('vendedores').doc(vendedorId).collection('pedidos');
              var pedidoVendedorDocRef = vendedorPedidosCollection.doc(pedidoId);

              await pedidoVendedorDocRef.set({
                'pedidoId': pedidoId,
                'fecha': FieldValue.serverTimestamp(),
                'total': producto['precio'] * producto['cantidad'],
                'usuarioId': widget.correo,
                'producto': {
                  'nombre': producto['nombre'],
                  'descripcion': producto['descripcion'],
                  'precio': producto['precio'],
                  'cantidad': producto['cantidad'],
                  'imagen': producto['imagen'],
                },
                'estado': 'Pedido aceptado'
              });

              print('Pedido agregado a la subcolección de pedidos del vendedor: ${producto['nombre']}');
            } else {
              print('No se encontró el vendedor con correo: $correoVendedor');
            }
          } else {
            print('Correo del vendedor es nulo o no está definido en el producto.');
          }
        }
        for (var doc in carritoSnapshot.docs) {
          await carritoCollection.doc(doc.id).delete();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pedido realizado correctamente')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PedidosCliente(correo: widget.correo),
          ),
        );
      } else {
        print('El carrito está vacío.');
      }
    } catch (e) {
      print('Error al finalizar la compra: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al finalizar la compra')),
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de compras',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: _productos.isEmpty
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              '¡Tu carrito está vacío!',
              style: TextStyle(
                color: AppMaterial().getColorAtIndex(2),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: 30),
              child: ElevatedButton(
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> Productos()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<
                      Color>(AppMaterial().getColorAtIndex(1)),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        'Agrega productos al carrito',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          Icons.card_travel,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),),
            ),
          )
        ],
      )
          : Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 110, right: 110),
              child: Row(
                children: [
                  Text('Revisa tu carrito',
                    style: TextStyle(
                        color: AppMaterial().getColorAtIndex(1),
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                    ),),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: AppMaterial().getColorAtIndex(
                            1),
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: _productos.length,
                itemBuilder: (context, index) {
                // Formatea el precio usando NumberFormat
                String precioFormateado = NumberFormat.currency(
                locale: 'es_CO', // Define el locale para usar comas como separador
                symbol: '\$', // Símbolo de la moneda
                decimalDigits: 0, // Cantidad de decimales (0 para redondear a enteros)
                ).format(_productos[index]['precio']);
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20, bottom: 18, top: 15, right: 20),
                    child: Container(
                      height: 170,
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
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            height: 130,
                            margin: EdgeInsets.only(left: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                _productos[index]['imagen'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10),
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.56,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        _productos[index]['nombre'] ??
                                            'Nombre no disponible',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(
                                        _productos[index]['descripcion'],
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          ' \$$precioFormateado COP',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: AppMaterial()
                                                .getColorAtIndex(1),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: Colors.red,
                                                  size: 25,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (_productos[index]['cantidad'] >
                                                        1) {
                                                      _productos[index]['cantidad']--;
                                                    }
                                                  });
                                                },
                                              ),
                                              Text(
                                                _productos[index]['cantidad']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.add,
                                                  color: AppMaterial()
                                                      .getColorAtIndex(1),
                                                  size: 25,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _productos[index]['cantidad']++;
                                                  });
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 25),
                                                child: Container(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .end,
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () async {
                                                          try {
                                                            var carritoSnapshot = await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                'usuarios')
                                                                .doc(
                                                                widget.correo)
                                                                .collection(
                                                                'carrito')
                                                                .get();

                                                            if (index >= 0 &&
                                                                index <
                                                                    carritoSnapshot
                                                                        .docs
                                                                        .length) {
                                                              var docId = carritoSnapshot
                                                                  .docs[index]
                                                                  .id;

                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                  'usuarios')
                                                                  .doc(
                                                                  widget.correo)
                                                                  .collection(
                                                                  'carrito')
                                                                  .doc(docId)
                                                                  .delete();
                                                              _loadProductos();
                                                            }
                                                          } catch (error) {
                                                            print(
                                                                'Error al eliminar producto del carrito: $error');
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppMaterial().getColorAtIndex(1),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total de la compra',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, right: 25, left: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Valor de la compra: \$${_calcularcompra()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            'Envío: \$10000',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppMaterial().getColorAtIndex(7)
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1,
                            height: 20,
                          ),
                          Text(
                            'Valor total: \$${_calcularTotal()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppMaterial().getColorAtIndex(4)
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 65),
                              child: ElevatedButton(
                                onPressed: () => _finalizarCompra(context),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                      Color>(Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        'Finalizar compra',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: AppMaterial()
                                                .getColorAtIndex(1)
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.shopify,
                                          color: AppMaterial().getColorAtIndex(
                                              1),
                                          size: 30,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),),
                            ),
                          )
                        ],
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
  }

  double _calcularTotal() {
    double total = 0;
    double totalenv = 0;
    double envio = 10000;

    for (var producto in _productos) {
      double precio = producto['precio'] is String
          ? double.tryParse(producto['precio']) ?? 0.0
          : (producto['precio'] as num).toDouble();

      double cantidad = producto['cantidad'] is String
          ? double.tryParse(producto['cantidad']) ?? 0.0
          : (producto['cantidad'] as num).toDouble();

      total += precio * cantidad;
    }

    totalenv = total + envio;
    return totalenv;
  }

  double _calcularcompra() {
    double total = 0;

    for (var producto in _productos) {
      double precio = producto['precio'] is String
          ? double.tryParse(producto['precio']) ?? 0.0
          : (producto['precio'] as num).toDouble();

      double cantidad = producto['cantidad'] is String
          ? double.tryParse(producto['cantidad']) ?? 0.0
          : (producto['cantidad'] as num).toDouble();

      total += precio * cantidad;
    }

    return total;
  }
}