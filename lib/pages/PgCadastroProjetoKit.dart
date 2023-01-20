import 'package:flutter/material.dart';
import 'package:flutter_application_1/ProjectData.dart';
import 'package:flutter_application_1/pages/PgCadastroProjeto.dart';
import '../PartView.dart';

// final formCadProjPg2Key = GlobalKey<FormState>();
List<Inverter> inverterList = [];
List<Widget> inverterWidgetList = [];
List<Inverter?> selectedInverters = [];
List<Module> moduleList = [];
List<Module?> selectedModules = [];
List<Widget> moduleWidgetList = [];
List<Estrutura> estruturaList = [];
late Estrutura selectedStructure;

Future retrieveInverters() async {
  if (inverterList.isEmpty) {
    try {
      return inverterList = await project.getInverters();
    } catch (error) {
      print(error); //Change this to a dialog
    }
  }
}

Future retrieveModules() async {
  if (moduleList.isEmpty) {
    try {
      moduleList = await project.getModules();
    } catch (error) {
      print(error);
    }
    return moduleList;
  }
}

Future retrieveEstrutura() async {
  if (estruturaList.isEmpty) {
    return estruturaList = await project.getStructure();
  } else {
    return estruturaList;
  }
}

class InverterAutocomplete extends StatelessWidget {
  int inverterNumber;
  InverterAutocomplete({super.key, required this.inverterNumber});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: <Widget>[
      Transform.translate(
        offset: Offset(0, 8),
        child: Text(
          'Selecione o inversor ${inverterNumber + 1}',
          textScaleFactor: 1.1,
        ),
      ),
      Autocomplete<Inverter>(
        displayStringForOption: (Inverter option) {
          return option.toString();
        },
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable.empty();
          }
          return inverterList.where((Inverter element) {
            return element
                .toString()
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Material(
            child: Container(
              // height: 300,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: InverterView(
                        mainText: options.elementAt(index).toString(),
                        secondaryText: options.elementAt(index).fabricante,
                        powerText: options.elementAt(index).potencia,
                        voltageText: options.elementAt(index).tensao),
                    onTap: () {
                      onSelected(options.elementAt(index));
                    },
                  );
                },
              ),
            ),
          );
        },
        onSelected: (option) {
          selectedInverters[inverterNumber] = option;
        },
      ),
      SizedBox(
        height: 60,
      )
    ]);
  }
}

class ModuleAutocomplete extends StatelessWidget {
  int moduleNumber;
  ModuleAutocomplete({super.key, required this.moduleNumber});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: <Widget>[
      Transform.translate(
        offset: Offset(0, 8),
        child: Text(
          'Selecione o módulo ${moduleNumber + 1}',
          textScaleFactor: 1.1,
        ),
      ),
      Autocomplete<Module>(
        displayStringForOption: (Module option) {
          return option.toString();
        },
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable.empty();
          }
          return moduleList.where((Module element) {
            return element
                .toString()
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Material(
            child: Container(
              // height: 300,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: ModuleView(
                      mainText: options.elementAt(index).toString(),
                      secondaryText: options.elementAt(index).fabricante,
                      powerText: options.elementAt(index).potencia,
                    ),
                    onTap: () {
                      onSelected(options.elementAt(index));
                    },
                  );
                },
              ),
            ),
          );
        },
        onSelected: (option) {
          selectedModules[moduleNumber] = option;
        },
      ),
      const SizedBox(
        height: 60,
      )
    ]);
  }
}

class PgCadastroProjetoKit extends StatefulWidget {
  int numInverters, numModules;
  PgCadastroProjetoKit(
      {super.key, required this.numInverters, required this.numModules});

  @override
  State<PgCadastroProjetoKit> createState() => _PgCadastroProjetoKitState();
}

class _PgCadastroProjetoKitState extends State<PgCadastroProjetoKit> {
  @override
  void initState() {
    retrieveInverters();
    retrieveModules();
    retrieveEstrutura();
    selectedInverters = List.filled(10, null);
    selectedModules = List.filled(10, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    inverterWidgetList = List.generate(widget.numInverters, (index) {
      return Row(
        children: [
          Expanded(
              flex: 4,
              child: InverterAutocomplete(
                inverterNumber: index,
              )),
          SizedBox(
            width: 20,
          ),
          Expanded(
              flex: 1,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Qtd'),
              ))
        ],
      );
    });
    moduleWidgetList = List.generate(
      widget.numModules,
      (index) {
        return Row(
          children: [
            Expanded(flex: 4, child: ModuleAutocomplete(moduleNumber: index)),
            SizedBox(width: 20),
            Expanded(
                flex: 1,
                child: TextFormField(
                    decoration: InputDecoration(labelText: 'Qtd'))),
          ],
        );
      },
    );
    return Center(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: formKeys[ProjectPages.kit.index],
              // autovalidateMode: AutovalidateMode.always,
              child: ListView(
                  children: inverterWidgetList +
                      moduleWidgetList +
                      [
                         const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          future: retrieveEstrutura(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Tipo de Estrutura'),
                                  items: estruturaList.map((e) {
                                    return DropdownMenuItem(
                                        value: e, child: Text(e.tipoEstrutura));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStructure = value!;
                                    });
                                  });
                            } else {
                              return LinearProgressIndicator();
                            }
                          },
                        )
                      ]),
            )));
  }
}
