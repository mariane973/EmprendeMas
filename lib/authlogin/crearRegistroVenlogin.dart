import 'package:firebase_auth/firebase_auth.dart';

class RegistroVendedor {
  final FirebaseAuth _fa = FirebaseAuth.instance;

  Future registroVendedor(String correo, String contra) async {
    try{
      UserCredential uc = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: correo, password: contra);
      print(uc.user);
      return (uc.user);
    }
    on FirebaseAuthException catch(e){
      if(e.code=='weak-password'){
        print("El password");
        return 1;
      }
      else if(e.code=='email-already--in-use'){
        print("Ya existe");
        return 2;
      }
    }
  }
  Future loginVendedor(String correo, String contra) async {
    if(correo.isNotEmpty && contra.isNotEmpty){
      try {
        UserCredential uc = await _fa.signInWithEmailAndPassword(email: correo, password: contra);
        final u = uc.user;

        if(u != null){
          return 1;
        }
      }
      on FirebaseAuthException catch (e) {
        print("Error de autenticación: ${e.code}");
        if(e.code == 'user-not-found' || e.code == 'wrong-password'){
          return 2;
        }
      } catch (e) {
        print("Error: $e");
      }
    } else {
      print("Correo y contraseña no pueden estar vacios");
      return 3;
    }
  }
}
