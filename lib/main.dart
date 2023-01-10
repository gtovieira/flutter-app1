import 'package:flutter/material.dart';
import './pages/PgTabelas.dart';
import './pages/PgVisitaTecnica.dart';
import './pages/PgEnvioDocs.dart';
import './pages/PgEstoque.dart';
import './pages/PgConsultaProjeto.dart';
import './pages/PgConsultaCliente.dart';
import './pages/PgProposta.dart';
import './pages/PgCadastroProjeto.dart';
import './pages/PgMainButtons.dart';
import './pages/PgCadastroCliente.dart';
import 'package:json_theme/json_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';

import 'package:flutter/services.dart'; // For rootBundle
import 'dart:convert'; // For jsonDecode

//TOdo
//Implement buttons in the main page


void main(List<String> args) async {
  

  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MainApp(theme: theme));
}

class MainApp extends StatelessWidget {
  final ThemeData theme;

  const MainApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      // home: const PgMainButtons(),
      initialRoute: '/',
      routes: {
        '/': (context) => const PgMainButtons(),
        '/proposta': (context) => const PgProposta(),
        '/cadastro-cliente': (context) => const PgCadastroCliente(),
        '/cadastro-projeto':(context) => const PgCadastroProjeto(),
        '/consulta-cliente':(context) => const PgConsultaCliente(),
        '/consulta-projeto':(context) => const PgConsultaProjeto(),
        '/visita-tecnica':(context) => const PgVisitaTecnica(),
        '/estoque':(context) => const PgEstoque(),
        '/envio-documentos':(context) => const PgEnvioDocs(),
        '/tabelas':(context) => const PgTabelas(),
      },
    );
  }
}