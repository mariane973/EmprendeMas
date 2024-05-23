import 'package:emprende_mas/home.dart';
import 'package:emprende_mas/material.dart';
import 'package:emprende_mas/vistas/emprendedores/emprendimientosVendedor.dart';
import 'package:emprende_mas/vistas/emprendedores/loginV.dart';
import 'package:emprende_mas/vistas/emprendedores/productosVendedor.dart';
import 'package:emprende_mas/vistas/clientes/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SlidebarVendedor extends StatefulWidget {
  const SlidebarVendedor();

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          body: SlidebarVendedor(),
        );
      },
      fullscreenDialog: true,
    );
  }

  @override
  State<SlidebarVendedor> createState() => _SlidebarVendedorState();
}

class _SlidebarVendedorState extends State<SlidebarVendedor> {
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
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          child: FaIcon(FontAwesomeIcons.sellsy,
                            color: Colors.white,
                            size: 60.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20,bottom: 10),
                        child: Text('EMPRENDEDOR',
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
                    color: AppMaterial().getColorAtIndex(3),
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
                        color: AppMaterial().getColorAtIndex(3),
                        size: 40.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginV())
                        );
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15),
                  child: ListTile(
                    title: Text("Administrar Emprendimientos",
                      style:TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    leading: FaIcon(FontAwesomeIcons.businessTime,
                      color: AppMaterial().getColorAtIndex(3),
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EmprendimientosV(vendedoresData: vendedoresData),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15),
                  child: ListTile(
                      title: Text("Administrar productos",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      leading: FaIcon(FontAwesomeIcons.shirt,
                        color: AppMaterial().getColorAtIndex(3),
                        size: 30.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ProductosV(productosData: productosData)
                          ),
                        );
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 15),
                  child: ListTile(
                    title: Text("Pedidos",
                      style:TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    leading: FaIcon(FontAwesomeIcons.bagShopping,
                      color: AppMaterial().getColorAtIndex(3),
                      size: 35.0,
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
                      title: Text("Clientes",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      leading: FaIcon(FontAwesomeIcons.handshake,
                        color: AppMaterial().getColorAtIndex(3),
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
                  padding: const EdgeInsets.only(left: 25, top: 15),
                  child: ListTile(
                      title: Text("En tu zona",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      leading: FaIcon(FontAwesomeIcons.locationDot,
                        color: AppMaterial().getColorAtIndex(3),
                        size: 34.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login())
                        );
                      }
                  ),
                ),
                SizedBox(
                  height: 160,
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
                        color: AppMaterial().getColorAtIndex(3),
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
