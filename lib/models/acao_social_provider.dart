import 'package:flutter/material.dart';

class AcaoSocialProvider extends ChangeNotifier {
  String _idAcaoSocial = '';
  String _nomeAcaoSocial = '';

  String get idAcaoSocial => _idAcaoSocial;
  String get nomeAcaoSocial => _nomeAcaoSocial;

  void atualizaIdAcaoSocial(String novoIdAcaoSocial) {
    _idAcaoSocial = novoIdAcaoSocial;
    notifyListeners();
  }

  void atualizaNomeAcaoSocial(String novoNomeAcaoSocial) {
    _nomeAcaoSocial = novoNomeAcaoSocial;
    notifyListeners();
  }
}
