import 'package:flutter/material.dart';

const Color _micolor = Color(0XFF8FDABA);
const Color _micolor2 = Color(0XFF33B66C);
const Color _micolor3 = Color(0XFF03643A);
const Color _micolor4 = Color(0XFF376996);
const Color _micolor5 = Color(0XFF166088);
const Color _micolor6 = Color(0XFF164B68);
const Color _micolor7 = Color(0XFFeffaf5);
const Color _micolor8 = Color(0XFFbce4ce);

const List<Color> _ListaColores=[
  _micolor, _micolor2, _micolor3, _micolor4, _micolor5, _micolor6, _micolor7, _micolor8
];

class AppMaterial{
  ThemeData mitema(){
    return ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _ListaColores[0]);
  }
  Color getColorAtIndex(int index){
    if(index>=0 && index<_ListaColores.length){
      return _ListaColores[index];
    }else{
      return Colors.black;
    }
  }
}