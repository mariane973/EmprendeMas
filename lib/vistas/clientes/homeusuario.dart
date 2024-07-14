import 'package:EmprendeMas/material.dart';
import 'package:EmprendeMas/vistas/clientes/detalleProducOfertaC.dart';
import 'package:EmprendeMas/vistas/clientes/detalleServOfertaC.dart';
import 'package:EmprendeMas/vistas/clientes/productoOfertaC.dart';
import 'package:EmprendeMas/vistas/clientes/servicioOfertaC.dart';
import 'package:EmprendeMas/vistas/clientes/serviciosCliente.dart';
import 'package:EmprendeMas/vistas/clientes/productosCategoriaC.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EmprendeMas/vistas/clientes/slidebarusuario.dart';
import 'dart:math';

class HomeUsuario extends StatelessWidget {
  final String correo;

  const HomeUsuario({required this.correo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('usuarios').doc(correo).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final nombre = data['nombre'];
        final imagenUrl = data['imagen'];
        final apellido = data['apellido'];
        return ProductosCliente(nombre: nombre, imagenUrl: imagenUrl, apellido: apellido, correo: correo,);
      },
    );
  }
}
class ProductosCliente extends StatefulWidget {
  final String nombre;
  final String imagenUrl;
  final String apellido;
  final String correo;

  const ProductosCliente({required this.nombre, required this.imagenUrl, required this.apellido, required this.correo});

  @override
  State<ProductosCliente> createState() => _ProductosClienteState();
}


class _ProductosClienteState extends State<ProductosCliente> {

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
          colors: [Colors.white,   AppMaterial().getColorAtIndex(0)],
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
                  height: 45,
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
        drawer: SlidebarUsuario(correo: widget.correo),

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
              CategoriasV(correo: widget.correo),
              OfertasC(correo: widget.correo)
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

class OfertasC extends StatefulWidget {
  final String correo;
  const OfertasC({required this.correo});

  @override
  State<OfertasC> createState() => _OfertasCState();
}
class _OfertasCState extends State<OfertasC> {
  List<Map<String, dynamic>> _allResults = [];
  List<Map<String, dynamic>> _allResultsServ = [];

  void initState(){
    super.initState();
    _filtradoOfertaProducto();
    _filtradoOfertaServicio();
  }
  void _filtradoOfertaProducto() async {
    List<Map<String, dynamic>> allResults = [];
    final vendedoresSnapshot = await FirebaseFirestore.instance.collection('vendedores').get();
    for (var vendedorDoc in vendedoresSnapshot.docs) {
      final productosSnapshot = await vendedorDoc.reference.collection('productos').where('oferta', isEqualTo: 'Sí').get();

      for (var productoDoc in productosSnapshot.docs) {
        allResults.add(productoDoc.data());
      }
    }
    final random = Random();
    List<Map<String, dynamic>> randomResults = [];
    while (randomResults.length < 4 && allResults.length > 0) {
      var randomIndex = random.nextInt(allResults.length);
      randomResults.add(allResults.removeAt(randomIndex));
    }
    setState(() {
      _allResults = randomResults;
    });
  }

  void _filtradoOfertaServicio() async {
    List<Map<String, dynamic>> allResultsServ = [];
    final vendedoresSnapshot = await FirebaseFirestore.instance.collection('vendedores').get();
    for (var vendedorDoc in vendedoresSnapshot.docs) {
      final serviciosSnapshot = await vendedorDoc.reference.collection('servicios').where('oferta', isEqualTo: 'Sí').get();

      for (var servicioDoc in serviciosSnapshot.docs) {
        allResultsServ.add(servicioDoc.data());
      }
    }
    final random = Random();
    List<Map<String, dynamic>> randomResults = [];
    while (randomResults.length < 4 && allResultsServ.length > 0) {
      var randomIndex = random.nextInt(allResultsServ.length);
      randomResults.add(allResultsServ.removeAt(randomIndex));
    }
    setState(() {
      _allResultsServ = randomResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: Text("PRODUCTOS EN OFERTA",
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
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 25.0,
                  childAspectRatio: 0.62,
                ),
                itemCount: _allResults.length,
                itemBuilder: (context, index) {
                  final producto = _allResults[index];
                  return Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
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
                                child: Image.network(producto['imagen'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 150,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(producto['nombre'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 22, top: 10),
                                                child: Text(
                                                  'Antes:',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 17, bottom: 5),
                                                child: Text('\$${(producto['precio'])}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                    decoration: TextDecoration.lineThrough,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10, left: 30),
                                              child: Text(
                                                'Ahora:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 5, left: 25),
                                              child: Text('\$${(producto['precioTotal'])}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal:45),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context)=>DetalleProduOfertaC(producto: producto, correo: widget.correo)));
                                        },
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                        label: Text("Ver",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(vertical: 5, horizontal:10),
                                          backgroundColor: AppMaterial().getColorAtIndex(1),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                )
                            ),
                            child: Text('${producto['descuento'].toString()}% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ]
                  );
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>ProductosOfertaC(correo: widget.correo)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(50, 187, 32, 300),
                  ),
                  child: Text("Ver más ofertas",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: Container(
              child: Text("SERVICIOS EN OFERTA",
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
          Padding(
            padding: const EdgeInsets.only(left: 12,right: 12),
            child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 25.0,
                  childAspectRatio: 0.62,
                ),
                itemCount: _allResultsServ.length,
                itemBuilder: (context, index) {
                  final servicio = _allResultsServ[index];
                  return Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
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
                                child: Image.network(servicio['imagen'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 150,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(servicio['nombre'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 22, top: 10),
                                                child: Text(
                                                  'Antes:',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 17, bottom: 5),
                                                child: Text('\$${(servicio['precio'])}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                    decoration: TextDecoration.lineThrough,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10, left: 30),
                                              child: Text(
                                                'Ahora:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 5, left: 25),
                                              child: Text('\$${(servicio['precioTotal'])}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal:45),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context)=>DetalleServOfertaC(servicio: servicio, correo: widget.correo)));
                                        },
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                        label: Text("Ver",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(vertical: 5, horizontal:10),
                                          backgroundColor: AppMaterial().getColorAtIndex(1),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                )
                            ),
                            child: Text('${servicio['descuento'].toString()}% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ]
                  );
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 25),
            child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>ServiciosOfertaC(correo: widget.correo)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(50, 187, 32, 300),
                  ),
                  child: Text("Ver más ofertas",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriasV extends StatelessWidget {
  final String correo;
  CategoriasV({required this.correo});
  
  Future<List<Map<String, dynamic>>> _obtenerServicios() async {
    var vendedoresData = await FirebaseFirestore.instance.collection('vendedores').get();
    List<Map<String, dynamic>> allServicios = [];
    for (var vendedorSnapshot in vendedoresData.docs) {
      var serviciosSnapshot = await vendedorSnapshot.reference.collection('servicios').orderBy('nombre').get();
      for (var servicioDoc in serviciosSnapshot.docs) {
        allServicios.add(servicioDoc.data() as Map<String, dynamic>);
      }
    }
    return allServicios;
  }

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
                            MaterialPageRoute(builder: (context) => ProductosCategoriaC(categoriaSeleccionada: 'Accesorios', correo: correo)));
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
                            MaterialPageRoute(builder: (context) => ProductosCategoriaC(categoriaSeleccionada: 'Comida', correo: correo))
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
                            MaterialPageRoute(builder: (context) => ProductosCategoriaC(categoriaSeleccionada: 'Ropa', correo: correo))
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
                            MaterialPageRoute(builder: (context) => ProductosCategoriaC(categoriaSeleccionada: 'Artesanías', correo: correo))
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
                            MaterialPageRoute(builder: (context) => ProductosCategoriaC(categoriaSeleccionada: 'Plantas', correo: correo))
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
                            MaterialPageRoute(builder: (context) => ProductosCategoriaC(categoriaSeleccionada: 'Cuidado Personal', correo: correo))
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
                        var serviciosData = await _obtenerServicios();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiciosC(correo: correo, serviciosData: serviciosData),
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
                            MaterialPageRoute(builder: (context) => ProductosCategoriaC(categoriaSeleccionada: 'Venta de Garaje', correo: correo))
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