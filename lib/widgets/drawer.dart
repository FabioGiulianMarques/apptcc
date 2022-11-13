import 'package:ajudasocial22/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../models/user_provider.dart';
import '../screens/acao_social_lista_screen.dart';
import '../screens/atividade_lista_screen.dart';
import '../screens/home_screen.dart';
import '../screens/usuarios_screen.dart';
//import 'package:custom_place_m/models/carrinho.dart';
// import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;

  //final tempo = const Duration(hours: 0, minutes: 0, seconds: 1);

  @override
  Widget build(BuildContext context) {
    // VERIFICA O TIPO DE USUÁRIO
    final tipoUsuario =
        Provider.of<UserProvider>(context, listen: false).tipoUsuario;

    return Drawer(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 50.0, 24.0, 24.0),
            child: Column(
              children: [
                Image.asset(
                  'lib/images/logo.png',
                  height: 100,
                ),
                const Text('+ Ajuda Social')
              ],
            ),
          ),
          itemDrawer(context, const Icon(Icons.home), 'Inicio', 'HomeScreen'),
          itemDrawer(
              context,
              const Icon(Icons.fingerprint),
              tipoUsuario == 'Voluntário' ? 'Seus Dados' : 'Cad. Entidade',
              'UsuariosScreen'),
          Visibility(
              visible: tipoUsuario == 'Voluntário' ? false : true,
              child: Column(
                children: [
                  itemDrawer(context, const Icon(Icons.favorite), 'Ação Social',
                      'AcaoSocialListaScreen'),
                  itemDrawer(context, const Icon(Icons.list_outlined),
                      'Atividades', 'AtividadeListaScreen'),
                ],
              )),
          itemDrawer(context, const Icon(Icons.logout), 'Sair', 'LoginScreen'),
        ],
      ),
    );
  }

  itemDrawer(context, Icon icone, String label, String pagina) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 0.2))),
      child: ListTile(
        leading: icone,
        iconColor: Colors.black87,
        title: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        textColor: Colors.black87,
        //subtitle: const Text('Relação de Produtos'),
        //selected: true,
        onTap: () {
          switch (pagina) {
            case "HomeScreen":
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ));
              break;

            case "UsuariosScreen":
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UsuariosScreen(),
                  ));
              break;

            case "AcaoSocialListaScreen":
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AcaoSocialListaScreen(),
                  ));
              break;

            case "AtividadeListaScreen":
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AtividadeListaScreen(),
                  ));
              break;

            case "LoginScreen":
              _auth.signOut();
              usuario = _auth.currentUser;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ));

              break;
            default:
          }
        },
      ),
    );
  }
}
