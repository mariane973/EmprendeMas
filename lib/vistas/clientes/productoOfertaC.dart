import 'package:EmprendeMas/vistas/clientes/detalleProducOfertaC.dart';
import 'package:EmprendeMas/vistas/clientes/slidebarusuario.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductosOfertaC extends StatefulWidget {
  final String correo;
  const ProductosOfertaC({required this.correo});

  @override
  State<ProductosOfertaC> createState() => _ProductosOfertaCState();
}


class _ProductosOfertaCState extends State<ProductosOfertaC> {
  List<Map<String, dynamic>> _resultadosList = [];
  List<Map<String, dynamic>> _allResults = [];
  final TextEditingController _searchController = TextEditingController();

  void initState(){
    super.initState();
    _filtradoOferta();
    _searchController.addListener(_onSearchChanged);
  }

  void _filtradoOferta() async {
    List<Map<String, dynamic>> allResults = [];
    final vendedoresSnapshot = await FirebaseFirestore.instance.collection('vendedores').get();
    for (var vendedorDoc in vendedoresSnapshot.docs) {
      final productosSnapshot = await vendedorDoc.reference.collection('productos').where('oferta', isEqualTo: 'Sí').get();

      for (var productoDoc in productosSnapshot.docs) {
        allResults.add(productoDoc.data());
      }
    }
    setState(() {
      _allResults = allResults;
      _resultadosList = allResults;
    });
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

  void searchResultList() {
    List<Map<String, dynamic>> showResults = [];
    if (_searchController.text.isNotEmpty) {
      for (var producto in _allResults) {
        var nombre = producto['nombre'].toString().toLowerCase();
        if (nombre.contains(_searchController.text.toLowerCase())){
          showResults.add(producto);
        }
      }
    } else {
      showResults = _allResults;
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
        ), drawer: SlidebarUsuario(correo: widget.correo),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Center(
                  child: Text("PRODUCTOS EN OFERTA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _resultadosList.isEmpty
                  ? Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    _searchController.text.isEmpty
                        ? "No se encuentran ofertas."
                        : "No se encontraron coincidencias.",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: AppMaterial().getColorAtIndex(2),
                    ),
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 25.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: _resultadosList.length,
                    itemBuilder: (context, index) {
                      final producto = _resultadosList[index];
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
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 20,
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
                                                      fontSize: 16,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text('\$${(producto['precio'])}',
                                                    style: TextStyle(
                                                      fontSize: 16,
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
                                                      fontSize: 16,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text('\$${(producto['precioTotal'])}',
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
                                            padding: EdgeInsets.symmetric(vertical: 7, horizontal:45),
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (context)=>DetalleProduOfertaC(producto: producto)));
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
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            )
                          ]
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}