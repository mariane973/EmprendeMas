import 'package:EmprendeMas/vistas/emprendedores/slidebarEmprendedor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EmprendeMas/material.dart';
import 'package:EmprendeMas/vistas/clientes/slidebarusuario.dart';

class PedidosVendedor extends StatefulWidget {
  final String correo;

  PedidosVendedor({required this.correo});

  @override
  _PedidosVendedorState createState() => _PedidosVendedorState();
}

class _PedidosVendedorState extends State<PedidosVendedor> {
  List<Map<String, dynamic>> listaPedidos = [];

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  Future<void> _loadPedidos() async {
    try {
      final pedidosSnapshot = await FirebaseFirestore.instance
          .collection('vendedores')
          .doc(widget.correo)
          .collection('pedidos')
          .get();

      List<Map<String, dynamic>> pedidos = [];

      for (final pedidoDoc in pedidosSnapshot.docs) {
        final clienteId = pedidoDoc['usuarioId'];
        final clienteSnapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(clienteId)
            .get();
        final clienteData = clienteSnapshot.data();

        final productoData = pedidoDoc['producto'];

        final pedidoData = pedidoDoc.data();
        pedidoData['pedidoId'] = pedidoDoc.id;
        pedidoData['cliente'] = pedidoDoc['usuarioId'];
        pedidoData['nombre'] = productoData['nombre'];
        pedidoData['cantidad'] = productoData['cantidad'];
        pedidoData['precio'] = productoData['precio'];
        pedidoData['direccion'] = clienteData!['direccion'];
        pedidoData['telefono'] = clienteData['telefono'];
        pedidoData['producto'] = productoData;
        pedidoData['usuarioId'] = clienteId;
        pedidos.add(pedidoData);
      }

      setState(() {
        listaPedidos = pedidos;
      });
    } catch (e) {
      print('Error al cargar pedidos: $e');
    }
  }

  void _actualizarEstadoPedido(String pedidoId, String nuevoEstado) async {
    final vendedorPedidoRef = FirebaseFirestore.instance
        .collection('vendedores')
        .doc(widget.correo)
        .collection('pedidos')
        .doc(pedidoId);

    final clientePedidoRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(listaPedidos.firstWhere((pedido) => pedido['pedidoId'] == pedidoId)['usuarioId'])
        .collection('pedidos')
        .doc(pedidoId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(vendedorPedidoRef, {'estado': nuevoEstado});
        transaction.update(clientePedidoRef, {'estado': nuevoEstado});
      });

      print('Estado del pedido actualizado a: $nuevoEstado');

      setState(() {
        listaPedidos = listaPedidos.map((pedido) {
          if (pedido['pedidoId'] == pedidoId) {
            pedido['estado'] = nuevoEstado;
          }
          return pedido;
        }).toList();
      });
    } catch (error) {
      print('Error al actualizar el estado del pedido: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (listaPedidos.isEmpty) {
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
        drawer: SlidebarUsuario(correo: widget.correo),
        body: Container(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    'No hay pedidos para mostrar',
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
      drawer: SlidebarVendedor(correo: widget.correo),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child: Text(
                "PEDIDOS",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: listaPedidos.length,
              itemBuilder: (context, index) {
                final producto = listaPedidos[index]['producto'] ?? {};
                final imagenUrl = producto['imagen'] ?? '';

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String selectedEstado = listaPedidos[index]['estado'];

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text('Editar Estado del Pedido'),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildEstadoPedidoOption('Pedido Aceptado', selectedEstado, () {
                                      setState(() {
                                        selectedEstado = 'Pedido Aceptado';
                                      });
                                    }),
                                    _buildEstadoPedidoOption('Preparando Pedido', selectedEstado, () {
                                      setState(() {
                                        selectedEstado = 'Preparando Pedido';
                                      });
                                    }),
                                    _buildEstadoPedidoOption('Pedido Enviado', selectedEstado, () {
                                      setState(() {
                                        selectedEstado = 'Pedido Enviado';
                                      });
                                    }),
                                    _buildEstadoPedidoOption('Pedido Entregado', selectedEstado, () {
                                      setState(() {
                                        selectedEstado = 'Pedido Entregado';
                                      });
                                    }),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Aceptar'),
                                  onPressed: () {
                                    _actualizarEstadoPedido(listaPedidos[index]['pedidoId'], selectedEstado);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
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
                                'Cliente: ${listaPedidos[index]['cliente']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Dirección: ${listaPedidos[index]['direccion']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Teléfono: ${listaPedidos[index]['telefono']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Producto/Servicio: ${producto['nombre']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Cantidad: ${producto['cantidad']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Precio c/u: ${producto['precio']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Estado: ${listaPedidos[index]['estado']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getEstadoColor(listaPedidos[index]['estado']),
                                ),
                              ),
                              Text(
                                '(Haz clic para editar el estado)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
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

  Widget _buildEstadoPedidoOption(String estado, String currentSelection, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Radio(
            value: estado,
            groupValue: currentSelection,
            onChanged: (value) {},
          ),
          Text(
            estado,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

