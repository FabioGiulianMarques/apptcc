import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helpers/validators.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ResetSenha extends StatefulWidget {
  const ResetSenha({Key? key}) : super(key: key);

  @override
  State<ResetSenha> createState() => _HomeState();
}

class _HomeState extends State<ResetSenha> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black87,
        title: const Text(
          'Redefinição de Senha',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: const Color.fromARGB(172, 255, 255, 255),
                  //margin: const EdgeInsets.all(10.0),
                  child: Form(
                      key: formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        children: <Widget>[
                          // const SizedBox(height: 20),
                          // Image.asset(
                          //   'lib/images/cadeado.png',
                          //   //fit: BoxFit.fitHeight,
                          //   height: 150,
                          // ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: emailController,
                            // enabled: !userManager.loading,
                            decoration: const InputDecoration(
                                labelText: 'E-mail para recuperação de senha'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            validator: (email) {
                              if (!emailValid(email!)) {
                                return "E-mail inválido.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextButton(
                            //child: (loading) ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(12.0),
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                enviaSenha();
                              }
                            },
                            //child: (loading) ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
                            child: const Text("Solicitar"),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future enviaSenha() async {
    try {
      auth.setLanguageCode('pt_BR');

      auth.sendPasswordResetEmail(email: emailController.text).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('E-mail de recuperação de senha enviado com sucesso.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ));
      }).catchError((erro) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail não encontrado em nossa base de dados.'),
            backgroundColor: Colors.red,
          ),
        );
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
