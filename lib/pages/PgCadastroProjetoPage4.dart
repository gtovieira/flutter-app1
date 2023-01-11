import 'package:flutter/material.dart';

final _formCadProjPg4Key = GlobalKey<FormState>();

class PgCadastroProjetoPage4 extends StatefulWidget {
  const PgCadastroProjetoPage4({super.key});

  @override
  State<PgCadastroProjetoPage4> createState() => _PgCadastroProjetoPage4State();
}

class _PgCadastroProjetoPage4State extends State<PgCadastroProjetoPage4> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                key: _formCadProjPg4Key,
                // autovalidateMode: AutovalidateMode.always,
                child: ListView(children: [
                  Text(
                    'Selecione o Cliente:',
                    textScaleFactor: 1.1,
                  ),
                  Wrap(runSpacing: 30, children: <Widget>[])
                ]))));
  }
}
