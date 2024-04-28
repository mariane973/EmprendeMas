import 'package:emprende_mas/material.dart';
import 'package:emprende_mas/vistas/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: SafeArea(
        child: Stack(
          children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, AppMaterial().getColorAtIndex(0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
            Container(
              padding: EdgeInsets.only(top: 10,left: 15),
              child:
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset("img/tucanemp.png",height: 50),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:80),
                    height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppMaterial().getColorAtIndex(0),
                    ),
                    child: Row(
                      children: [
                      Text("Buscar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                      ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Icon(Icons.search_rounded,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login())
                        );
                      },
                      child: Align(
                        child: Icon(Icons.menu_rounded,
                          color: AppMaterial().getColorAtIndex(0),
                          size: 45.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],)
        ],
        ),
      ),
    );
  }
}
