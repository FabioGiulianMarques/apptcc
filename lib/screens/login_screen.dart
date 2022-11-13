import 'package:ajudasocial22/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/validators.dart';
import '../services/auth_service.dart';
import 'reset_senha_screen.dart';
import 'registrar_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool loading = false;

  logar() async {
    setState(() => loading = true);

    try {
      await context
          .read<AuthService>()
          .logar(emailController.text, passController.text);

      // ignore: use_build_context_synchronously
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

  @override
  Widget build(BuildContext context) {
    setState(() {
      emailController.text = "ajudasocial22@gmail.com";
      passController.text = "asocial@2022";
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'lib/images/logo.png',
                fit: BoxFit.fitHeight,
                height: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                color: const Color.fromARGB(188, 255, 255, 255),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                    key: formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: emailController,
                          // enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'E-mail'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: (email) {
                            if (!emailValid(email!)) {
                              return "E-mail inválido.";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: passController,
                          // enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'Senha'),
                          autocorrect: false,
                          obscureText: true,
                          validator: (pass) {
                            if (pass!.isEmpty || pass.length < 6) {
                              return "Senha inválida.";
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 19, 90, 148),
                            ),
                            child: const Text("Esqueci a senha."),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ResetSenha(),
                                  ));
                            },
                          ),
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
                              logar();
                            }
                          },
                          child: const Text("Entrar"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(12.0),
                            backgroundColor:
                                const Color.fromARGB(255, 3, 95, 170),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ));
                          },
                          child: const Text("Inscreva-se"),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
