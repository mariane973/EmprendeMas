import 'package:EmprendeMas/vistas/emprendedores/detalleServicioV.dart';
import 'package:EmprendeMas/vistas/emprendedores/insertarServicio.dart';
import 'package:EmprendeMas/vistas/emprendedores/slidebarEmprendedor.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiciosV extends StatefulWidget {
  final String correo;

  ServiciosV({required this.correo});

  @override
  State<ServiciosV> createState() => _ServiciosVState();
}

class _ServiciosVState extends State<ServiciosV> {
  List _resultados = [];
  List _resultadosList = [];
  final TextEditingController _searchController = TextEditingController();

  void initState(){
    super.initState();
    _searchController.addListener(_onSearchChanged);
    getServicioStream();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged(){
    searchResultList();
  }

  searchResultList(){
    var showResults = [];
    if(_searchController.text != ""){
      for(var servicioShapshot in _resultados){
        var nombre = servicioShapshot['nombre'].toString().toLowerCase();
        if(nombre.contains(_searchController.text.toLowerCase())){
          showResults.add(servicioShapshot);
        }
      }
    } else {
      showResults = List.from(_resultados);
    }
    setState(() {
      _resultadosList = showResults;
    });
  }

  getServicioStream() async {
    var data = await FirebaseFirestore.instance
        .collection('vendedores')
        .doc(widget.correo)
        .collection('servicios')
        .orderBy('nombre')
        .get();

    setState(() {
      _resultados = data.docs;
      _resultadosList = data.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppMaterial().getColorAtIndex(6),
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
                    height: 45,
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
        drawer: SlidebarVendedor(correo: widget.correo),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Text("ADMINISTRAR SERVICIOS",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FormServicio(correo: widget.correo))
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 95),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppMaterial().getColorAtIndex(4),
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 20),
                            child: FaIcon(
                              FontAwesomeIcons.plusCircle,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Text(
                              "Agregar Servicio",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _resultadosList.length,
                itemBuilder: (context, index) {
                  final servicio = _resultadosList[index]; 
                  final servicioData = servicio.data() as Map<String, dynamic>;
                  final uidServicio = servicio.id;
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => DetalleServicioV(servicio: servicioData, uidServicio: uidServicio, correo: widget.correo)
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
                              border: Border.all(
                                width: 0.2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(servicio['imagen'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.56,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(servicio['nombre'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Text(servicio['descripcion'],
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 18),
                                      child: Text(' \$${servicio['precioTotal']} COP',
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