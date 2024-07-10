import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EmprendeMas/material.dart';
import 'package:EmprendeMas/vistas/clientes/slidebarusuario.dart';

class PedidosCliente extends StatelessWidget {
  final String correo;

  PedidosCliente({required this.correo});

  Future<List<Map<String, dynamic>>> _loadPedidos() async {
    final userDocRef = FirebaseFirestore.instance.collection('usuarios').doc(correo);
    final pedidosSnapshot = await userDocRef.collection('pedidos').get();

    List<Map<String, dynamic>> pedidos = [];
    for (final pedidoDoc in pedidosSnapshot.docs) {
      final productosSnapshot = await pedidoDoc.reference.collection('productos').get();
      final usuarioSnapshot = await FirebaseFirestore.instance.collection('usuarios').doc(correo).get();
      final usuarioData = usuarioSnapshot.data();

      List<Map<String, dynamic>> productos = [];
      for (var productoDoc in productosSnapshot.docs) {
        final productoData = productoDoc.data();
        productos.add(productoData);
      }

      pedidos.add({
        'pedidoId': pedidoDoc.id,
        'cliente': correo,
        'direccion': usuarioData!['direccion'],
        'telefono': usuarioData['telefono'],
        'estado': pedidoDoc.data()['estado'],
        'productos': productos,
      });
    }

    return pedidos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadPedidos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar pedidos'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppMaterial().getColorAtIndex(6),
              iconTheme: IconThemeData(color: AppMaterial().getColorAtIndex(0)),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(
                      Icons.menu_rounded,
                      size: 45.0,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              actions: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 35),
                      height: 45,
                      width: 260,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "EMPRENDEMAS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: AppMaterial().getColorAtIndex(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20, top: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset("img/tucanemp.png", height: 50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            drawer: SlidebarUsuario(correo: correo),
            body: Container(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        '¡Aún no tienes pedidos!',
                        style: TextStyle(
                          color: AppMaterial().getColorAtIndex(2),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        List<Map<String, dynamic>> listaPedidos = snapshot.data!;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, AppMaterial().getColorAtIndex(0)],
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: AppMaterial().getColorAtIndex(6),
              iconTheme: IconThemeData(color: AppMaterial().getColorAtIndex(0)),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(
                      Icons.menu_rounded,
                      size: 45.0,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              actions: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 35),
                      height: 45,
                      width: 260,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "EMPRENDEMAS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: AppMaterial().getColorAtIndex(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20, top: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset("img/tucanemp.png", height: 50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            drawer: SlidebarUsuario(correo: correo),
            body: SingleChildScrollView(
              child: Column(
                children:
                listaPedidos.map((pedido) {
                  return
                    Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pedido realizado por: ${pedido['cliente']}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Dirección: ${pedido['direccion']}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          "Teléfono: ${pedido['telefono']}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Estado del pedido: ${pedido['estado']}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getEstadoColor(pedido['estado']),
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: pedido['productos'].length,
                          itemBuilder: (context, index) {
                            final producto = pedido['productos'][index];
                            final imagenUrl = producto['imagen'] ?? '';

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(imagenUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Producto/Servicio: ${producto['nombre']}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Cantidad: ${producto['cantidad']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          "Precio unitario: \$${producto['precio']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Pedido Aceptado':
        return Colors.blue;
      case 'Preparando Pedido':
        return Colors.orange;
      case 'Pedido Enviado':
        return Colors.green;
      case 'Pedido Entregado':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
}
