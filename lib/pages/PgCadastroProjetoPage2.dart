import 'package:flutter/material.dart';
import 'package:flutter_application_1/ProjectData.dart';
import 'package:flutter_application_1/pages/PgCadastroProjeto.dart';
import '../PartView.dart';

final _formCadProjPg2Key = GlobalKey<FormState>();
List<Inverter> inverterList = [];
List<Inverter> selectedInverters = [];
List<Module> moduleList = [];
List<Module> selectedModules = [];

Future retrieveInverters() async {
  return inverterList = await project.getInverters();
}

Future retrieveModules() async {
  return moduleList = await project.getModules();
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
    print(widget.numInverters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                key: _formCadProjPg2Key,
                // autovalidateMode: AutovalidateMode.always,
                child: ListView(children: [
                  Wrap(runSpacing: 1, children: <Widget>[
                    const Text(
                      'Selecione o inversor',
                      textScaleFactor: 1.1,
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
                                      mainText:
                                          options.elementAt(index).toString(),
                                      secondaryText:
                                          options.elementAt(index).fabricante,
                                      powerText:
                                          options.elementAt(index).potencia,
                                      voltageText:
                                          options.elementAt(index).tensao),
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
                        print(option.modelo);
                      },
                    )
                  ]),
                  const SizedBox(
                    height: 50,
                  ),
                  Wrap(runSpacing: 1, children: <Widget>[
                    const Text(
                      'Selecione o tipo de módulo',
                      textScaleFactor: 1.1,
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
                                    mainText:
                                        options.elementAt(index).toString(),secondaryText: options.elementAt(index).fabricante,
                                    powerText:
                                        options.elementAt(index).potencia,
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
                        print(option.modelo);
                      },
                    )
                  ])
                ]))));
  }
}
