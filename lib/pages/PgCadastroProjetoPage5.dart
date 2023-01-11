import 'package:flutter/material.dart';

final _formCadProjPg5Key = GlobalKey<FormState>();

class PgCadastroProjetoPage5 extends StatefulWidget {
  const PgCadastroProjetoPage5({super.key});

  @override
  State<PgCadastroProjetoPage5> createState() => _PgCadastroProjetoPage5State();
}

class _PgCadastroProjetoPage5State extends State<PgCadastroProjetoPage5> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                key: _formCadProjPg5Key,
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
