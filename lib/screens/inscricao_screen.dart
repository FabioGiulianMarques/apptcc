// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'package:ajudasocial22/models/acao_social_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/atividade_provider.dart';
import '../models/user_provider.dart';
import '../services/auth_service.dart';
import '../widgets/drawer.dart';
import 'atividade_lista_screen.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class InscricaoScreen extends StatefulWidget {
  const InscricaoScreen({super.key});

  @override
  State<InscricaoScreen> createState() => _InscricaoScreenState();
}

class _InscricaoScreenState extends State<InscricaoScreen> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = true;
  final DateTime dataHoje = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // SE O USUÁRIO NÃO ESTÁ LOGADO, DIRECIONA PARA A TELA DE LOGIN
    String? usuario = FirebaseAuth.instance.currentUser?.email.toString();
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

    // BUSCA O ID DA ACAO SOCIAL NO PROVIDER AcaoSocialProvider
    final nomeAcaoSocial =
        Provider.of<AcaoSocialProvider>(context, listen: false).nomeAcaoSocial;

    // BUSCA O ID DA ATIVIDADE NO PROVIDER AtividadeProvider
    final idAtividade =
        Provider.of<AtividadeProvider>(context, listen: false).idAtividade;

    // BUSCA O TIPO DE USUÁRIO NO PROVIDER UserProvider
    final tipoUsuario =
        Provider.of<UserProvider>(context, listen: false).tipoUsuario;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        title: const Text(
          'Inscrição',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('acao_social')
              .doc(idAcaoSocial)
              .collection('atividade')
              .doc(idAtividade)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return carregando();
            }

            return SingleChildScrollView(
              child: Card(
                color: const Color.fromARGB(172, 255, 255, 255),
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Nome da Ação Social',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            nomeAcaoSocial,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 15, 80, 140),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nome da Atividade',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            snapshot.data!.get('nome'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 15, 80, 140),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Endereço',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            snapshot.data!.get('endereco'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 15, 80, 140),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Data',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.get('data_atividade'),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 15, 80, 140),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Hora',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.get('hora_atividade'),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 15, 80, 140),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Descrição da Atividade',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            snapshot.data!.get('descricao'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 15, 80, 140),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //--------------------------------------------------
                          // BOTÃO VOLTAR
                          //--------------------------------------------------
                          TextButton.icon(
                            icon: const Icon(Icons.backspace_outlined,
                                color: Colors.white),
                            label: const Text("Voltar"),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(8.0),
                              backgroundColor: Colors.amber.shade600,
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomeScreen(),
                                  ));
                            },
                          ),
                          const SizedBox(width: 10),

                          //--------------------------------------------------
                          // BOTÃO INSCRIÇÃO
                          //--------------------------------------------------
                          tipoUsuario == 'Entidade'
                              ? const SizedBox()
                              : StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('acao_social')
                                      .doc(idAcaoSocial)
                                      .collection('atividade')
                                      .doc(idAtividade)
                                      .collection('inscritos')
                                      .doc(usuario)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return carregando();
                                    }
                                    String labelInscricao = '';
                                    Color cor = Colors.white;
                                    bool inscrito = false;

                                    if (snapshot.data!.exists) {
                                      labelInscricao = 'Cancelar inscrição';
                                      cor = Colors.red;
                                      inscrito = true;
                                    } else {
                                      labelInscricao = 'Quero participar';
                                      cor = Colors.green;
                                      inscrito = false;
                                    }

                                    return TextButton.icon(
                                      icon: Icon(
                                          inscrito
                                              ? Icons.close_outlined
                                              : Icons.task_alt,
                                          color: Colors.white),
                                      label: Text(labelInscricao),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.all(8.0),
                                        backgroundColor: cor,
                                        textStyle:
                                            const TextStyle(fontSize: 16),
                                      ),
                                      onPressed: () {
                                        if (inscrito == false) {
                                          inscrever(idAcaoSocial, idAtividade,
                                              usuario);
                                        } else {
                                          cancelarInscricao(idAcaoSocial,
                                              idAtividade, usuario);
                                        }
                                      },
                                    );
                                  })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future inscrever(
      String idAcaoSocial, String idAtividade, String? usuario) async {
    try {
      // BUSCA O NOME DO USUÁRIO NO PROVIDER UserProvider
      final nomeUsuario =
          Provider.of<UserProvider>(context, listen: false).nomeUsuario;

      await FirebaseFirestore.instance
          .collection('acao_social')
          .doc(idAcaoSocial)
          .collection('atividade')
          .doc(idAtividade)
          .collection('inscritos')
          .doc(usuario)
          .get()
          .then((doc) {
        if (!doc.exists) {
          FirebaseFirestore.instance
              .collection('acao_social')
              .doc(idAcaoSocial)
              .collection('atividade')
              .doc(idAtividade)
              .collection('inscritos')
              .doc(usuario)
              .set({
            'nome': nomeUsuario,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inscrição realizada com sucesso.'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Você já está inscrito nesta atividade.'),
              backgroundColor: Colors.red,
            ),
          );
        }
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

  cancelarInscricao(String idAcaoSocial, String idAtividade, String? usuario) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atividades'),
          content:
              const Text('Cancelar inscrição?', style: TextStyle(fontSize: 18)),
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
                  FirebaseFirestore.instance
                      .collection('acao_social')
                      .doc(idAcaoSocial)
                      .collection('atividade')
                      .doc(idAtividade)
                      .collection('inscritos')
                      .doc(usuario)
                      .delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Inscrição cancelada com sucesso.'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // VOLTA PARA A LISTA
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ));
                },
                child: const Text('Excluir'))
          ],
        );
      },
    );
  }

  carregando() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }
}
