import 'package:EmprendeMas/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/vistas/principales/slideprincipal.dart';
import 'package:flutter/widgets.dart';
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
    'https://media.glamour.es/photos/64072f8d579ac7b628484892/16:9/w_2580,c_limit/LUGGAGE%20160222%20MAIN.jpg',
    'https://www.eluniversal.com.mx/resizer/ykLY24JvSn_zl3tmmw1g-Uq5dMU=/1100x666/cloudfront-us-east-1.images.arcpublishing.com/eluniversal/6JJCTJH34ZCNBJO2XMVKYYA5RA.jpg',
  ];

  final List<String> imgCategorias = [
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
                  height: 50,
                  width: 260,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text("EMPRENDEMAS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: AppMaterial().getColorAtIndex(1)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 20, top: 5, left: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset("img/tucanemp.png", height: 50),
                  ),
                ),
              ],
            ),
          ],
        ),
        drawer: PrincipalDrawer(),

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
              shape: BoxShape.circle,

            ),
          )
      ],
    );
  }
}

class Ofertas extends StatelessWidget {
  const Ofertas({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 10),
                child: Container(
                  child: Text("OFERTAS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                            offset: Offset(0.5, 0.5),
                          ),]
                    ),),
                ),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
                    child: Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
                        width: 180,
                        height: 300, // Ajustar la altura para dar espacio a los textos
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                "img/cuero.jpg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150, // Ajustar la altura de la imagen
                              ),
                            ),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          'Chaqueta de cuero',
                                          style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18,
                                                                         ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15, top: 10, right: 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Antes:',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.red,
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                              Text(
                                                '\$60.000',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.red,
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20, top: 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Ahora:',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '\$45.000',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),

                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal:30),
                                        child: ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: AppMaterial().getColorAtIndex(1),
                                            size: 25.0,
                                          ),
                                          label: Text(
                                            "Ver",
                                            style: TextStyle(
                                              color: AppMaterial().getColorAtIndex(1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: 5, horizontal:10),
                                            backgroundColor: Colors.white
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 10, bottom: 10),
                    child: Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
                        width: 180,
                        height: 300, // Ajustar la altura para dar espacio a los textos
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                "img/bolsocuero.jpg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150, // Ajustar la altura de la imagen
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        'Bolso de cuero',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15, top: 10, right: 10),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Antes:',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.red,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                            Text(
                                              '\$40.000',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20, top: 10),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Ahora:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '\$35.000',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),

                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal:30),
                                      child: ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: AppMaterial().getColorAtIndex(1),
                                          size: 25.0,
                                        ),
                                        label: Text(
                                          "Ver",
                                          style: TextStyle(
                                            color: AppMaterial().getColorAtIndex(1),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: 5, horizontal:10),
                                            backgroundColor: Colors.white
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
    );
  }
}












class Categorias extends StatelessWidget {
  const Categorias({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Container(
                  child: Text("CATEGORIAS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 22,
                    shadows: [
                    Shadow(
                    blurRadius: 5.0,
                    color: Colors.black,
                    offset: Offset(0.5, 0.5),
                  ),]
                  ),),
                ),
              ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                      onTap: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home())
              );
              },
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 10),
            child: Expanded(
              child: Row(
                children: [
                Container(
                width: 180,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                      children: [
                        Image.asset(
                          "img/accesorios0.jpg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black.withOpacity(0.2),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Text(
                            'Accesorios',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          )
                        )]
                ),)
              ),
            ]),
          )))
                  ),
                  Expanded(
                      child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Home())
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10, right: 20),
                              child: Expanded(
                                child: Row(
                                    children: [
                                      Container(
                                          width: 180,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                spreadRadius: 5, // Extensión de la sombra
                                                blurRadius: 7, // Desenfoque de la sombra
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18),
                                            child: Stack(
                                                children: [
                                                  Image.asset(
                                                    "img/postres0.jpg",
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: Colors.black.withOpacity(0.2),
                                                  ),
                                                  Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      child: Text(
                                                        'Comida',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 10.0,
                                                              color: Colors.black,
                                                              offset: Offset(2.0, 2.0),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  )]
                                            ),)
                                      ),
                                    ]),
                              )))
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Home())
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20, right: 10),
                              child: Expanded(
                                child: Row(
                                    children: [
                                      Container(
                                          width: 180,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18),
                                            child: Stack(
                                                children: [
                                                  Image.asset(
                                                    "img/ropa.jpg",
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: Colors.black.withOpacity(0.2),
                                                  ),
                                                  Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      child: Text(
                                                        'Ropa',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 10.0,
                                                              color: Colors.black,
                                                              offset: Offset(2.0, 2.0),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  )]
                                            ),)
                                      ),
                                    ]),
                              )))
                  ),
                  Expanded(
                      child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Home())
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10, right: 20),
                              child: Expanded(
                                child: Row(
                                    children: [
                                      Container(
                                          width: 180,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18),
                                            child: Stack(
                                                children: [
                                                  Image.asset(
                                                    "img/artesanias.jpg",
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: Colors.black.withOpacity(0.2),
                                                  ),
                                                  Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      child: Text(
                                                        'Artesanías',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 10.0,
                                                              color: Colors.black,
                                                              offset: Offset(2.0, 2.0),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  )]
                                            ),)
                                      ),
                                    ]),
                              )))
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Home())
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20, right: 10),
                              child: Expanded(
                                child: Row(
                                    children: [
                                      Container(
                                          width: 180,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18),
                                            child: Stack(
                                                children: [
                                                  Image.asset(
                                                    "img/plantas.jpg",
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: Colors.black.withOpacity(0.2),
                                                  ),
                                                  Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      child: Text(
                                                        'Plantas',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 10.0,
                                                              color: Colors.black,
                                                              offset: Offset(2.0, 2.0),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  )]
                                            ),)
                                      ),
                                    ]),
                              )))
                  ),
                  Expanded(
                      child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Home())
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10, right: 20),
                              child: Expanded(
                                child: Row(
                                    children: [
                                      Container(
                                          width: 180,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18),
                                            child: Stack(
                                                children: [
                                                  Image.asset(
                                                    "img/personal.jpg",
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: Colors.black.withOpacity(0.2),
                                                  ),
                                                  Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      child: Text(
                                                        'Cuidado personal',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 10.0,
                                                              color: Colors.black,
                                                              offset: Offset(2.0, 2.0),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  )]
                                            ),)
                                      ),
                                    ]),
                              )))
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Home())
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20, right: 10),
                              child: Expanded(
                                child: Row(
                                    children: [
                                      Container(
                                          width: 180,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18),
                                            child: Stack(
                                                children: [
                                                  Image.asset(
                                                    "img/servicios.jpg",
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: Colors.black.withOpacity(0.2),
                                                  ),
                                                  Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      child: Text(
                                                        'Servicios',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 10.0,
                                                              color: Colors.black,
                                                              offset: Offset(2.0, 2.0),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  )]
                                            ),)
                                      ),
                                    ]),
                              )))
                  ),
                  Expanded(
                      child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Home())
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10, right: 20),
                              child: Expanded(
                                child: Row(
                                    children: [
                                      Container(
                                          width: 180,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18),
                                            child: Stack(
                                                children: [
                                                  Image.asset(
                                                    "img/garaje.jpg",
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: Colors.black.withOpacity(0.2),
                                                  ),
                                                  Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      child: Text(
                                                        'Venta de garaje',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 10.0,
                                                              color: Colors.black,
                                                              offset: Offset(2.0, 2.0),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  )]
                                            ),)
                                      ),
                                    ]),
                              )))
                  ),
                ],
              ),


            ],
        ),
      ),
    );
  }
}


