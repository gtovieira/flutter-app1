import 'package:flutter/material.dart';
import 'package:flutter_application_1/ClientData.dart';
import 'package:flutter_application_1/ProjectData.dart';
import '../ApiCalls.dart';
import '../Masks.dart';
import '../regex.dart';
import 'PgCadastroProjeto.dart';

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

ClientData clients = ClientData();
late List<String> clientList;

Future<List<String>> retrieveClients() async {
  return clientList = await clients.getData();
}

final _formCadProjPg1Key = GlobalKey<FormState>();

class PgCadastroProjetoPage1 extends StatefulWidget {
  const PgCadastroProjetoPage1({super.key});

  @override
  State<PgCadastroProjetoPage1> createState() => _PgCadastroProjetoPage1State();
}

class _PgCadastroProjetoPage1State extends State<PgCadastroProjetoPage1> {
  late String selectedVendor;

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

  bool _cepValidated = false;
  final FocusNode _cepFocus = FocusNode();
  bool _cnpjValidated = false;
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

  void fetchCnpj() async {
    try {
      await api.fetchCnpj(
          cnpjToSearch: int.parse(Masks.cnpjMask.getUnmaskedText()));
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

  @override
  void initState() {
    // TODO: implement initState
    retrieveClients();
    super.initState();
  }

  final List<bool> _aproveitaDadosCliente = [true, false];
  static const List<Widget> __aproveitaDadosClienteList = [
    Text('Mesmo titular'),
    Text('Novo Titular')
  ];

  final List<bool> _contaContrato = [true, false];
  static const List<Widget> _contaContratoList = [
    Text('Conta Contrato Existente'),
    Text('Conta Contrato Nova')
  ];

  static const List<Widget> pfPjList = [
    Text('Pessoa Física'),
    Text('Pessoa Jurídica')
  ];
  final List<bool> _pfPjSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                key: _formCadProjPg1Key,
                autovalidateMode: AutovalidateMode.always,
                child: ListView(children: [
                  Text(
                    'Selecione o Cliente:',
                    textScaleFactor: 1.1,
                  ),
                  Wrap(runSpacing: 30, children: <Widget>[
                    Autocomplete<String>(
                      optionsBuilder: ((textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable.empty();
                        }
                        return clientList.where((element) {
                          return element
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      }),
                      onSelected: (option) {
                        print(option);
                      },
                    ),
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
                        }),
                    Center(
                      child: ToggleButtons(
                        isSelected: _contaContrato,
                        onPressed: (index) {
                          setState(() {
                            for (int i = 0; i < _contaContrato.length; i++) {
                              _contaContrato[i] = i == index;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        fillColor: Color.fromARGB(255, 91, 161, 87),
                        color: Color.fromARGB(255, 91, 161, 87),
                        selectedColor: Colors.white,
                        textStyle: TextStyle(fontSize: 13),
                        constraints:
                            BoxConstraints(minHeight: 50, minWidth: 180),
                        children: _contaContratoList,
                      ),
                    ),
                    _contaContrato[0] ? TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Conta Contrato*'),
                      onSaved: (newValue) => project.contaContrato = newValue,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo Obrigatório';
                        } else {
                          return null;
                        }
                      },
                    ) : SizedBox.shrink(),
                    Center(
                      child: ToggleButtons(
                        isSelected: _aproveitaDadosCliente,
                        onPressed: (index) {
                          setState(() {
                            for (int i = 0;
                                i < _aproveitaDadosCliente.length;
                                i++) {
                              _aproveitaDadosCliente[i] = i == index;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        fillColor: Color.fromARGB(255, 91, 161, 87),
                        color: Color.fromARGB(255, 91, 161, 87),
                        selectedColor: Colors.white,
                        textStyle: TextStyle(fontSize: 20),
                        constraints:
                            BoxConstraints(minHeight: 50, minWidth: 180),
                        children: __aproveitaDadosClienteList,
                      ),
                    ),
                    _aproveitaDadosCliente[1]
                        ? Wrap(runSpacing: 30, children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Código do Projeto*'),
                              onSaved: (newValue) =>
                                  project.codProjeto = newValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo Obrigatório';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Nome identificador do projeto'),
                            ),
                            Center(
                              child: ToggleButtons(
                                isSelected: _pfPjSelected,
                                onPressed: (index) {
                                  setState(() {
                                    for (int i = 0;
                                        i < _pfPjSelected.length;
                                        i++) {
                                      _pfPjSelected[i] = i == index;
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                fillColor: Color.fromARGB(255, 91, 161, 87),
                                color: Color.fromARGB(255, 91, 161, 87),
                                selectedColor: Colors.white,
                                textStyle: TextStyle(fontSize: 20),
                                constraints: const BoxConstraints(
                                    minHeight: 50, minWidth: 180),
                                children: pfPjList,
                              ),
                            ),
                            _pfPjSelected[1]
                                ? Focus(
                                    onFocusChange: ((value) {
                                      if (!value && _cnpjValidated) {
                                        fetchCnpj();
                                      }
                                    }),
                                    child: TextFormField(
                                      decoration:
                                          InputDecoration(labelText: 'CNPJ'),
                                      onSaved: (newValue) =>
                                          project.cnpj = newValue,
                                      inputFormatters: [Masks.cnpjMask],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          _cnpjValidated = false;
                                          return 'Campo Obrigatório';
                                        } else if (!RegexCodes.cnpj
                                            .hasMatch(value)) {
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
                                    decoration: InputDecoration(
                                        labelText: 'Razão Social'),
                                    controller: razaoController,
                                    onSaved: (newValue) =>
                                        project.razaoSocial = newValue,
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
                              onSaved: (newValue) => project.nome = newValue,
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
                                  : const InputDecoration(
                                      labelText: 'Nome Completo do Titular'),
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'CPF'),
                              onSaved: (newValue) => project.cpf = newValue,
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
                            Focus(
                              child: TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'CEP'),
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
                              decoration:
                                  InputDecoration(labelText: 'Logradouro'),
                              onSaved: (newValue) =>
                                  project.logradouro = newValue,
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
                          ])
                        : SizedBox.shrink(),
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
