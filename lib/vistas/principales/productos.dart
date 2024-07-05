import 'package:EmprendeMas/vistas/detalleProducto.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:EmprendeMas/vistas/principales/slideprincipal.dart';

class DatosProductos extends StatefulWidget {
  final List<Map<String, dynamic>> productosData;

  DatosProductos({required this.productosData});

  @override
  State<DatosProductos> createState() => _DatosProductosState();
}

class _DatosProductosState extends State<DatosProductos> {
  List _resultados = [];
  List _resultadosList = [];
  final TextEditingController _searchController = TextEditingController();

  void initState(){
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged(){
    print(_searchController.text);
    searchResultList();
  }

  searchResultList(){
    var showResults = [];
    if(_searchController.text != ""){
      for(var productoShapshot in _resultados){
        var nombre = productoShapshot['nombre'].toString().toLowerCase();
        if(nombre.contains(_searchController.text.toLowerCase())){
          showResults.add(productoShapshot);
        }
      }
    } else {
      showResults = List.from(_resultados);
    }
    setState(() {
      _resultadosList = showResults;
    });
  }

  getProductoStream() async {
    var vendedoresData = await FirebaseFirestore.instance.collection('vendedores').get();

    List<DocumentSnapshot> allProductos = [];
    for (var vendedorSnapshot in vendedoresData.docs) {
      var productosSnapshot = await vendedorSnapshot.reference.collection('productos').orderBy('nombre').get();
      allProductos.addAll(productosSnapshot.docs);
    }
    setState(() {
      _resultados = allProductos;
    });
    searchResultList();
  }

  @override
  void didChangeDependencies() {
    getProductoStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppMaterial().getColorAtIndex(6)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    padding: EdgeInsets.only(left:10),
                    height: 50,
                    width: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppMaterial().getColorAtIndex(0),
                    ),
                    child: CupertinoSearchTextField(
                      backgroundColor: Colors.transparent,
                      controller: _searchController,
                      placeholder: 'Buscar',
                      placeholderStyle: TextStyle(
                        color: Colors.white,

                      ),
                      style: TextStyle(color: Colors.white),
                      suffixIcon: Icon(Icons.cancel),
                      prefixIcon: Icon(Icons.search),
                      itemColor:Colors.white,
                      itemSize: 23,
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
          ],
        ),drawer: PrincipalDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Text("PRODUCTOS",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),

                ),
              ),
              _resultadosList.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.only(top: 50),
                      child: Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? "No se encuentran productos."
                              : "No se encontraron coincidencias.",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            color: AppMaterial().getColorAtIndex(2),
                          ),
                        ),
                      ),
                  )
              : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _resultadosList.length,
                itemBuilder: (context, index) {
                  final productoSnapshot = _resultadosList[index];
                  final productoData = productoSnapshot.data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DetalleProducto(producto: productoData)
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 18, top: 15),
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 4,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(productoData['imagen'],
                              fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.56,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(productoData['nombre'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(productoData['descripcion'],
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 18),
                                        child: Text(' \$${productoData['precioTotal']} COP',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            color: AppMaterial().getColorAtIndex(2)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

