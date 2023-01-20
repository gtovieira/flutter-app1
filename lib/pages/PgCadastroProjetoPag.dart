import 'package:flutter/material.dart';
import '../ApiCalls.dart';
import '../Masks.dart';
import '../regex.dart';
import './PgCadastroProjeto.dart';

ApiCalls api = ApiCalls(selectedBase: base.invertexto);

// final formCadProjPg4Key = GlobalKey<FormState>();


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


List<String> _formaPagamento = [
  'À Vista',
  'Parcelado',
  'Financiamento',
  'Outra (especificar)'
];

List<bool> _nfSelected = [true, false];
List<bool> _pfPjSelected = [true, false];

late String _selectedPmt;

class PgCadastroProjetoPag extends StatefulWidget {
  const PgCadastroProjetoPag({super.key});

  @override
  State<PgCadastroProjetoPag> createState() => _PgCadastroProjetoPagState();
}

class _PgCadastroProjetoPagState extends State<PgCadastroProjetoPag> {
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
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                key: formKeys[ProjectPages.pag.index],
                // autovalidateMode: AutovalidateMode.always,
                child: ListView(children: [
                  Wrap(runSpacing: 30, children: <Widget>[
                    DropdownButtonFormField(
                        decoration: const InputDecoration(
                            labelText: 'Forma de Pagamento'),
                        items: _formaPagamento
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPmt = value!;
                          });
                        }),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Detalhes do Pagamento'),
                    ),
                    const Text('A nota será emitida em nome do cliente?'),
                    Center(
                      child: ToggleButtons(
                        children: [Text('Sim'), Text('Não')],
                        isSelected: _nfSelected,
                        onPressed: (index) {
                          setState(() {
                            for (int i = 0; i < _nfSelected.length; i++) {
                              _nfSelected[i] = i == index;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        fillColor: const Color.fromARGB(255, 91, 161, 87),
                        color: const Color.fromARGB(255, 91, 161, 87),
                        selectedColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 18),
                        constraints:
                            const BoxConstraints(minHeight: 50, minWidth: 165),
                      ),
                    ),
                    _nfSelected[1]
                        ? Wrap(runSpacing: 30, children: [
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
                                    minHeight: 50, minWidth: 165),
                                children: const [
                                  Text('Pessoa Física'),
                                  Text('Pessoa Jurídica')
                                ],
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
                                          project.nfCnpj = newValue,
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
                                        project.nfRazaoSocial = newValue,
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
                              onSaved: (newValue) => project.nfNome = newValue,
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
                                      labelText: 'Nome Completo'),
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'CPF'),
                              onSaved: (newValue) => project.nfCpf = newValue,
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
                                onSaved: (newValue) => project.nfCep = newValue,
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
                                  project.nfEndereco = newValue,
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
                              onSaved: (newValue) =>
                                  project.nfNumero = newValue,
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
                              onSaved: (newValue) =>
                                  project.nfBairro = newValue,
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
                              onSaved: (newValue) =>
                                  project.nfCidade = newValue,
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
                              onSaved: (newValue) => project.nfUf = newValue,
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
                  ])
                ]))));
  }
}
