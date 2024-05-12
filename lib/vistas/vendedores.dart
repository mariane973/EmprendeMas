import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  getVendedorStream() async {
    var data = await FirebaseFirestore.instance.collection('vendedores').orderBy('nombre_emprendimiento').get();
    setState(() {
      _resultados = data.docs;
    });
    searchResultList();
  }

  @override
  void didChangeDependencies() {
    getVendedorStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView.builder(
        itemCount: _resultadosList.length,
        itemBuilder: (context, index) {
          final vendedor = _resultadosList[index];
          return Column(
            children: [
              Text('Emprendimiento: ${vendedor['nombre_emprendimiento']}'),
              Text('Nombre: ${vendedor['nombre']}'),
              Text('Correo: ${vendedor['correo']}'),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}