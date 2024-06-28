import 'package:EmprendeMas/material.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:EmprendeMas/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EmprendeMas/vistas/clientes/slidebarusuario.dart';
import 'dart:io' as io;

class HomeUsuario extends StatelessWidget {
  final String correo;

  const HomeUsuario({required this.correo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('usuarios').doc(correo).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final nombre = data['nombre'];
        final imagenUrl = data['imagen'];
        final apellido = data['apellido'];
        return ProductosCliente(nombre: nombre, imagenUrl: imagenUrl, apellido: apellido, correo: correo,);
      },
    );
  }
}
class ProductosCliente extends StatefulWidget {
  final String nombre;
  final String imagenUrl;
  final String apellido;
  final String correo;

  const ProductosCliente({required this.nombre, required this.imagenUrl, required this.apellido, required this.correo});

  @override
  State<ProductosCliente> createState() => _ProductosClienteState();
}


class _ProductosClienteState extends State<ProductosCliente> {

  final List<String> imgList = [
    'https://lh5.googleusercontent.com/proxy/Ea1O0iiPAoMosjeA48UUDRNkR6gwJGrJp36Q3FnKGPvehdWrnX7-1lluDwzEV7RaF5YU5ZspSOj074_EEo3sxzKW26tlDjZ2yn65fB_a7ahKi7LWBuqa2eZ_f_A_6HUTSuB6zyFy_qcVbiTo7JRY8YB7nVN1Q6iXzFnF',
    'https://media.glamour.es/photos/64072f8d579ac7b628484892/16:9/w_2580,c_limit/LUGGAGE%20160222%20MAIN.jpg',
    'https://www.eluniversal.com.mx/resizer/ykLY24JvSn_zl3tmmw1g-Uq5dMU=/1100x666/cloudfront-us-east-1.images.arcpublishing.com/eluniversal/6JJCTJH34ZCNBJO2XMVKYYA5RA.jpg',
  ];
  int _currenPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white,   AppMaterial().getColorAtIndex(0)],
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //AppBar//
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
                  padding: EdgeInsets.only(left:35),
                  height: 45,
                  width: 260,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("EMPRENDEMAS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: AppMaterial().getColorAtIndex(1)
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
                    child: Image.asset("img/tucanemp.png",height: 50),
                  ),
                ),
              ],
            ),
          ],
        ),
        drawer: SlidebarUsuario(correo: widget.correo),
        //Body//
        body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                items: imgList.map((e) =>
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          e,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    )).toList(),
                options: CarouselOptions(
                    initialPage: 0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    enlargeCenterPage: true,
                    enlargeFactor: 0.4,
                    onPageChanged: (value, _) {
                      setState(() {
                        _currenPage = value;
                      });
                    }
                ),
              ),
              buildCarouselInidcator(),
              Categorias(),
              Ofertas()
            ],
          ),
        ),
      ),
    );
  }

  buildCarouselInidcator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for(int i = 0; i<imgList.length; i++)
          Container(
            margin: EdgeInsets.all(5),
            height: i== _currenPage ? 7 : 5,
            width: i== _currenPage ? 7 : 5,
            decoration: BoxDecoration(
                color: i == _currenPage ? Colors.black : Colors.green,
                shape: BoxShape.circle
            ),
          )
      ],
    );
  }
}