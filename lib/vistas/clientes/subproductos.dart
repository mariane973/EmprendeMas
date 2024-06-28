import 'package:EmprendeMas/vistas/clientes/slidebarusuario.dart';
import 'package:EmprendeMas/vistas/clientes/subDetalleProdC.dart';
import 'package:EmprendeMas/vistas/clientes/subDetalleProdC.dart';
import 'package:EmprendeMas/vistas/subDetalleProducto.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class SubProductosC extends StatefulWidget {
  final String correo;
  final List<Map<String, dynamic>> data;

  SubProductosC({required this.data, required this.correo});

  @override
  State<SubProductosC> createState() => _SubProductosCState();
}

class _SubProductosCState extends State<SubProductosC> {
  List<Map<String, dynamic>> _resultadosList = [];
  final TextEditingController _searchController = TextEditingController();

  void initState(){
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _resultadosList = widget.data;
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
    List<Map<String, dynamic>> showResults = [];
    if (_searchController.text != "") {
      for (var productoSnapshot in widget.data) {
        var nombre = productoSnapshot['nombre'].toString().toLowerCase();
        if (nombre.contains(_searchController.text.toLowerCase())) {
          showResults.add(productoSnapshot);
        }
      }
    } else {
      showResults = List.from(widget.data);
    }
    setState(() {
      _resultadosList = showResults;
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
        ),drawer: SlidebarUsuario(correo: widget.correo),
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
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _resultadosList.length,
                itemBuilder: (context, index) {
                  final producto = _resultadosList[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SubDetalleProductoC(producto: producto, correo: widget.correo,)
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
            ],
          ),
        ),
      ),
    );
  }
}

