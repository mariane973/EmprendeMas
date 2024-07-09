import 'package:EmprendeMas/home.dart';
import 'package:EmprendeMas/material.dart';
import 'package:EmprendeMas/vistas/clientes/actualizarperfil.dart';
import 'package:EmprendeMas/vistas/clientes/carrito.dart';
import 'package:EmprendeMas/vistas/clientes/emprendimientosCliente.dart';
import 'package:EmprendeMas/vistas/clientes/homeusuario.dart';
import 'package:EmprendeMas/vistas/clientes/productoOfertaC.dart';
import 'package:EmprendeMas/vistas/clientes/productosCliente.dart';
import 'package:EmprendeMas/vistas/clientes/servicioOfertaC.dart';
import 'package:EmprendeMas/vistas/clientes/serviciosCliente.dart';
import 'package:EmprendeMas/vistas/emprendedores/loginV.dart';
import 'package:EmprendeMas/vistas/clientes/pedidosC.dart';
import 'package:EmprendeMas/vistas/clientes/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

class SlidebarUsuario extends StatefulWidget {
  final String correo;

  const SlidebarUsuario({required this.correo});

  static Route<dynamic> route(String correo) {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          body: SlidebarUsuario(correo: correo),
        );
      },
      fullscreenDialog: true,
    );
  }

  @override
  State<SlidebarUsuario> createState() => _SlidebarUsuarioState();
}

class _SlidebarUsuarioState extends State<SlidebarUsuario> {
  late Stream<DocumentSnapshot> _userDataStream;
  late Stream<List<QuerySnapshot>> _dataStream;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _userDataStream = FirebaseFirestore.instance.collection('usuarios').doc(widget.correo).snapshots();
    _dataStream = Stream.periodic(Duration(seconds: 1)).asyncMap((_) =>
        Future.wait([FirebaseFirestore.instance.collection('vendedores').get(), FirebaseFirestore.instance.collection('productos').get(), FirebaseFirestore.instance.collection('servicios').get()])
    );
    _initializeCartItemCount();
  }

  Future<List<QuerySnapshot>> getData(List<String> collections) async {
    return Future.wait(
      collections.map((collection) => FirebaseFirestore.instance.collection(collection).get()),
    );
  }
  Future<void> _initializeCartItemCount() async {
    var cartSnapshot = await FirebaseFirestore.instance.collection('carrito').doc(widget.correo).get();
    if (cartSnapshot.exists) {
      setState(() {
        _cartItemCount = (cartSnapshot.data()!['productos'] as List).length;
      });
    }
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
                  final productosData = dataSnapshot.data![1].docs.map((doc) =>
                  doc.data() as Map<String, dynamic>).toList();
                  final serviciosData = dataSnapshot.data![2].docs.map((doc) =>
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
                                backgroundImage: userData.containsKey('imagen') &&
                                    userData['imagen'] != null
                                    ? NetworkImage(userData['imagen'])
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
                                      child: Text(userData['nombre'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                    Text(userData['apellido'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  ],
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
                            color: AppMaterial().getColorAtIndex(1),
                            size: 30.0,
                          ),
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  HomeUsuario(correo: widget.correo)),
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
                              color: AppMaterial().getColorAtIndex(1),
                              size: 40.0,
                            ),
                            onTap: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => EditarPerfilCliente(correo: widget.correo)),
                              );
                            }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: ListTile(
                          title: Text("Emprendimientos",
                            style: TextStyle(
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
                              MaterialPageRoute(builder: (context) =>
                                  EmprendimientosC(vendedoresData: vendedoresData, correo: widget.correo),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only( top: 10, left:22),
                          child: ExpansionTile(
                            title: Text("Conocer",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            leading: FaIcon(FontAwesomeIcons.layerGroup,
                              color: AppMaterial().getColorAtIndex(1),
                              size: 30.0,
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 30, bottom: 5),
                                child: ListTile(
                                  title: Text('Productos',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppMaterial().getColorAtIndex(1)),
                                  ),
                                  leading: FaIcon(FontAwesomeIcons.shirt,
                                    color: AppMaterial().getColorAtIndex(1),
                                    size: 25.0,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ProductosC(correo: widget.correo, productosData: productosData))
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 35, top: 5, bottom: 15),
                                child: ListTile(
                                  title: Text('Servicios',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppMaterial().getColorAtIndex(1)),
                                  ),
                                  leading: FaIcon(FontAwesomeIcons.birthdayCake,
                                    color: AppMaterial().getColorAtIndex(1),
                                    size: 25.0,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ServiciosC(correo: widget.correo, serviciosData: serviciosData))
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 5),
                        child: ListTile(
                          title: Text("Carrito",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          leading: Stack(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.cartShopping,
                                color: AppMaterial().getColorAtIndex(1),
                                size: 30.0,
                              ),
                              if (_cartItemCount > 0)
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      '$_cartItemCount',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductosCarrito(correo: widget.correo)));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 10),
                        child: ListTile(
                          title: Text("Pedidos",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          leading: FaIcon(FontAwesomeIcons.listCheck,
                            color: AppMaterial().getColorAtIndex(1),
                            size: 28.0,
                          ),
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  PedidosCliente(correo: widget.correo),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10, left: 25),
                          child: ExpansionTile(
                            title: Text("Ofertas",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            leading: FaIcon(FontAwesomeIcons.moneyBillWave,
                              color: AppMaterial().getColorAtIndex(1),
                              size: 30.0,
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 30, bottom: 5),
                                child: ListTile(
                                  title: Text('Ofertas Productos',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppMaterial().getColorAtIndex(1)),
                                  ),
                                  leading: FaIcon(FontAwesomeIcons.shirt,
                                    color: AppMaterial().getColorAtIndex(1),
                                    size: 25.0,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ProductosOfertaC(correo: widget.correo,))
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 35, top: 5, bottom: 10),
                                child: ListTile(
                                  title: Text('Ofertas Servicios',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppMaterial().getColorAtIndex(1)),
                                  ),
                                  leading: FaIcon(FontAwesomeIcons.birthdayCake,
                                    color: AppMaterial().getColorAtIndex(1),
                                    size: 25.0,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ServiciosOfertaC(correo: widget.correo))
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 8),
                        child: ListTile(
                            title: Text("¿Quieres ser vendedor?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            leading: FaIcon(FontAwesomeIcons.cashRegister,
                              color: AppMaterial().getColorAtIndex(1),
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
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 15),
                        child: ListTile(
                            title: Text("Cerrar sesión",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            leading: FaIcon(FontAwesomeIcons.shareFromSquare,
                              color: AppMaterial().getColorAtIndex(1),
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