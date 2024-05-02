import 'package:emprende_mas/material.dart';
import 'package:emprende_mas/vistas/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Productos(),
    );
  }
}

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

//AppBar//
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: EdgeInsets.only(left:20),
            height: 50,
            width: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppMaterial().getColorAtIndex(0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white), // Cambia el color del texto de entrada
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Icon(Icons.search_rounded,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ],
            ),
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
      ]
      ),
      drawer: NavigationDrawer(),


//Body//
      body: SafeArea(
        child: Stack(
          children: [

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, AppMaterial().getColorAtIndex(0)],
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
              ),
            ),
          ),
           ] ),
            )
          );
    }
  }



//Slidebar//
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer();
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (BuildContext context) {

        return Scaffold(
          body: NavigationDrawer(
          ),
        );
      },
      fullscreenDialog: true,

    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(),
                    child: Image.asset("img/tucan2.png",height: 90),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Text(
                      'EMPRENDEMAS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: AppMaterial().getColorAtIndex(1),
            ),
          ),
    Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 15),
          child: ListTile(
              title: Text("Categorías",
                style:TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                ),
              ),
              leading: FaIcon(FontAwesomeIcons.layerGroup,
                color: AppMaterial().getColorAtIndex(1),
                size: 30.0,),

              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Login())
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
              size: 30.0,),

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
              size: 30.0,),

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
                size: 34.0,),

              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Login())
                );
              }
          ),
        ),
        SizedBox(height: 250.0),
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
                size: 34.0,),

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
                size: 28.0,),

              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Login())
                );
              }
          ),
        ),
      ],
          )
        ],
      ),
    );
  }
}