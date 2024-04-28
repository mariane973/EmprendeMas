import 'package:emprende_mas/vistas/login.dart';
import 'package:flutter/material.dart';
import 'package:emprende_mas/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("img/tucanemp.png")
                    )
                ),
              ),
              Text("REGISTRO",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 35, bottom: 35),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Correo",
                    hintText: "Ingrese su correo",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 35),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Usuario",
                    hintText: "Ingrese su usuario",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    hintText: "Ingrese su contraseña",
                    border: OutlineInputBorder(
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
                padding: const EdgeInsets.only(top: 40, bottom: 15),
                child: Text("Ya tienes una cuenta?",
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login())
                  );
                },
                child: Text("Iniciar Sesión",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: AppMaterial().getColorAtIndex(2)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
