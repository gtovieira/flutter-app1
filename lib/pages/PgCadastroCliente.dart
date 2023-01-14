import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ApiCalls.dart';
import 'package:flutter_application_1/ClientData.dart';
import '../regex.dart';
import './PgClienteCadastrado.dart';
import '../Masks.dart';

Future<void> _invalidCepDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('CEP Inexistente'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('O CEP Digitado não existe.'),
              Text('Favor Digitar um CEP válido para carregar o endereço'),
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

Future<void> _invalidCnpjDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('CNPJ Inexistente'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('O CNPJ Digitado não existe.'),
              Text('Favor Digitar um CNPJ válido para carregar os dados'),
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
  final FocusNode _cepFocus = FocusNode();
  bool _cnpjValidated = false;

  ApiCalls api = ApiCalls(selectedBase: base.invertexto);

  void fetchCep() async {
    try {
      await api.fetchCep(cepToSearch: int.parse(Masks.cepMask.getUnmaskedText()));
      setState(() {
        logController.text = api.logradouro;
        bairroController.text = api.bairro;
        cityController.text = api.cidade;
        ufController.text = api.uf;
      });
    } catch (error) {
      // _cepFocus.requestFocus();
      _invalidCepDialog(context);
    }
  }

  void fetchCnpj() async {
    try {
      await api.fetchCnpj(cnpjToSearch: int.parse(Masks.cnpjMask.getUnmaskedText()));
      setState(() {
        razaoController.text = api.razaoSocial;
        cepController.text = Masks.cepMask.maskText(api.cep);
        logController.text = '${api.tipoLogradouro} ${api.logradouro}';
        numeroController.text = api.numero;
        bairroController.text = api.bairro;
        cityController.text = api.cidade;
        ufController.text = api.uf;
      });
    } catch (error) {
      _invalidCnpjDialog(context);
    }
  }

  void _clearAddressFields() {
    logController.clear();
    bairroController.clear();
    cityController.clear();
    ufController.clear();
  }



  static const List<Widget> pfPjList = [
    Text('Pessoa Física'),
    Text('Pessoa Jurídica')
  ];
  final List<bool> _pfPjSelected = [true, false];

  ClientData clientData = ClientData();

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
                    clientData.sendData();
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
                      constraints: BoxConstraints(minHeight: 50, minWidth: 165),
                      children: pfPjList,
                    ),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Código do Projeto'),
                    onSaved: (newValue) => clientData.codProjeto = newValue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      } else {
                        return null;
                      }
                    },
                  ),
                  _pfPjSelected[1]
                      ? Focus(
                          onFocusChange: ((value) {
                            if (!value && _cnpjValidated) {
                              fetchCnpj();
                            }
                          }),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'CNPJ'),
                            onSaved: (newValue) => clientData.cnpj = newValue,
                            inputFormatters: [Masks.cnpjMask],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                _cnpjValidated = false;
                                return 'Campo Obrigatório';
                              } else if (!RegexCodes.cnpj.hasMatch(value)) {
                                _cnpjValidated = false;
                                return 'CNPJ inválido';
                              } else {
                                _cnpjValidated = true;
                                return null;
                              }
                            },
                          ),
                        )
                      : SizedBox.shrink(),
                  _pfPjSelected[1]
                      ? TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Razão Social'),
                          controller: razaoController,
                          onSaved: (newValue) =>
                              clientData.razaoSocial = newValue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo Obrigatório';
                            } else {
                              return null;
                            }
                          },
                        )
                      : SizedBox.shrink(),
                  TextFormField(
                    onSaved: (newValue) => clientData.nome = newValue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      } else {
                        return null;
                      }
                    },
                    decoration: _pfPjSelected[1]
                        ? const InputDecoration(
                            labelText: 'Nome do Responsável')
                        : const InputDecoration(labelText: 'Nome Completo'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'CPF'),
                    onSaved: (newValue) => clientData.cpf = newValue,
                    inputFormatters: [Masks.cpfMask],
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
                    inputFormatters: [Masks.dobMask],
                    onSaved: (newValue) => clientData.dob = newValue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      } else if (RegexCodes.dob.hasMatch(value)) {
                        return null;
                      } else {
                        return 'Digite uma data válida';
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    onSaved: (newValue) => clientData.email = newValue,
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
                    decoration:
                        const InputDecoration(labelText: 'Telefone Celular'),
                    onSaved: (newValue) => clientData.phone = newValue,
                    inputFormatters: [Masks.phoneMask],
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
                      decoration: const InputDecoration(labelText: 'CEP'),
                      onSaved: (newValue) => clientData.cep = newValue,
                      inputFormatters: [Masks.cepMask],
                      focusNode: _cepFocus,
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
                    onSaved: (newValue) => clientData.logradouro = newValue,
                    controller: logController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      } else {
                        return null;
                      }
                    }),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Número'),
                    onSaved: (newValue) => clientData.numero = newValue,
                    controller: numeroController,
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
                    onSaved: (newValue) => clientData.bairro = newValue,
                    controller: bairroController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Cidade'),
                    onSaved: (newValue) => clientData.cidade = newValue,
                    controller: cityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'UF'),
                    onSaved: (newValue) => clientData.uf = newValue,
                    controller: ufController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      } else {
                        return null;
                      }
                    },
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
