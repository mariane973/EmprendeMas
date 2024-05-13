import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';

class DetalleProducto extends StatelessWidget {
  final Map<String, dynamic> producto;

  DetalleProducto ({required this.producto});

  @override
  Widget build(BuildContext context) {
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
          title: Text(producto['nombre'],
            style: TextStyle(
              fontWeight: FontWeight.w500
            ),
          ),
          backgroundColor: AppMaterial().getColorAtIndex(0),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 17, right: 17),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(producto['imagen'])),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.normal
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Nombre: ',  style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '${producto['nombre']}'),
                  ]
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Descripción: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.6)),
                      TextSpan(text: '${producto['descripcion']}'),
                    ]
                ),
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
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
                        fontSize: 22,
                        fontWeight: FontWeight.normal
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Precio: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.6)),
                      TextSpan(text: '\$${producto['precio']}'),
                    ]
                ),
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.normal
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Stock: ',  style: TextStyle(fontWeight: FontWeight.bold, height: 1.6)),
                      TextSpan(text: '${producto['stock']}'),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
