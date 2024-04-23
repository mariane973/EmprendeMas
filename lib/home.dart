import 'package:emprende_mas/material.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: productos(),
    );
  }
}

class productos extends StatefulWidget {
  const productos({super.key});

  @override
  State<productos> createState() => _productosState();
}

class _productosState extends State<productos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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









        Container(
          child: Column(
            children: [
            Container(
              padding: EdgeInsets.only(top: 30,left: 15),
              child:
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset("img/tucanemp.png",height: 50,),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:120),
                    height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppMaterial().getColorAtIndex(0),
                    ),
                    child: Row(
                      children: [
                      Container(
                        child: Text("Buscar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),),
                      )
                    ],),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      child: Image.asset("img/menu.png"),
                    ),
                  )
                ],
              ),
            )
          ],),
        )
      ],
      ),
    );
  }
}
