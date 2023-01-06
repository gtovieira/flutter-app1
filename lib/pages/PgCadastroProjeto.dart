import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

const List<String> vendors = [
  'Gabriel Vieira',
  'João Mateus',
  'Dimitri Sampaio',
  'Joaquim Neto',
  'Janicleia Carvalho',
  'Ângelo Dourado',
  'Lucas Rizzaro',
  'Aílton Júnior',
  'Wildiney Lunas',
  'Edilan Barreto',
  'Vinicius Marambaia',
  'Fernanda Martins',
  'Raniel Garcia',
  'Ricardo Sanches'
];

class PgCadastroProjeto extends StatefulWidget {
  const PgCadastroProjeto({super.key});

  @override
  State<PgCadastroProjeto> createState() => _PgCadastroProjetoState();
}

class _PgCadastroProjetoState extends State<PgCadastroProjeto> {
  late String selectedVendor;
  final _formCadProjKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Cadastro de Projeto')),
        body: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                    key: _formCadProjKey,
                    // autovalidateMode: AutovalidateMode.always,
                    child: ListView(children: [
                      Wrap(runSpacing: 30, children: <Widget>[
                        DropdownButtonFormField(
                            decoration: InputDecoration(labelText: 'Vendedor'),
                            items: vendors
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedVendor = value!;
                              });
                            })
                      ])
                    ])))));
  }
}
