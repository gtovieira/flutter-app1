import 'package:flutter/material.dart';

final _formCadProjPg2Key = GlobalKey<FormState>();

class PgCadastroProjetoPage2 extends StatefulWidget {
  const PgCadastroProjetoPage2({super.key});

  @override
  State<PgCadastroProjetoPage2> createState() => _PgCadastroProjetoPage2State();
}

class _PgCadastroProjetoPage2State extends State<PgCadastroProjetoPage2> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                key: _formCadProjPg2Key,
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
