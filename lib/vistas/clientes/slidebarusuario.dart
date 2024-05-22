import 'package:emprende_mas/home.dart';
import 'package:emprende_mas/material.dart';
import 'package:emprende_mas/vistas/clientes/formperfil.dart';
import 'package:emprende_mas/vistas/emprendedores/loginV.dart';
import 'package:emprende_mas/vistas/principales/productos.dart';
import 'package:emprende_mas/vistas/principales/emprendimientos.dart';
import 'package:emprende_mas/vistas/clientes/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

class SlidebarUsuario extends StatefulWidget {
  final String nombre;
  final io.File imagen;

  const SlidebarUsuario(this.nombre, this.imagen);

  static Route<dynamic> route(String nombre, io.File imagen) {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          body: SlidebarUsuario(nombre, imagen),
        );
      },
      fullscreenDialog: true,
    );
  }

  @override
  State<SlidebarUsuario> createState() => _SlidebarUsuarioState();
}

class _SlidebarUsuarioState extends State<SlidebarUsuario> {
  late Future<List<QuerySnapshot>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = getData(['vendedores', 'productos']);
  }

  Future<List<QuerySnapshot>> getData(List<String> collections) async {
    return Future.wait(collections.map((collection) => FirebaseFirestore.instance.collection(collection).get(),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: FutureBuilder(
        future: _futureData,
        builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else{
            final vendedoresData = snapshot.data![0].docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
            final productosData = snapshot.data![1].docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(widget.imagen),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(widget.nombre,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: AppMaterial().getColorAtIndex(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only( top: 20,left: 20),
                  child: ListTile(
                      title: Text("Perfil",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      leading: Icon(
                        Icons.manage_accounts,
                        color: AppMaterial().getColorAtIndex(2),
                        size: 40.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => FormPerfil())
                        );
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: ListTile(
                    title: Text("Emprendimientos",
                      style:TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    leading: FaIcon(FontAwesomeIcons.users,
                      color: AppMaterial().getColorAtIndex(2),
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DatosVendedores(vendedoresData: vendedoresData),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15),
                  child: ListTile(
                      title: Text("Productos",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      leading: FaIcon(FontAwesomeIcons.layerGroup,
                        color: AppMaterial().getColorAtIndex(2),
                        size: 30.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DatosProductos(productosData: productosData),
                          ),
                        );
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15),
                  child: ListTile(
                    title: Text("Carrito",
                      style:TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    leading: FaIcon(FontAwesomeIcons.cartShopping,
                      color: AppMaterial().getColorAtIndex(2),
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login())
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15),
                  child: ListTile(
                      title: Text("Ofertas",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      leading: FaIcon(FontAwesomeIcons.moneyBillWave,
                        color: AppMaterial().getColorAtIndex(2),
                        size: 30.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login())
                        );
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 10),
                  child: ListTile(
                      title: Text("En tu zona",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      leading: FaIcon(FontAwesomeIcons.locationDot,
                        color: AppMaterial().getColorAtIndex(2),
                        size: 34.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login())
                        );
                      }
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 8 ),
                  child: ListTile(
                      title: Text("¿Quieres ser vendedor?",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      leading: FaIcon(FontAwesomeIcons.cashRegister,
                        color: AppMaterial().getColorAtIndex(2),
                        size: 28.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginV())
                        );
                      }
                  ),
                ),
                SizedBox(
                  height: 120,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 15),
                  child: ListTile(
                      title: Text("Cerrar sesión",
                        style:TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      leading: FaIcon(FontAwesomeIcons.shareFromSquare,
                        color: AppMaterial().getColorAtIndex(2),
                        size: 30.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home())
                        );
                      }
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
