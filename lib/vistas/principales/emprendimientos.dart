import 'package:EmprendeMas/vistas/principales/subDetalles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:EmprendeMas/vistas/principales/slideprincipal.dart';

class DatosVendedores extends StatefulWidget {
  final List<Map<String, dynamic>> vendedoresData;

  DatosVendedores({required this.vendedoresData});

  @override
  State<DatosVendedores> createState() => _DatosVendedoresState();
}

class _DatosVendedoresState extends State<DatosVendedores> {
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
      for(var vendedorShapshot in _resultados){
        var nombre = vendedorShapshot['nombre_emprendimiento'].toString().toLowerCase();
        if(nombre.contains(_searchController.text.toLowerCase())){
          showResults.add(vendedorShapshot);
        }
      }
    } else {
      showResults = List.from(_resultados);
    }
    setState(() {
      _resultadosList = showResults;
    });
  }

  Future<List<DocumentSnapshot>> getVendedorStream() async {
    var data = await FirebaseFirestore.instance.collection('vendedores').orderBy('nombre_emprendimiento').get();
    setState(() {
      _resultados = data.docs;
    });
    searchResultList();
    return data.docs;
  }

  @override
  void didChangeDependencies() async {
    _resultados = await getVendedorStream();
    searchResultList();
    super.didChangeDependencies();
  }

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
        ),
        drawer: PrincipalDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Text('EMPRENDIMIENTOS',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _resultadosList.length,
                itemBuilder: (context, index) {
                  final vendedor = _resultadosList[index];
                  return GestureDetector(
                    onTap: () async {
                      DocumentSnapshot emprendedorSnapshot = _resultadosList[index];
                      DocumentReference emprendedorRef = emprendedorSnapshot.reference;

                      CollectionReference productoRef = emprendedorRef.collection('productos');
                      QuerySnapshot productosSnapshot = await productoRef.get();
                      List<Map<String, dynamic>> productoData = productosSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                      CollectionReference servicioRef = emprendedorRef.collection('servicios');
                      QuerySnapshot serviciosSnapshot = await servicioRef.get();
                      List<Map<String, dynamic>> servicioData = serviciosSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> SubDetalles(productoData: productoData, servicioData: servicioData)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 18, top: 15, right: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 4,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(vendedor['logo_emprendimiento'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.56,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(vendedor['nombre_emprendimiento'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(vendedor['descripcion_emprendimiento'],
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          )
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