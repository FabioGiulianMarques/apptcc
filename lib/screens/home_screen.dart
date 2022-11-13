import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/acao_social_provider.dart';
import '../models/atividade_provider.dart';
import '../models/user_provider.dart';
import '../widgets/drawer.dart';
import 'inscricao_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // CARREGA O USUÁRIO (E-MAIL)
    final usuario = FirebaseAuth.instance.currentUser?.email.toString();

    // BUSCA O TIPO DE USUÁRIO
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuario)
        .get()
        .then((doc) {
      // ATUALIZA O TIPO DE USUÁRIO NO PROVIDER UserProvider
      Provider.of<UserProvider>(context, listen: false)
          .atualizaTipoUsuario(doc.get('tipo'));

      // ATUALIZA O NOME DO USUÁRIO NO PROVIDER UserProvider
      Provider.of<UserProvider>(context, listen: false)
          .atualizaNomeUsuario(doc.get('nome_razaosocial'));
    });

    // SELECIONA AS FAMÍLIAS DOS PRODUTOS
    Query<Map<String, dynamic>> acaoSocial =
        FirebaseFirestore.instance.collection('acao_social');
    //.where('usuario', isEqualTo: usuario);

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        title: const Text(
          "+ Ação Social",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
        stream: acaoSocial.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Text('');
          }
          return Column(
            children: [
              const Text(
                'Escolha uma Ação Social',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 15, 80, 140),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: snapshot.data!.docs.map((acao) {
                    return Card(
                      color: const Color.fromARGB(255, 245, 245, 245),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      acao['nome'],
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                        '${acao['data_acao']} - ${acao['hora_acao']}'),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('acao_social')
                                .doc(acao.id)
                                .collection('atividade')
                                .orderBy('nome')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot>
                                    snapshotAtividade) {
                              if (!snapshotAtividade.hasData ||
                                  snapshotAtividade.data!.docs.isEmpty) {
                                return const SizedBox();
                              }
                              if (snapshotAtividade.connectionState ==
                                  ConnectionState.waiting) {
                                carregando();
                              } else {
                                return ListView(
                                  shrinkWrap: true,
                                  //padding: const EdgeInsets.all(8),
                                  children: snapshotAtividade.data!.docs
                                      .map((atividade) {
                                    return Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.black,
                                                  width: 0.2))),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  atividade['nome'],
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 15, 80, 140),
                                                  ),
                                                ),
                                                Text(
                                                    '${atividade['data_atividade']} - ${atividade['hora_atividade']}'),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons
                                                .keyboard_arrow_right_outlined),
                                            onPressed: () {
                                              // ATUALIZA O CÓDIGO DA AÇÃO SOCIAL NO PROVIDER AcaoSocialProvider
                                              Provider.of<AcaoSocialProvider>(
                                                      context,
                                                      listen: false)
                                                  .atualizaIdAcaoSocial(
                                                      acao.id);

                                              // ATUALIZA O NOME DA AÇÃO SOCIAL NO PROVIDER AcaoSocialProvider
                                              Provider.of<AcaoSocialProvider>(
                                                      context,
                                                      listen: false)
                                                  .atualizaNomeAcaoSocial(
                                                      acao['nome']);

                                              // ATUALIZAQ O CÓDIGO DA ATIVIDADE NO PROVIDER AtividadeProvider
                                              Provider.of<AtividadeProvider>(
                                                      context,
                                                      listen: false)
                                                  .atualizaIdAtividade(
                                                      atividade.id);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const InscricaoScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ----------------------------------------------------
  // ANIMAÇÃO DE CARREGAMENTO
  // ----------------------------------------------------
  carregando() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }
}
