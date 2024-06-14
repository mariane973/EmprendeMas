import 'package:emprende_mas/home.dart';
import 'package:emprende_mas/material.dart';
import 'package:emprende_mas/vistas/emprendedores/actualizarperfil.dart';
import 'package:emprende_mas/vistas/emprendedores/emprendimientosVendedor.dart';
import 'package:emprende_mas/vistas/emprendedores/homevendedor.dart';
import 'package:emprende_mas/vistas/emprendedores/loginV.dart';
import 'package:emprende_mas/vistas/clientes/login.dart';
import 'package:emprende_mas/vistas/emprendedores/productosVendedor.dart';
import 'package:emprende_mas/vistas/emprendedores/serviciosVendedor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

class SlidebarVendedor extends StatefulWidget {
  final String correo;

  const SlidebarVendedor({required this.correo});

  static Route<dynamic> route(String correo) {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          body: SlidebarVendedor(correo: correo),
        );
      },
      fullscreenDialog: true,
    );
  }

  @override
  State<SlidebarVendedor> createState() => _SlidebarVendedorState();
}

class _SlidebarVendedorState extends State<SlidebarVendedor> {
  late Stream<DocumentSnapshot> _userDataStream;
  late Stream<List<QuerySnapshot>> _dataStream;

  @override
  void initState() {
    super.initState();
    _userDataStream = FirebaseFirestore.instance.collection('vendedores').doc(widget.correo).snapshots();
    _dataStream = Stream.periodic(Duration(seconds: 1)).asyncMap((_) =>
        Future.wait([FirebaseFirestore.instance.collection('vendedores').get()])
    );
  }

  Future<List<QuerySnapshot>> getData(List<String> collections) async {
    return Future.wait(
      collections.map((collection) => FirebaseFirestore.instance.collection(collection).get()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: StreamBuilder(
        stream: _userDataStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          } else {
            Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;

            return StreamBuilder(
              stream: _dataStream,
              builder: (context, AsyncSnapshot<List<QuerySnapshot>> dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (dataSnapshot.hasError) {
                  return Center(child: Text('Error: ${dataSnapshot.error}'));
                } else {
                  final vendedoresData = dataSnapshot.data![0].docs.map((doc) =>
                  doc.data() as Map<String, dynamic>).toList();

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
                                backgroundImage: userData.containsKey('logo_emprendimiento') &&
                                    userData['logo_emprendimiento'] != null
                                    ? NetworkImage(userData['logo_emprendimiento'])
                                    : AssetImage(
                                    'img/tucanemp.png') as ImageProvider,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Text(userData['nombre_emprendimiento'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ],
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
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: ListTile(
                          title: Text("Principal",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          leading: FaIcon(FontAwesomeIcons.home,
                            color: AppMaterial().getColorAtIndex(2),
                            size: 30.0,
                          ),
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  HomeVendedor(correo: widget.correo)),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: ListTile(
                            title: Text("Editar Perfil",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            leading: Icon(
                              Icons.manage_accounts,
                              color: AppMaterial().getColorAtIndex(2),
                              size: 40.0,
                            ),
                            onTap: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => EditarPerfilVendedor(correo: widget.correo)),
                              );
                            }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 10),
                        child: ListTile(
                          title: Text("Mi Emprendimiento",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          leading: FaIcon(FontAwesomeIcons.bagShopping,
                            color: AppMaterial().getColorAtIndex(2),
                            size: 30.0,
                          ),
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  EmprendimientosV(correo: widget.correo)
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                        child: ExpansionTile(
                            title: Text("Administrar Emprendimiento",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            leading: FaIcon(FontAwesomeIcons.layerGroup,
                              color: AppMaterial().getColorAtIndex(2),
                              size: 30.0,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: ListTile(
                                  title: Text('Productos',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppMaterial().getColorAtIndex(2)),
                                  ),
                                  leading: FaIcon(FontAwesomeIcons.shirt,
                                    color: AppMaterial().getColorAtIndex(2),
                                    size: 25.0,
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          ProductosV(correo: widget.correo)
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 35),
                                child: ListTile(
                                    title: Text("Servicios",
                                      style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppMaterial().getColorAtIndex(2)),
                                      ),
                                    leading: FaIcon(FontAwesomeIcons.birthdayCake,
                                      color: AppMaterial().getColorAtIndex(2),
                                      size: 25.0,
                                    ),
                                    onTap: () {
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            ServiciosV(correo: widget.correo)
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15),
                        child: ListTile(
                          title: Text("Pedidos",
                            style: TextStyle(
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
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15),
                        child: ListTile(
                            title: Text("Clientes",
                              style: TextStyle(
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
                                  MaterialPageRoute(builder: (context) => LoginV())
                              );
                            }
                        ),
                      ),
                      SizedBox(
                        height: 180,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top:20),
                        child: ListTile(
                            title: Text("Cerrar sesión",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
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
            );
          }
        },
      ),
    );
  }
}