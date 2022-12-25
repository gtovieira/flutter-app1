import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import './regex.dart';

// import 'package:flutter_application_1/ex.dart';

class PgCadastroCliente extends StatefulWidget {
  const PgCadastroCliente({Key? key}) : super(key: key);

  @override
  State<PgCadastroCliente> createState() => _PgCadastroClienteState();
}

class _PgCadastroClienteState extends State<PgCadastroCliente> {
  TextEditingController cepController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void fetchCep(String cep) {
    // fetch
  }

  var cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var dobMask = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var cepMask = MaskTextInputFormatter(
      mask: '##.###-###',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 2, child: Text('Gauss Energia')),
            IconButton(onPressed: () {}, icon: Icon(Icons.backspace)),
            IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                  ;
                },
                icon: Icon(Icons.save))
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: ListView(children: [
              Wrap(
                runSpacing: 20,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nome Completo'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Código do Projeto'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'CPF'),
                    inputFormatters: [cpfMask],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (!RegexCodes.cpf.hasMatch(value)) {
                        return 'Digite um CPF válido';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Data de Nascimento'),
                    inputFormatters: [dobMask],
                  ),
                  Focus(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'CEP'),
                      inputFormatters: [cepMask],
                      controller: cepController,
                    ),
                    onFocusChange: (value) {
                      // if (!value) {fetchCep()}
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Logradouro'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Número'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Bairro'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Cidade'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'UF'),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
