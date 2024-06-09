import 'package:emprende_mas/authlogin/crearRegistroUsulogin.dart';
import 'package:emprende_mas/home.dart';
import 'package:emprende_mas/vistas/emprendedores/loginV.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterV extends StatefulWidget {
  const RegisterV({super.key});

  @override
  State<RegisterV> createState() => _RegisterVState();
}

class _RegisterVState extends State<RegisterV> {
  RegistroUsuario mial = RegistroUsuario();

  final _formKey = GlobalKey<FormState>();

  late String _email;
  late String _password;
  late String _confirmPassword;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
                  height: 30,
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("img/tucanemp.png")
                      )
                  ),
                ),
                Text("CREAR CUENTA",
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
                    controller: _emailController,
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
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    controller: _passwordController,
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
                      if (value == null || value.isEmpty) {
                        return "Ingrese su contraseña";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      labelText: "Confirmar contraseña",
                      hintText: "Ingrese nuevamente su contraseña",
                      filled: true,
                      fillColor: AppMaterial().getColorAtIndex(0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese la confirmación de su contraseña";
                      } else if(_passwordController.text != _confirmPasswordController.text){
                        return "Las contraseñas no coinciden";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _confirmPassword = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FilledButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        var dato = mial.registroUsuario(_email, _password);
                        if(dato==1){
                          print("Nivel de seguridad debil");
                        }else if(dato==2){
                          print("Email ya esta registrado");
                        }else if(dato != null){
                          guardarCorreoEnFirestore(_email);
                          Fluttertoast.showToast(
                              msg: "Usuario Registrado",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              textColor: Colors.white,
                              backgroundColor: AppMaterial().getColorAtIndex(0),
                              fontSize: 18
                          );
                        }
                      }
                    },
                    style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                        backgroundColor: AppMaterial().getColorAtIndex(1)
                    ),
                    child: Text("Registrar",
                      style: TextStyle(
                          fontSize: 22
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 5),
                  child: Text("¿Ya tienes una cuenta?",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black45
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginV())
                    );
                  },
                  child: Text("Iniciar sesión",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppMaterial().getColorAtIndex(3)
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void guardarCorreoEnFirestore(String correo) async {
  try {
    await FirebaseFirestore.instance.collection('vendedores').doc(correo).set({
      'correo': correo,
    });
    await FirebaseFirestore.instance.collection('vendedores').doc(correo).collection('productos').doc().set({
    });
    print('Correo guardado exitosamente en Firestore');
  } catch (error) {
    print('Error al guardar el correo en Firestore: $error');
  }
}
