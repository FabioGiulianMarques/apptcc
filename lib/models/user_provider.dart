import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  // tipoUsuario: Voluntário ou Entidade

  String _tipoUsuario = '';
  String _nomeUsuario = '';

  String get tipoUsuario => _tipoUsuario;
  String get nomeUsuario => _nomeUsuario;

  void atualizaTipoUsuario(String novoTipoUsuario) {
    _tipoUsuario = novoTipoUsuario;
    notifyListeners();
  }

  void atualizaNomeUsuario(String novoNomeUsuario) {
    _nomeUsuario = novoNomeUsuario;
    notifyListeners();
  }
}
