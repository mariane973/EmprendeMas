import 'package:EmprendeMas/material.dart';
import 'package:EmprendeMas/vistas/emprendedores/productosCategoriaV.dart';
import 'package:EmprendeMas/vistas/emprendedores/serviciosVendedor.dart';
import 'package:EmprendeMas/vistas/emprendedores/slidebarEmprendedor.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeVendedor extends StatelessWidget {
  final String correo;

  const HomeVendedor({required this.correo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('vendedores').doc(correo).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final emprendimiento = data['nombre_emprendimiento'];
        final imagenUrl = data['logo_emprendimiento'];
        return ProductosVendedor(emprendimiento: emprendimiento, imagenUrl: imagenUrl, correo: correo);
      },
    );
  }
}

class ProductosVendedor extends StatefulWidget {
  final String emprendimiento;
  final String imagenUrl;
  final String correo;

  const ProductosVendedor({required this.emprendimiento, required this.imagenUrl, required this.correo});

  @override
  State<ProductosVendedor> createState() => _ProductosVendedorState();
}

class _ProductosVendedorState extends State<ProductosVendedor> {

  final List<String> imgList = [
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
        drawer: SlidebarVendedor(correo: widget.correo),

        //Body//
        body: SingleChildScrollView(
          child: Column(
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
              buildCarouselInidcator(),
              CategoriasV(correo: widget.correo),
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
                shape: BoxShape.circle
            ),
          )
      ],
    );
  }
}

class CategoriasV extends StatelessWidget {
  final String correo;
  CategoriasV({required this.correo});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      ),
                    ]
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProductosCategoriaV(categoriaSeleccionada: 'Accesorios', correo: correo)));
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
                                              )
                                            ]
                                        ),
                                      )
                                  ),
                                ]
                            ),
                          )
                      )
                  )
              ),
              Expanded(
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProductosCategoriaV(categoriaSeleccionada: 'Comida', correo: correo))
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
                                              )
                                            ]
                                        ),
                                      )
                                  ),
                                ]
                            ),
                          )
                      )
                  )
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProductosCategoriaV(categoriaSeleccionada: 'Ropa', correo: correo))
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
                                              )
                                            ]
                                        ),
                                      )
                                  ),
                                ]
                            ),
                          )
                      )
                  )
              ),
              Expanded(
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProductosCategoriaV(categoriaSeleccionada: 'Artesanías', correo: correo))
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
                                              )
                                            ]
                                        ),
                                      )
                                  ),
                                ]
                            ),
                          )
                      )
                  )
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProductosCategoriaV(categoriaSeleccionada: 'Plantas', correo: correo))
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
                                              )
                                            ]
                                        ),
                                      )
                                  ),
                                ]
                            ),
                          )
                      )
                  )
              ),
              Expanded(
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProductosCategoriaV(categoriaSeleccionada: 'Cuidado Personal', correo: correo))
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
                                                    'Cuidado Personal',
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
                                              )
                                            ]
                                        ),
                                      )
                                  ),
                                ]
                            ),
                          )
                      )
                  )
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiciosV(correo: correo),
                          ),
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
                                              )
                                            ]
                                        ),
                                      )
                                  ),
                                ]
                            ),
                          )
                      )
                  )
              ),
              Expanded(
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProductosCategoriaV(categoriaSeleccionada: 'Venta de Garaje', correo: correo))
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
                                                    'Venta de Garaje',
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
                                              )
                                            ]
                                        ),
                                      )
                                  ),
                                ]
                            ),
                          )
                      )
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}