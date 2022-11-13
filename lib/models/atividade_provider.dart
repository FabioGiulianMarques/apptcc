import 'package:flutter/material.dart';

class AtividadeProvider extends ChangeNotifier {
  String _idAtividade = '';
  String _nome = '';

  String get idAtividade => _idAtividade;
  String get nome => _nome;

  void atualizaIdAtividade(String novoIdAtividade) {
    _idAtividade = novoIdAtividade;
    notifyListeners();
  }

  void atualizaNomeAtividade(String novoNomeAtividade) {
    _nome = novoNomeAtividade;
    notifyListeners();
  }
}
