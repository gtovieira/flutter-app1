import 'package:flutter/material.dart';
import './PgCadastroProjeto.dart';
import '../ApiCalls.dart';
import '../Masks.dart';
import '../regex.dart';
import '../ProjectData.dart';

// final formCadProjPg5Key = GlobalKey<FormState>();

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

Future<void> _invalidMapsDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Link incorreto'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Wrap(
                runSpacing: 20,
                children: [
                  Image.asset('assets/images/maps.png'),
                  Text(
                      'Para compartilhar o link da forma correta, clique no botão compartilhar no aplicativo do google maps, e então cole-o no campo.'),
                  Text('O link deve estar no formato:'),
                  Text(
                    'goo.gl/maps/6fobrfp7h4nPqRux9',
                    style: TextStyle(fontFamily: 'Courier'),
                  )
                ],
              )
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

class PgCadastroProjetoEnd extends StatefulWidget {
  const PgCadastroProjetoEnd({super.key});

  @override
  State<PgCadastroProjetoEnd> createState() => _PgCadastroProjetoEndState();
}

class _PgCadastroProjetoEndState extends State<PgCadastroProjetoEnd> {
  TextEditingController cepController = TextEditingController();
  TextEditingController logController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController ufController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController tipoLogController = TextEditingController();

  bool _cepValidated = false;
  final FocusNode _cepFocus = FocusNode();
  bool _mapsLinkValidated = false;

  ApiCalls api = ApiCalls(selectedBase: base.invertexto);

  void fetchCep() async {
    try {
      await api.fetchCep(
          cepToSearch: int.parse(Masks.cepMask.getUnmaskedText()));
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

  void _clearAddressFields() {
    logController.clear();
    bairroController.clear();
    cityController.clear();
    ufController.clear();
  }
  final List<bool> _sameAddress = [true, false];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
                key: formKeys[ProjectPages.end.index],
                // autovalidateMode: AutovalidateMode.always,
                child: ListView(children: [
                  Wrap(runSpacing: 30, children: [Text('O endereço do projeto é o mesmo endereço do cadastro do cliente?'),Center(
                    child: ToggleButtons(children: [Text('Mesmo Endereço'), Text('Novo Endereço')], isSelected: _sameAddress,onPressed: (index) {
                            setState(() {
                              for (int i = 0; i < _sameAddress.length; i++) {
                                _sameAddress[i] = i == index;
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          fillColor: Color.fromARGB(255, 91, 161, 87),
                          color: Color.fromARGB(255, 91, 161, 87),
                          selectedColor: Colors.white,
                          textStyle: TextStyle(fontSize: 15),
                          constraints:
                              BoxConstraints(minHeight: 50, minWidth: 165),),
                  ),
                    Focus(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'CEP'),
                        onSaved: (newValue) => project.cep = newValue,
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
                      onSaved: (newValue) => project.logradouro = newValue,
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
                      onSaved: (newValue) => project.numero = newValue,
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
                      onSaved: (newValue) => project.bairro = newValue,
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
                      onSaved: (newValue) => project.cidade = newValue,
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
                      onSaved: (newValue) => project.uf = newValue,
                      controller: ufController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo Obrigatório';
                        } else {
                          return null;
                        }
                      },
                    ),
                    Focus(
                      onFocusChange: (value) {
                        if (!value && !_mapsLinkValidated) {
                          _invalidMapsDialog(context);
                        }
                      },
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Link do Google Maps'),
                        onSaved: (newValue) => project.mapsLink = newValue,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            _mapsLinkValidated = false;
                            return 'Campo Obrigatório';
                          } else if (RegexCodes.mapsLink.hasMatch(value)) {
                            _mapsLinkValidated = true;
                            return null;
                          } else {
                            _mapsLinkValidated = false;
                            return 'Link no formato inválido';
                          }
                        },
                      ),
                    ),
                  ])
                ]))));
  }
}
