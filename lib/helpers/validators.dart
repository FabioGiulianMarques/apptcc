import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

bool emailValid(String email) {
  final RegExp regex = RegExp(
      r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");
  return regex.hasMatch(email);
}

bool horaValida(String horario) {
  List horaMinuto = horario.trim().split(':');
  int hora = int.parse(horaMinuto[0]);
  int minuto = int.parse(horaMinuto[1]);

  if (hora > 23) {
    return false;
  } else {
    if (minuto > 59) {
      return false;
    } else {
      return true;
    }
  }
}

verificaUsuario(context) {
  var usuario = FirebaseAuth.instance.currentUser?.email;

  if (usuario != '' && usuario != null) {
    return usuario;
  } else {
    final FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();

    // NAVEGA PARA A TELA DE LOGIN
    Navigator.of(context).pushReplacementNamed('login');

    // EXIBE MENSAGEM DE FALHA DE COMUNICAÇÃO
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Falha na comunicação. Verifique seu sinal de internet.'),
        backgroundColor: Colors.red,
      ),
    );

    return '';
  }
}
