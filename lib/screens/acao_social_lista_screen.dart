import 'package:ajudasocial22/models/acao_social_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';
import 'acao_social_screen.dart';

class AcaoSocialListaScreen extends StatefulWidget {
  const AcaoSocialListaScreen({super.key});

  @override
  State<AcaoSocialListaScreen> createState() => _AcaoSocialListaScreenState();
}

class _AcaoSocialListaScreenState extends State<AcaoSocialListaScreen> {
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
          'Ações Sociais',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // LIMPA O CÓDIGO DA AÇÃO SOCIAL NO PROVIDER AcaoSocialProvider
              Provider.of<AcaoSocialProvider>(context, listen: false)
                  .atualizaIdAcaoSocial('');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AcaoSocialScreen(),
                ),
              );
            },
          )
        ],
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
                child: TextButton(
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(right: 10)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              acao['nome'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text('${acao['data_acao']} - ${acao['hora_acao']}'),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  onPressed: () {
                    // ATUALIZA O CÓDIGO DA AÇÃO SOCIAL NO PROVIDER AcaoSocialProvider
                    Provider.of<AcaoSocialProvider>(context, listen: false)
                        .atualizaIdAcaoSocial(acao.id);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AcaoSocialScreen(),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
