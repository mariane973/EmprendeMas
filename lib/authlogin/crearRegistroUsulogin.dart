import 'package:firebase_auth/firebase_auth.dart';

class RegistroUsuario {
  final FirebaseAuth _fa = FirebaseAuth.instance;

  Future registroUsuario(String correo, String contra) async {
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
  Future loginUsario(String correo, String contra) async {
    if(correo.isNotEmpty && contra.isNotEmpty){
      try {
        UserCredential uc = await _fa.signInWithEmailAndPassword(email: correo, password: contra);
        final u = uc.user;

        if(u != null){
          return u.uid;
        }
      }
      on FirebaseAuthException catch (e) {
        print("Error de autenticación: ${e.code}");
        if(e.code == 'user-not-found' || e.code == 'wrong-password'){
          return "1";
        }
      } catch (e) {
        print("Error: $e");
      }
    } else {
      print("Correo y contraseña no pueden estar vacios");
      return "1";
    }
  }
}
