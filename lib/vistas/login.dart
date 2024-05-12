import 'package:emprende_mas/vistas/homecliente.dart';
import 'package:emprende_mas/vistas/homevendedor.dart';
import 'package:emprende_mas/vistas/register.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usuario = TextEditingController();
  final contrasena = TextEditingController();
  final form = GlobalKey<FormState>();

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

  void validacion(){
    String usu = usuario.text;
    String contra = contrasena.text;
    if (usu=="martin"&&contra=="123"){
      //cliente
      mensaje();
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>HomeCliente())
      );
    }else if(usu=="salome"&&contra=="789"){
      //vendedor
      mensaje();
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>HomeVendedor())
      );
    }else{
      mensaje2();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: form,
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
                Text("INICIAR SESIÓN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 40),
                  child: TextFormField(
                    controller: usuario,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.person
                      ),
                      labelText: "Usuario",
                      hintText: "Ingrese su usuario",
                      filled: true,
                      fillColor: AppMaterial().getColorAtIndex(0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty){
                        return "Ingrese su usuario";
                      }else{
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    obscureText: true,
                    controller: contrasena,
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
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                FilledButton(
                    onPressed: (){
                      validacion();
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
                      MaterialPageRoute(builder: (context) => Register())
                    );
                  },
                  child: Text("Crea una cuenta",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppMaterial().getColorAtIndex(2)
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
