import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Implementa o Exception padrão, criando uma exceção específica do serviço de autenticação
class AuthException implements Exception {
  String mensagem;
  AuthException(this.mensagem);
}

// Extende ChangeNotifier para poder avisar as demais telas das alterações de estado
class AuthService extends ChangeNotifier {
  // Recupera a instância atual da autenticação
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  // Construtor
  AuthService() {
    _authCheck();
  }

  _authCheck() {
    // Recupera o estado atual do usuário do Firebase
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;

      // Notifica toda a aplicação que o usuário foi alterado
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  registrar(String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('Senha muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('E-mail já está cadastrado.');
      }
    }
  }

  logar(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Usuário não encontrado.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha inválida.');
      }
    }
  }

  sair() async {
    await _auth.signOut();
    _getUser();
  }
}
