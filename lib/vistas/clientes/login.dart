import 'package:emprende_mas/authlogin/crearRegistroUsulogin.dart';
import 'package:emprende_mas/home.dart';
import 'package:emprende_mas/huella/autenticacion.dart';
import 'package:emprende_mas/vistas/clientes/homecliente.dart';
import 'package:emprende_mas/vistas/clientes/register.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  RegistroUsuario mial = RegistroUsuario();
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
  /*
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
  }*/

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
          ),
        ),
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
                Text("Usuario",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppMaterial().getColorAtIndex(2)
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
                        var dato = await mial.loginUsario(_emailController, _passwordController);
                        print("HOLA $dato");
                        if(dato == 2){
                          print("Datos no encontrados");
                        }else if(dato==3){
                          print("Se enviaron datos vacios");
                        }else if(dato==1){
                          bool auth = await Autenticacion.authentication();
                          print("Puede autenticarse: $auth");
                          if(auth){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeCliente())
                            );
                          }
                        }else{
                          print("MMMM");
                        }
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
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register())
                    );
                  },
                  child: Text("¿Olvidaste tu contraseña?",
                    style: TextStyle(
                        fontSize: 18,
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
    );
  }
}
