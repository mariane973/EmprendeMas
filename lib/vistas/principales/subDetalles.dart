import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:EmprendeMas/vistas/principales/slideprincipal.dart';

class SubDetalles extends StatefulWidget {
  final List<Map<String, dynamic>> productoData;
  final List<Map<String, dynamic>> servicioData;

  SubDetalles({required this.productoData,required this.servicioData});

  @override
  State<SubDetalles> createState() => _SubDetallesState();
}

class _SubDetallesState extends State<SubDetalles> {
  List<Map<String, dynamic>> _productosList = [];
  List<Map<String, dynamic>> _serviciosList = [];
  final TextEditingController _searchController = TextEditingController();

  void initState(){
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _productosList = widget.productoData;
    _serviciosList = widget.servicioData;
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

  void searchResultList() {
    List<Map<String, dynamic>> productosResults = [];
    List<Map<String, dynamic>> serviciosResults = [];
    if (_searchController.text != "") {
      for (var productoSnapshot in widget.productoData) {
        var nombre = productoSnapshot['nombre'].toString().toLowerCase();
        if (nombre.contains(_searchController.text.toLowerCase())) {
          productosResults.add(productoSnapshot);
        }
      }
      for (var servicioSnapshot in widget.servicioData) {
        var nombre = servicioSnapshot['nombre'].toString().toLowerCase();
        if (nombre.contains(_searchController.text.toLowerCase())) {
          serviciosResults.add(servicioSnapshot);
        }
      }
    } else {
      productosResults = List.from(widget.productoData);
      serviciosResults = List.from(widget.servicioData);
    }

    setState(() {
      _productosList = productosResults;
      _serviciosList = serviciosResults;
    });
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
              _productosList.isEmpty
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                    _searchController.text.isEmpty
                        ? "El emprendimiento no ofrece productos."
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
                itemCount: _productosList.length,
                itemBuilder: (context, index) {
                  final producto = _productosList[index];
                  return GestureDetector(
                    onTap: (){
                      /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DetalleProducto(producto: producto)
                        ),
                      );*/
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
                              child: Image.network(
                                producto['imagen'],
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
                                      Text(producto['nombre'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(producto['descripcion'],
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 18),
                                        child: Text(' \$${producto['precio']} COP',
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
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Text("SERVICIOS",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _serviciosList.isEmpty
                  ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                      _searchController.text.isEmpty
                          ? "El emprendimiento no ofrece servicios."
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
                  itemCount: _serviciosList.length,
                  itemBuilder: (context, index) {
                    final servicio = _serviciosList[index];
                    return GestureDetector(
                      onTap: (){
                        /*Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DetalleServicio(servicio: servicio)
                          ),
                        );*/
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
                              child: Image.network(
                                servicio['imagen'],
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
                                        child: Text(' \$${servicio['precio']} COP',
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

