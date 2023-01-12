import 'package:flutter/material.dart';

final _formCadProjPg3Key = GlobalKey<FormState>();

class PgCadastroProjetoPage3 extends StatefulWidget {
  const PgCadastroProjetoPage3({super.key});

  @override
  State<PgCadastroProjetoPage3> createState() => _PgCadastroProjetoPage3State();
}

class _PgCadastroProjetoPage3State extends State<PgCadastroProjetoPage3> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                key: _formCadProjPg3Key,
                // autovalidateMode: AutovalidateMode.always,
                child: ListView(children: [
                  const Text(
                    'Selecione o Cliente:',
                    textScaleFactor: 1.1,
                  ),
                  Wrap(runSpacing: 30, children: <Widget>[])
                ]))));
  }
}
