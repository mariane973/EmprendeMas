import 'package:emprende_mas/vistas/clientes/login.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:emprende_mas/auth_service.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final _auth = AuthService();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("img/tucanemp.png")
                      )
                  ),
                ),
                Text("Restablecer contraseña",
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
                Padding(padding: EdgeInsets.only(top: 40),
                  child: Text("Ingresa tu correo de recuperación",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
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
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value){

                    },
                  ),
                ),
                FilledButton(
                    onPressed: () async{
                      await _auth.sendPasswordResetLink(_emailController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                Text('Se ha enviado un correo electrónico para restablecer la contraseña a su correo electrónico.')));
                      Navigator.pop(context);
                      },
                    style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                        backgroundColor: AppMaterial().getColorAtIndex(1)
                    ),
                    child: Text("Enviar Correo",
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
                        MaterialPageRoute(builder: (context) => Login())
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
