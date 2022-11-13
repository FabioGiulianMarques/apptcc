import 'package:ajudasocial22/models/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_screen.dart';
import '../services/auth_service.dart';
import '../widgets/drawer.dart';
import '../helpers/definicoes.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  // CARREGA O USUÁRIO (E-MAIL)
  final usuario = FirebaseAuth.instance.currentUser!.email.toString();

  bool isLoading = true;

  // CONFIGURA OS CONTROLES DA TELA
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController tipoController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController quemSomosController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // VERIFICA O TIPO DE USUÁRIO
    final tipoUsuario =
        Provider.of<UserProvider>(context, listen: false).tipoUsuario;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        title: const Text(
          'Dados Cadastrais',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Builder(builder: (context) {
        // SE ESTIVER CARREGANDO A PÁGINA, BUSCA OS DADOS
        if (isLoading) {
          isLoading = false;
          buscar();
        }

        return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Card(
                color: const Color.fromARGB(172, 255, 255, 255),
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        tipoUsuario,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextFormField(
                        initialValue: usuario,
                        enabled: false,
                        decoration: const InputDecoration(labelText: 'Usuário'),
                        autocorrect: false,
                      ),
                      TextFormField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                            labelText: 'Nome/Razão Social*'),
                        autocorrect: false,
                        validator: (String? conteudo) {
                          if (conteudo!.isEmpty) {
                            return 'Nome/Razão Social é obrigatório.';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                            visible: tipoUsuario == 'Voluntário' ? false : true,
                            child: TextFormField(
                              controller: cpfController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'CPF/CNPJ*'),
                              autocorrect: false,
                              validator: (String? conteudo) {
                                if (conteudo!.isEmpty) {
                                  return 'CPF/CNPJ é obrigatório.';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Visibility(
                            visible: tipoUsuario == 'Voluntário' ? false : true,
                            child: TextFormField(
                              controller: enderecoController,
                              decoration:
                                  const InputDecoration(labelText: 'Endereço'),
                              autocorrect: false,
                              validator: (String? conteudo) {
                                if (conteudo!.isEmpty) {
                                  return 'Endereço é obrigatório.';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Visibility(
                            visible: tipoUsuario == 'Voluntário' ? false : true,
                            child: TextFormField(
                              controller: telefoneController,
                              inputFormatters: [maskTelefoneFixo],
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Telefone*'),
                              autocorrect: false,
                              validator: (String? conteudo) {
                                if (conteudo!.isEmpty) {
                                  return 'Telefone é obrigatório.';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Visibility(
                            visible: tipoUsuario == 'Voluntário' ? true : false,
                            child: TextFormField(
                              controller: whatsappController,
                              inputFormatters: [maskTelefoneCel],
                              decoration:
                                  const InputDecoration(labelText: 'WhatsApp'),
                              autocorrect: false,
                            ),
                          ),
                          Visibility(
                            visible: tipoUsuario == 'Voluntário' ? false : true,
                            child: TextFormField(
                              controller: facebookController,
                              decoration:
                                  const InputDecoration(labelText: 'Facebook'),
                              autocorrect: false,
                            ),
                          ),
                          Visibility(
                            visible: tipoUsuario == 'Voluntário' ? false : true,
                            child: TextFormField(
                              controller: instagramController,
                              decoration:
                                  const InputDecoration(labelText: 'Instagram'),
                              autocorrect: false,
                            ),
                          ),
                          Visibility(
                            visible: tipoUsuario == 'Voluntário' ? false : true,
                            child: TextFormField(
                              controller: quemSomosController,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                  labelText: 'Quem Somos'),
                              autocorrect: false,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //--------------------------------------------------
                            // BOTÃO VOLTAR
                            //--------------------------------------------------
                            TextButton.icon(
                              icon: const Icon(Icons.home_outlined,
                                  color: Colors.white),
                              //child: (loading) ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
                              label: const Text("Voltar"),

                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(12.0),
                                backgroundColor: Colors.amber.shade600,
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomeScreen(),
                                    ));
                              },
                            ),
                            const SizedBox(width: 20),
                            //--------------------------------------------------
                            // BOTÃO SALVAR
                            //--------------------------------------------------
                            TextButton.icon(
                              icon: const Icon(Icons.task_alt,
                                  color: Colors.white),
                              label: const Text("Salvar"),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(12.0),
                                backgroundColor: Colors.green,
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  salvar();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomeScreen(),
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
              ),
            ));
      }),
    );
  }

  Future salvar() async {
    try {
      FirebaseFirestore.instance.collection('usuarios').doc(usuario).update({
        //'tipo': tipoUsuario == 0 ? 'Voluntário' : 'Entidade',
        'nome_razaosocial': nomeController.text,
        'cpf_cnpj': cpfController.text,
        'endereco': enderecoController.text,
        'telefone': telefoneController.text,
        'whatsapp': whatsappController.text,
        'facebook': facebookController.text,
        'instagram': instagramController.text,
        'quem_somos': quemSomosController.text,
      });

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

  Future buscar() async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario)
          .get()
          .then((doc) {
        tipoController.text = doc.get('tipo');
        nomeController.text = doc.get('nome_razaosocial');
        cpfController.text = doc.get('cpf_cnpj');
        enderecoController.text = doc.get('endereco');
        telefoneController.text = doc.get('telefone');
        whatsappController.text = doc.get('whatsapp');
        facebookController.text = doc.get('facebook');
        instagramController.text = doc.get('instagram');
        quemSomosController.text = doc.get('quem_somos');
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
}
