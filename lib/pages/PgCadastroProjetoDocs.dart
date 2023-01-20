import 'package:flutter/material.dart';
import './PgCadastroProjeto.dart';

// final formCadProjPg5Key = GlobalKey<FormState>();

class PgCadastroProjetoDocs extends StatefulWidget {
  const PgCadastroProjetoDocs({super.key});

  @override
  State<PgCadastroProjetoDocs> createState() => _PgCadastroProjetoDocsState();
}

class _PgCadastroProjetoDocsState extends State<PgCadastroProjetoDocs> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                key: formKeys[ProjectPages.docs.index],
                // autovalidateMode: AutovalidateMode.always,
                child: ListView(children: [
                  const Text(
                    'Deseja anexar os documentos ou enviá-los diretamente ao cliente?:',
                    textScaleFactor: 1.1,
                  ),
                  Wrap(runSpacing: 30, children: <Widget>[])
                ]))));
  }
}
