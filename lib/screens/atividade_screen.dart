// ignore_for_file: use_build_context_synchronously

import 'package:ajudasocial22/helpers/definicoes.dart';
import 'package:ajudasocial22/helpers/validators.dart';
import 'package:ajudasocial22/models/acao_social_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/atividade_provider.dart';
import '../services/auth_service.dart';
import '../widgets/drawer.dart';
import 'atividade_lista_screen.dart';

import 'login_screen.dart';

class AtividadeScreen extends StatefulWidget {
  const AtividadeScreen({super.key});

  @override
  State<AtividadeScreen> createState() => _AtividadeScreenState();
}

class _AtividadeScreenState extends State<AtividadeScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController dataAcaoController = TextEditingController();
  final TextEditingController horaAcaoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  bool isLoading = true;
  final DateTime dataHoje = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // SE O USUÁRIO NÃO ESTÁ LOGADO, DIRECIONA PARA A TELA DE LOGIN
    String? usuario = FirebaseAuth.instance.currentUser?.email;
    if (usuario == '') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ));
    }

    // BUSCA O ID DA ACAO SOCIAL NO PROVIDER AcaoSocialProvider
    final idAcaoSocial =
        Provider.of<AcaoSocialProvider>(context, listen: false).idAcaoSocial;

    // BUSCA O ID DA ATIVIDADE NO PROVIDER AtividadeProvider
    final idAtividade =
        Provider.of<AtividadeProvider>(context, listen: false).idAtividade;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        title: const Text(
          'Cadastro Atividades',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Builder(builder: (context) {
        // SE ESTIVER CARREGANDO A PÁGINA, BUSCA OS DADOS
        if (idAtividade != '' && isLoading) {
          buscar(idAcaoSocial, idAtividade);
          isLoading = false;
        }

        return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Card(
                color: const Color.fromARGB(172, 255, 255, 255),
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: nomeController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Nome da Atividade*'),
                            autocorrect: false,
                            validator: (String? conteudo) {
                              if (conteudo!.isEmpty) {
                                return 'Nome da Atividade é obrigatório.';
                                // Verifica se foram digitadas duas palavras (nome completo)
                                //} else if (name.trim().split(' ').length <= 1) {
                                //  return 'Preencha seu nome completo.';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: enderecoController,
                            keyboardType: TextInputType.text,
                            decoration:
                                const InputDecoration(labelText: 'Endereço*'),
                            autocorrect: false,
                            validator: (String? conteudo) {
                              if (conteudo!.isEmpty) {
                                return 'Endereço é obrigatório.';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: dataAcaoController,
                            inputFormatters: [maskData],
                            keyboardType: TextInputType.number,
                            enabled: true,
                            decoration:
                                const InputDecoration(labelText: 'Data*'),
                            autocorrect: false,
                            validator: (String? conteudo) {
                              if (conteudo!.isEmpty) {
                                return 'Data é obrigatória.';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: horaAcaoController,
                            inputFormatters: [maskHora],
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Hora*'),
                            autocorrect: false,
                            validator: (String? conteudo) {
                              if (conteudo!.isEmpty) {
                                return 'Hora é obrigatória.';
                              } else {
                                if (!horaValida(conteudo)) {
                                  return 'Hora inválida';
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                          TextFormField(
                            controller: descricaoController,
                            maxLines: 5,
                            decoration:
                                const InputDecoration(labelText: 'Descrição'),
                            autocorrect: false,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //--------------------------------------------------
                          // BOTÃO EXCLUIR
                          //--------------------------------------------------

                          TextButton.icon(
                            icon: const Icon(Icons.delete_outline_outlined,
                                color: Colors.white),
                            label: const Text("Excluir"),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(10.0),
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              if (idAtividade != '') {
                                excluir(idAcaoSocial, idAtividade);
                              }
                            },
                          ),
                          const SizedBox(width: 3),
                          //--------------------------------------------------
                          // BOTÃO VOLTAR
                          //--------------------------------------------------
                          TextButton.icon(
                            icon: const Icon(Icons.backspace_outlined,
                                color: Colors.white),
                            label: const Text("Voltar"),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(10.0),
                              backgroundColor: Colors.amber.shade600,
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AtividadeListaScreen(),
                                  ));
                            },
                          ),
                          const SizedBox(width: 3),
                          //--------------------------------------------------
                          // BOTÃO SALVAR
                          //--------------------------------------------------
                          TextButton.icon(
                            icon:
                                const Icon(Icons.task_alt, color: Colors.white),
                            label: const Text("Salvar"),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(10.0),
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                salvar(idAcaoSocial, idAtividade);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AtividadeListaScreen(),
                                    ));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      }),
    );
  }

  Future buscar(String idAcaoSocial, String idAtividade) async {
    try {
      FirebaseFirestore.instance
          .collection('acao_social')
          .doc(idAcaoSocial)
          .collection('atividade')
          .doc(idAtividade)
          .get()
          .then((doc) {
        nomeController.text = doc.get('nome');
        enderecoController.text = doc.get('endereco');
        dataAcaoController.text = doc.get('data_atividade');
        horaAcaoController.text = doc.get('hora_atividade');
        descricaoController.text = doc.get('descricao');
      });
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.mensagem),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future salvar(String idAcaoSocial, String idAtividade) async {
    try {
      if (idAtividade != '') {
        FirebaseFirestore.instance
            .collection('acao_social')
            .doc(idAcaoSocial)
            .collection('atividade')
            .doc(idAtividade)
            .update({
          'nome': nomeController.text,
          'endereco': enderecoController.text,
          'data_atividade': dataAcaoController.text,
          'hora_atividade': horaAcaoController.text,
          'descricao': descricaoController.text,
        });
      } else {
        CollectionReference atividade = FirebaseFirestore.instance
            .collection('acao_social')
            .doc(idAcaoSocial)
            .collection('atividade');

        atividade.add({
          'nome': nomeController.text,
          'endereco': enderecoController.text,
          'data_atividade': dataAcaoController.text,
          'hora_atividade': horaAcaoController.text,
          'descricao': descricaoController.text,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados armazenados com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.mensagem),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future excluir(String idAcaoSocial, String idAtividade) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cadastro de Atividades'),
          content:
              const Text('Excluir Atividade?', style: TextStyle(fontSize: 18)),
          actions: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20),
                  backgroundColor: Colors.amber.shade600,
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  // VOLTA A TELA ANTERIOR AO DIÁLOGO SEM FAZER QUALQUER ALTERAÇÃO
                  Navigator.pop(context);
                },
                child: const Text('Cancelar')),
            TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.all(12.0),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  // EXCLUI O DOCUMENTO ATIVIDADE
                  await FirebaseFirestore.instance
                      .collection('acao_social')
                      .doc(idAcaoSocial)
                      .collection('atividade')
                      .doc(idAtividade)
                      .delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ação Social excluída com sucesso.'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // VOLTA PARA A LISTA
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AtividadeListaScreen(),
                      ));
                },
                child: const Text('Excluir'))
          ],
        );
      },
    );
  }
}
