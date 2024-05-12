import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';

class DetalleProducto extends StatelessWidget {
  final Map<String, dynamic> producto;

  DetalleProducto ({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto['nombre']),
        backgroundColor: AppMaterial().getColorAtIndex(0),
      ),
      body: Column(
        children: [
          Text('Nombre: ${producto['nombre']}'),
          Text('Descripción: ${producto['descripcion']}'),
          Text('Categoría: ${producto['categoria']}'),
          Text('Precio: ${producto['precio']}'),
          Text('Stock: ${producto['stock']}'),
          Image.network(producto['imagen'])
        ],
      ),
    );
  }
}
