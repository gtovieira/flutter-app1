import 'package:flutter/material.dart';
import 'package:flutter_application_1/ClientData.dart';
import 'package:flutter_application_1/ProjectData.dart';
import '../ApiCalls.dart';
import '../Masks.dart';
import '../regex.dart';
import 'PgCadastroProjeto.dart';

// final formCadProjPg1Key = GlobalKey<FormState>();

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
late List<String> clientList = [];

Future<List<String>> retrieveClients() async {
  if (clientList.isEmpty) {
    try {
      return clientList = await clients.getData();
    } catch (error) {
      print(error);
    }
  }
  return clientList;
}

class PgCadastroProjetoDados extends StatefulWidget {
  const PgCadastroProjetoDados({super.key});

  @override
  State<PgCadastroProjetoDados> createState() => _PgCadastroProjetoDadosState();
}

class _PgCadastroProjetoDadosState extends State<PgCadastroProjetoDados> {
  late String selectedVendor;

  TextEditingController cnpjController = TextEditingController();
  TextEditingController razaoController = TextEditingController();
  TextEditingController fantasiaController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool _cnpjValidated = false;

  ApiCalls api = ApiCalls(selectedBase: base.invertexto);

  void fetchCnpj() async {
    try {
      await api.fetchCnpj(
          cnpjToSearch: int.parse(Masks.cnpjMask.getUnmaskedText()));
      setState(() {
        razaoController.text = api.razaoSocial;
        // cepController.text = Masks.cepMask.maskText(api.cep);
        // logController.text = '${api.tipoLogradouro} ${api.logradouro}';
        // numeroController.text = api.numero;
        // bairroController.text = api.bairro;
        // cityController.text = api.cidade;
        // ufController.text = api.uf;
      });
    } catch (error) {
      _invalidCnpjDialog(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    retrieveClients();
    super.initState();
  }

  final List<bool> _mesmoTitular = [true, false];
  static const List<Widget> _mesmoTitularList = [
    Text('Mesmo titular'),
    Text('Titular Diferente')
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
                key: formKeys[ProjectPages.dados.index],
                autovalidateMode: AutovalidateMode.always,
                child: ListView(children: [
                  const Text(
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
                            BoxConstraints(minHeight: 50, minWidth: 165),
                        children: _contaContratoList,
                      ),
                    ),
                    _contaContrato[0]
                        ? TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Conta Contrato*'),
                            onSaved: (newValue) =>
                                project.contaContrato = newValue,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo Obrigatório';
                              } else {
                                return null;
                              }
                            },
                          )
                        : SizedBox.shrink(),
                    Wrap(runSpacing: 30, children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Código do Projeto*'),
                        onSaved: (newValue) => project.codProjeto = newValue,
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
                    ]),
                    Center(
                      child: ToggleButtons(
                        isSelected: _mesmoTitular,
                        onPressed: (index) {
                          setState(() {
                            for (int i = 0; i < _mesmoTitular.length; i++) {
                              _mesmoTitular[i] = i == index;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        fillColor: Color.fromARGB(255, 91, 161, 87),
                        color: Color.fromARGB(255, 91, 161, 87),
                        selectedColor: Colors.white,
                        textStyle: TextStyle(fontSize: 18),
                        constraints:
                            BoxConstraints(minHeight: 50, minWidth: 165),
                        children: _mesmoTitularList,
                      ),
                    ),
                    _mesmoTitular[1]
                        ? Column(children: [
                            ToggleButtons(
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
                              textStyle: TextStyle(fontSize: 18),
                              constraints: const BoxConstraints(
                                  minHeight: 50, minWidth: 165),
                              children: pfPjList,
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
                          ])
                        : SizedBox.shrink(),
                  ])
                ]))));
  }
}
