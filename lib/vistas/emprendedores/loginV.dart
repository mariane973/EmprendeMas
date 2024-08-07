import 'package:EmprendeMas/authlogin/crearRegistroVenlogin.dart';
import 'package:EmprendeMas/home.dart';
import 'package:EmprendeMas/huella/autenticacion.dart';
import 'package:EmprendeMas/vistas/emprendedores/formperfil.dart';
import 'package:EmprendeMas/vistas/emprendedores/homevendedor.dart';
import 'package:EmprendeMas/vistas/emprendedores/register.dart';
import 'package:flutter/material.dart';
import 'package:EmprendeMas/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:EmprendeMas/vistas/emprendedores/PasswordReset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

class LoginV extends StatefulWidget {
  const LoginV({super.key});

  @override
  State<LoginV> createState() => _LoginVState();
}

class _LoginVState extends State<LoginV> {
  RegistroVendedor mial = RegistroVendedor();
  final _formKey = GlobalKey<FormState>();
  late String _emailController;
  late String _passwordController;

  void mensaje(){
    Fluttertoast.showToast(
        msg: "Ingreso Exitoso",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        textColor: Colors.white,
        backgroundColor: AppMaterial().getColorAtIndex(1),
        fontSize: 18
    );
  }

  void mensaje2(){
    Fluttertoast.showToast(
        msg: "Datos Incorrectos",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        textColor: Colors.white,
        backgroundColor: Colors.red,
        fontSize: 18
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Row(
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.home,
                    color: AppMaterial().getColorAtIndex(1),
                    size: 20.0,
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Regresar",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("img/tucanemp.png")
                      )
                  ),
                ),
                Text("INICIAR SESIÓN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text("Vendedor",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppMaterial().getColorAtIndex(3)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.alternate_email_rounded
                      ),
                      labelText: "Correo",
                      hintText: "Ingrese su correo",
                      filled: true,
                      fillColor: AppMaterial().getColorAtIndex(0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese su correo";
                      } else if(!value.contains("@")){
                        return "El correo no es válido";
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value){
                      _emailController = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.key
                      ),
                      labelText: "Contraseña",
                      hintText: "Ingrese su contraseña",
                      filled: true,
                      fillColor: AppMaterial().getColorAtIndex(0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty){
                        return "Ingrese su contraseña";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (value){
                      _passwordController=value!;
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                FilledButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        String dato = await mial.loginVendedor(_emailController, _passwordController);
                        print("HOLA $dato");
                        if(dato == "1"){
                          print("Datos no encontrados");
                          mensaje2();
                        }else if(dato=="2"){
                          print("Se enviaron datos vacios");
                          mensaje2();
                        }else if(dato!=""){
                          bool auth = await Autenticacion.authentication();
                          print("Puede autenticarse: $auth");
                          if (auth) {
                            QuerySnapshot userDocs = await FirebaseFirestore.instance.collection('vendedores').where('correo', isEqualTo: _emailController).get();
                            if (userDocs.docs.isNotEmpty) {
                              DocumentSnapshot userDoc = userDocs.docs.first;
                              Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
                              if (userData != null) {
                                if (userData.containsKey('nombre') && userData.containsKey('apellido')) {
                                  String nombre = userData['nombre'];
                                  String apellido = userData['apellido'];
                                  String imagenUrl = userData['logo_emprendimiento'] ?? '';
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeVendedor(correo: _emailController),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FormPerfilV(dato: dato)
                                    ),
                                  );
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormPerfilV(dato: dato),
                                  ),
                                );
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormPerfilV(dato: dato),
                                ),
                              );
                            }
                          }
                        }else{
                          mensaje2();
                        }
                      } else {
                        mensaje2();
                      }
                    },
                    style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                        backgroundColor: AppMaterial().getColorAtIndex(1)
                    ),
                    child: Text("Ingresar",
                      style: TextStyle(
                          fontSize: 22
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 5),
                  child: Text("¿Aún no tienes una cuenta?",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black45
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RegisterV())
                    );
                  },
                  child: Text("Crea una cuenta como vendedor",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppMaterial().getColorAtIndex(4)
                    ),
                  ),
                ),
                SizedBox(height: 35),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PasswordReset())
                    );
                  },
                  child: Text("¿Olvidaste tu contraseña?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppMaterial().getColorAtIndex(4)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}