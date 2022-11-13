import 'package:ajudasocial22/models/acao_social_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/atividade_provider.dart';
import '../widgets/drawer.dart';
import 'atividade_screen.dart';
import 'voluntarios_screen.dart';

class AtividadeListaScreen extends StatefulWidget {
  const AtividadeListaScreen({super.key});

  @override
  State<AtividadeListaScreen> createState() => _AtividadeListaScreenState();
}

class _AtividadeListaScreenState extends State<AtividadeListaScreen> {
  @override
  Widget build(BuildContext context) {
    // SE O USUÁRIO NÃO ESTÁ LOGADO, DIRECIONA PARA A TELA DE LOGIN
    String? usuario = FirebaseAuth.instance.currentUser?.email;

    // SELECIONA AS FAMÍLIAS DOS PRODUTOS
    Query<Map<String, dynamic>> acaoSocial = FirebaseFirestore.instance
        .collection('acao_social')
        .where('usuario', isEqualTo: usuario);

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        title: const Text(
          'Atividades',
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

          return ListView(
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  acao['nome'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                    '${acao['data_acao']} - ${acao['hora_acao']}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: IconButton(
                              icon: const Icon(Icons.add_outlined,
                                  color: Colors.white),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(10.0),
                                backgroundColor: Colors.green,
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () {
                                // ATUALIZA O CÓDIGO DA AÇÃO SOCIAL NO PROVIDER AcaoSocialProvider
                                Provider.of<AcaoSocialProvider>(context,
                                        listen: false)
                                    .atualizaIdAcaoSocial(acao.id);

                                // LIMPA O CÓDIGO DA ATIVIDADE NO PROVIDER AtividadeProvider
                                Provider.of<AtividadeProvider>(context,
                                        listen: false)
                                    .atualizaIdAtividade('');

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AtividadeScreen(),
                                    ));
                              },
                            ),
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
                          AsyncSnapshot<QuerySnapshot> snapshotAtividade) {
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
                            children:
                                snapshotAtividade.data!.docs.map((atividade) {
                              return Container(
                                //padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.black, width: 0.2))),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined),
                                      onPressed: () {
                                        // ATUALIZA O CÓDIGO DA AÇÃO SOCIAL NO PROVIDER AcaoSocialProvider
                                        Provider.of<AcaoSocialProvider>(context,
                                                listen: false)
                                            .atualizaIdAcaoSocial(acao.id);

                                        // ATUALIZAQ O CÓDIGO DA ATIVIDADE NO PROVIDER AtividadeProvider
                                        Provider.of<AtividadeProvider>(context,
                                                listen: false)
                                            .atualizaIdAtividade(atividade.id);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const AtividadeScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.list_outlined),
                                      onPressed: () {
                                        // ATUALIZA O CÓDIGO DA AÇÃO SOCIAL NO PROVIDER AcaoSocialProvider
                                        Provider.of<AcaoSocialProvider>(context,
                                                listen: false)
                                            .atualizaIdAcaoSocial(acao.id);

                                        // ATUALIZAQ O CÓDIGO DA ATIVIDADE NO PROVIDER AtividadeProvider
                                        Provider.of<AtividadeProvider>(context,
                                                listen: false)
                                            .atualizaIdAtividade(atividade.id);

                                        // ATUALIZAQ O NOME DA ATIVIDADE NO PROVIDER AtividadeProvider
                                        Provider.of<AtividadeProvider>(context,
                                                listen: false)
                                            .atualizaNomeAtividade(
                                                atividade['nome']);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const VoluntariosListaScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    Column(
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
                                    )
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
