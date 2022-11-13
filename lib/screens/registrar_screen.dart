// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/validators.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController passConfController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController tipoUsuarioController = TextEditingController();

  int? tipoUsuario = 1;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ));
              },
            );
          },
        ),
        title: const Text('Inscrição'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
            color: const Color.fromARGB(237, 245, 245, 245),
            //margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: <Widget>[
                  Row(
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: tipoUsuario,
                        onChanged: (value) {
                          setState(() {
                            tipoUsuario = value;
                            tipoUsuarioController.text = 'Voluntário';
                          });
                        },
                      ),
                      const Text("Voluntário"),
                      Radio<int>(
                        value: 2,
                        groupValue: tipoUsuario,
                        onChanged: (value) {
                          setState(() {
                            tipoUsuario = value;
                            tipoUsuarioController.text = 'Entidade';
                          });
                        },
                      ),
                      const Text("Entidade"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                        hintText: 'Seu Nome/Razão Social aqui.'),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    validator: (String? nomeController) {
                      if (nomeController!.isEmpty) {
                        return 'Campo obrigatório.';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration:
                        const InputDecoration(hintText: 'Seu e-mail aqui.'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (String? email) {
                      if (email!.isEmpty) {
                        return 'Campo obrigatório.';
                      } else if (!emailValid(email)) {
                        return 'E-mail inválido.';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passController,
                    decoration: const InputDecoration(hintText: 'Senha'),
                    autocorrect: false,
                    obscureText: true,
                    validator: (pass) {
                      if (pass!.isEmpty) {
                        return "Senha obrigatória.";
                      } else if (pass.length < 6) {
                        return "Senha deve ser maior que 6 caracteres.";
                      } else if (passController.text !=
                          passConfController.text) {
                        return "Senhas não coferem.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passConfController,
                    decoration:
                        const InputDecoration(hintText: 'Repita a Senha'),
                    autocorrect: false,
                    obscureText: true,
                    validator: (pass) {
                      if (pass!.isEmpty) {
                        return "Senha obrigatória.";
                      } else if (pass.length < 6) {
                        return "Senha deve ser maior que 6 caracteres.";
                      } else if (passController.text !=
                          passConfController.text) {
                        return "Senhas não coferem.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        registrar();
                      }
                    },
                    child: const Text("Cadastrar"),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  registrar() async {
    setState(() => loading = true);

    try {
      await context
          .read<AuthService>()
          .registrar(emailController.text, passController.text);

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(emailController.text)
          .set({
        'tipo': tipoUsuarioController.text == '' ? 'Voluntário' : 'Entidade',
        'nome_razaosocial': nomeController.text,
        'cpf_cnpj': '',
        'endereco': '',
        'telefone': '',
        'whatsapp': '',
        'facebook': '',
        'instagram': '',
        'quem_somos': '',
      });

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ));
    } on AuthException catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.mensagem),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
