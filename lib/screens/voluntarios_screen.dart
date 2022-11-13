import 'package:ajudasocial22/models/acao_social_provider.dart';
import 'package:ajudasocial22/screens/atividade_lista_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/atividade_provider.dart';
import '../widgets/drawer.dart';

class VoluntariosListaScreen extends StatefulWidget {
  const VoluntariosListaScreen({super.key});

  @override
  State<VoluntariosListaScreen> createState() => _VoluntariosListaScreenState();
}

class _VoluntariosListaScreenState extends State<VoluntariosListaScreen> {
  @override
  Widget build(BuildContext context) {
    // SE O USUÁRIO NÃO ESTÁ LOGADO, DIRECIONA PARA A TELA DE LOGIN
    String? usuario = FirebaseAuth.instance.currentUser?.email;

    // BUSCA O ID DA ACAO SOCIAL NO PROVIDER AcaoSocialProvider
    final idAcaoSocial =
        Provider.of<AcaoSocialProvider>(context, listen: false).idAcaoSocial;

    // BUSCA O ID DA ACAO SOCIAL NO PROVIDER AcaoSocialProvider
    final nomeAcaoSocial =
        Provider.of<AcaoSocialProvider>(context, listen: false).nomeAcaoSocial;

    // BUSCA O ID DA ATIVIDADE NO PROVIDER AtividadeProvider
    final idAtividade =
        Provider.of<AtividadeProvider>(context, listen: false).idAtividade;

    // BUSCA O NOME DA ATIVIDADE NO PROVIDER AtividadeProvider
    final nomeAtividade =
        Provider.of<AtividadeProvider>(context, listen: false).nome;

    // SELECIONA AS FAMÍLIAS DOS PRODUTOS
    Query<Map<String, dynamic>> voluntarios = FirebaseFirestore.instance
        .collection('acao_social')
        .doc(idAcaoSocial)
        .collection('atividade')
        .doc(idAtividade)
        .collection('inscritos');

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        title: const Text(
          'Voluntários',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
        stream: voluntarios.snapshots(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Ação Social: $nomeAcaoSocial',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Atividade: $nomeAtividade',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: snapshot.data!.docs.map((snapVoluntarios) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapVoluntarios['nome'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              snapVoluntarios.id,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('usuarios')
                                  .doc(snapVoluntarios.id)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapUsuario) {
                                if (!snapUsuario.hasData) {
                                  return const SizedBox();
                                }
                                if (snapUsuario.connectionState ==
                                    ConnectionState.waiting) {
                                  carregando();
                                } else {
                                  return Text(
                                      snapUsuario.data!.get('whatsapp'));
                                }
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              //--------------------------------------------------
              // BOTÃO VOLTAR
              //--------------------------------------------------
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextButton.icon(
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
                              builder: (_) => const AtividadeListaScreen(),
                            ));
                      },
                    ),
                  ),
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
