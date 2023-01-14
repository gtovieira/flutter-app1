import 'package:flutter/material.dart';
import 'package:flutter_application_1/ProjectData.dart';
import 'package:flutter_application_1/pages/PgCadastroProjeto.dart';
import '../PartView.dart';

final _formCadProjPg2Key = GlobalKey<FormState>();
List<Inverter> inverterList = [];
List<Widget> inverterWidgetList = [];
List<Inverter> selectedInverters = [];
List<Module> moduleList = [];
List<Module> selectedModules = [];
List<Widget> moduleWidgetList = [];
List<Estrutura> estruturaList = [];
late Estrutura selectedStructure;

Future retrieveInverters() async {
  if (inverterList.isEmpty) {
    return inverterList = await project.getInverters();
  }
}

Future retrieveModules() async {
  if (moduleList.isEmpty) {
    return moduleList = await project.getModules();
  }
}

Future retrieveEstrutura() async {
  if (estruturaList.isEmpty) {
    return estruturaList = await project.getStructure();
  } else {
    return estruturaList;
  }
  ;
}

class InverterAutocomplete extends StatelessWidget {
  int inverterNumber;
  InverterAutocomplete({super.key, required this.inverterNumber});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: <Widget>[
      Transform.translate(offset: Offset(0,8), child: Text(
        'Selecione o inversor ${inverterNumber + 1}',
        textScaleFactor: 1.1,
      ),),
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
      Transform.translate(offset: Offset(0, 8), child: Text(
        'Selecione o módulo ${moduleNumber + 1}',
        textScaleFactor: 1.1,
      ),),
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
      SizedBox(
        height: 60,
      )
    ]);
  }
}

class PgCadastroProjetoPage2 extends StatefulWidget {
  int? numInverters, numModules;
  PgCadastroProjetoPage2({super.key, this.numInverters, this.numModules});

  @override
  State<PgCadastroProjetoPage2> createState() => _PgCadastroProjetoPage2State();
}

class _PgCadastroProjetoPage2State extends State<PgCadastroProjetoPage2> {
  @override
  void initState() {
    retrieveInverters();
    retrieveModules();
    retrieveEstrutura();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    inverterWidgetList = List.generate(widget.numInverters ??= 1,
        (index) => InverterAutocomplete(inverterNumber: index));
    moduleWidgetList = List.generate(
      widget.numModules ??= 1,
      (index) => ModuleAutocomplete(moduleNumber: index),
    );
    return Center(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: _formCadProjPg2Key,
              // autovalidateMode: AutovalidateMode.always,
              child: ListView(
                  children: inverterWidgetList +
                      moduleWidgetList +
                      [SizedBox(height: 20,),
                        FutureBuilder(
                          future: retrieveEstrutura(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Tipo de Estrutura'),
                                  items: estruturaList.map((e) {
                                    print(e);
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
