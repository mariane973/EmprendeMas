import 'package:emprende_mas/vistas/login.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
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
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 35, bottom: 35),
                  child: TextFormField(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 35),
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
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                FilledButton(
                    onPressed: (){
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
                        MaterialPageRoute(builder: (context) => Login())
                    );
                  },
                  child: Text("Iniciar sesión",
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
