import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ApiCalls.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../regex.dart';
import './PgClienteCadastrado.dart';

Future<void> _invalidCepDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('CEP Inválido'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('O CEP Digitado não existe.'),
              Text('Favor Digitar um CEP válido para carregar o endereço.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class PgCadastroCliente extends StatefulWidget {
  const PgCadastroCliente({Key? key}) : super(key: key);

  @override
  State<PgCadastroCliente> createState() => _PgCadastroClienteState();
}

class _PgCadastroClienteState extends State<PgCadastroCliente> {
  TextEditingController cepController = TextEditingController();
  TextEditingController logController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController ufController = TextEditingController();
  TextEditingController cnpjController = TextEditingController();
  TextEditingController razaoController = TextEditingController();
  TextEditingController fantasiaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController tipoLogController = TextEditingController();

  final _formCadClienteKey = GlobalKey<FormState>();
  bool _cepValidated = false;

  void fetchCep() async {
    Map response;
    print(cepMask.getUnmaskedText());
    ApiCalls.fetchCep(cep: int.parse(cepMask.getUnmaskedText())).then((value) {
      response = jsonDecode(value.body);
      print(response['street']);
      setState(() {
        logController.text = response['street'];
        bairroController.text = response['neighborhood'];
        cityController.text = response['city'];
        ufController.text = response['state'];
      });
    });
  }

  void fetchCnpj() async {
    dynamic response;
    Map body;
    response =
        await ApiCalls.fetchCnpj(cnpj: int.parse(cnpjMask.getUnmaskedText()));
    body = await jsonDecode(response.body);
    setState(() {
      razaoController.text = body['razao_social'];
      fantasiaController.text = body['nome_fantasia'] ??= '';
      // print(body['endereco']['cep'].runtimeType);
      cepController.text = cepMask.maskText(body['endereco']['cep']);
    });
  }

  void _clearAddressFields() {
    logController.clear();
    bairroController.clear();
    cityController.clear();
    ufController.clear();
  }

  var cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var cnpjMask = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
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

  static const List<Widget> pfPjList = [
    Text('Pessoa Física'),
    Text('Pessoa Jurídica')
  ];
  final List<bool> _pfPjSelected = [false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(flex: 2, child: Text('Adicionar Cliente')),
            IconButton(
                onPressed: () {
                  _formCadClienteKey.currentState!.reset();
                },
                icon: const Icon(Icons.backspace)),
            IconButton(
                onPressed: () {
                  if (_formCadClienteKey.currentState!.validate()) {
                    _formCadClienteKey.currentState!.save();
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return PgClienteCadastrado();
                    }));
                  }
                  ;
                },
                icon: const Icon(Icons.save))
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formCadClienteKey,
            autovalidateMode: AutovalidateMode.always,
            child: ListView(children: [
              Wrap(
                runSpacing: 30,
                children: <Widget>[
                  Center(
                    child: ToggleButtons(
                      isSelected: _pfPjSelected,
                      onPressed: (index) {
                        setState(() {
                          for (int i = 0; i < _pfPjSelected.length; i++) {
                            _pfPjSelected[i] = i == index;
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      fillColor: Color.fromARGB(255, 91, 161, 87),
                      color: Color.fromARGB(255, 91, 161, 87),
                      selectedColor: Colors.white,
                      textStyle: TextStyle(fontSize: 20),
                      constraints: BoxConstraints(minHeight: 50, minWidth: 180),
                      children: pfPjList,
                    ),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Código do Projeto'),
                  ),
                  _pfPjSelected[1]
                      ? TextFormField(
                          decoration: InputDecoration(labelText: 'CNPJ'),
                          inputFormatters: [cnpjMask],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo Obrigatório';
                            } else if (!RegexCodes.cnpj.hasMatch(value)) {
                              return 'CNPJ inválido';
                            } else {
                              fetchCnpj();
                              return null;
                            }
                          },
                        )
                      : SizedBox.shrink(),
                  _pfPjSelected[1]
                      ? TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Razão Social'),
                          controller: razaoController,
                        )
                      : SizedBox.shrink(),
                  TextFormField(
                    decoration: _pfPjSelected[1]
                        ? InputDecoration(labelText: 'Nome do Responsável')
                        : InputDecoration(labelText: 'Nome Completo'),
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
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (RegexCodes.email.hasMatch(value)) {
                        return null;
                      } else {
                        return 'Digite um e-mail válido';
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Telefone Celular'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      } else if (RegexCodes.phone.hasMatch(value)) {
                        return null;
                      } else {
                        return 'Digite um número válido';
                      }
                    },
                  ),
                  Focus(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'CEP'),
                      inputFormatters: [cepMask],
                      controller: cepController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _cepValidated = false;
                          _clearAddressFields();
                          return 'Campo Obrigatório';
                        } else if (RegexCodes.cep.hasMatch(value)) {
                          _cepValidated = true;
                          return null;
                        } else {
                          _cepValidated = false;
                          _clearAddressFields();
                          return 'Digite um CEP válido';
                        }
                      },
                    ),
                    onFocusChange: (value) {
                      if (!value && _cepValidated) {
                        fetchCep();
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Logradouro'),
                    controller: logController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Número'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Bairro'),
                    controller: bairroController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Cidade'),
                    controller: cityController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'UF'),
                    controller: ufController,
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
