import 'package:emprende_mas/home.dart';
import 'package:emprende_mas/material.dart';
import 'package:emprende_mas/vistas/emprendedores/loginV.dart';
import 'package:emprende_mas/vistas/principales/productos.dart';
import 'package:emprende_mas/vistas/principales/emprendimientos.dart';
import 'package:emprende_mas/vistas/clientes/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Slidebar//
class PrincipalDrawer extends StatefulWidget {
  const PrincipalDrawer();

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          body: PrincipalDrawer(),
        );
      },
      fullscreenDialog: true,
    );
  }

  @override
  State<PrincipalDrawer> createState() => _PrincipalDrawerState();
}

class _PrincipalDrawerState extends State<PrincipalDrawer> {
  late Future<List<QuerySnapshot>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = getData(['vendedores', 'productos']);
  }

  Future<List<QuerySnapshot>> getData(List<String> collections) async {
    return Future.wait(collections.map((collection) => FirebaseFirestore.instance.collection(collection).get(),),
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
                        padding: const EdgeInsets.only(top: 25 ),
                        child: Container(
                          child: FaIcon(FontAwesomeIcons.sackDollar,
                            color: Colors.white,
                            size: 60.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20,bottom: 10),
                        child: Text('EMPRENDEMAS',
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
                    color: AppMaterial().getColorAtIndex(1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,top: 20),
                  child: ListTile(
                    title: Text("Principal",
                      style:TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    leading: FaIcon(FontAwesomeIcons.home,
                      color: AppMaterial().getColorAtIndex(1),
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10, left: 17, right: 20),
                    child: ExpansionTile(
                      title: Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      leading: Icon(
                        Icons.account_circle,
                        color: AppMaterial().getColorAtIndex(1),
                        size: 40.0,
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30, bottom: 5),
                          child: ListTile(
                            title: Text('Iniciar como cliente',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppMaterial().getColorAtIndex(2)),
                            ),
                            leading: FaIcon(FontAwesomeIcons.userLarge,
                              color: AppMaterial().getColorAtIndex(2),
                              size: 25.0,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Login()),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 5, bottom: 15),
                          child: ListTile(
                            title: Text('Convertirte en vendedor',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppMaterial().getColorAtIndex(3)),
                            ),
                            leading: FaIcon(FontAwesomeIcons.cashRegister,
                              color: AppMaterial().getColorAtIndex(3),
                              size: 25.0,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginV()),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    title: Text("Emprendimientos",
                      style:TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    leading: FaIcon(FontAwesomeIcons.users,
                      color: AppMaterial().getColorAtIndex(1),
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
                        color: AppMaterial().getColorAtIndex(1),
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
                      color: AppMaterial().getColorAtIndex(1),
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
                        color: AppMaterial().getColorAtIndex(1),
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
                  padding: const EdgeInsets.only(left: 25, top: 8),
                  child: ListTile(
                      title: Text("En tu zona",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      leading: FaIcon(FontAwesomeIcons.locationDot,
                        color: AppMaterial().getColorAtIndex(1),
                        size: 34.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login())
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