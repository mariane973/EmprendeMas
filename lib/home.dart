import 'package:emprende_mas/material.dart';
import 'package:emprende_mas/vistas/principales/productos.dart';
import 'package:emprende_mas/vistas/principales/emprendimientos.dart';
import 'package:emprende_mas/vistas/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Productos(),
    );
  }
}

class Productos extends StatefulWidget {
  const Productos();
  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {

  final List<String> imgList = [
    'https://lh5.googleusercontent.com/proxy/Ea1O0iiPAoMosjeA48UUDRNkR6gwJGrJp36Q3FnKGPvehdWrnX7-1lluDwzEV7RaF5YU5ZspSOj074_EEo3sxzKW26tlDjZ2yn65fB_a7ahKi7LWBuqa2eZ_f_A_6HUTSuB6zyFy_qcVbiTo7JRY8YB7nVN1Q6iXzFnF',
    'https://lh5.googleusercontent.com/proxy/Ea1O0iiPAoMosjeA48UUDRNkR6gwJGrJp36Q3FnKGPvehdWrnX7-1lluDwzEV7RaF5YU5ZspSOj074_EEo3sxzKW26tlDjZ2yn65fB_a7ahKi7LWBuqa2eZ_f_A_6HUTSuB6zyFy_qcVbiTo7JRY8YB7nVN1Q6iXzFnF',
    'https://lh5.googleusercontent.com/proxy/Ea1O0iiPAoMosjeA48UUDRNkR6gwJGrJp36Q3FnKGPvehdWrnX7-1lluDwzEV7RaF5YU5ZspSOj074_EEo3sxzKW26tlDjZ2yn65fB_a7ahKi7LWBuqa2eZ_f_A_6HUTSuB6zyFy_qcVbiTo7JRY8YB7nVN1Q6iXzFnF',
  ];
  int _currenPage = 0;

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
                  height: 50,
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
        drawer: NavigationDrawer(),

      //Body//
        body: Column(
          children: [
            CarouselSlider(
              items: imgList.map((e) => Center(
                child: Image.network(e),
              )).toList(),
              options: CarouselOptions(
                initialPage: 0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                enlargeCenterPage: true,
                enlargeFactor: 0.4,
                onPageChanged: (value, _){
                  setState(() {
                    _currenPage = value;
                  });
                }
              ),
            ),
            buildCarouselInidcator()
          ],
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

//Slidebar//
class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer();

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          body: NavigationDrawer(),
        );
      },
      fullscreenDialog: true,
    );
  }

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
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
                  padding: const EdgeInsets.only(left: 20, top: 15),
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
                SizedBox(height: 150.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 40,left: 15),
                  child: ListTile(
                      title: Text("Iniciar sesión",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      leading: Icon(
                        Icons.account_circle,
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
                  padding: const EdgeInsets.only(left: 20 ),
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