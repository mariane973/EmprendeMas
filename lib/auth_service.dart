import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<void> sendEmailVerificacionLink()async{
    try{
      await _auth.currentUser?.sendEmailVerification();
    }catch (e){
      print(e.toString());
    }
  }
  Future<void> sendPasswordResetLink(String email)async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    }catch (e){
      print(e.toString());
    }
  }

}