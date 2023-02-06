import 'package:flutter/material.dart';
import 'package:flutter_application_1/ProjectData.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoEnd.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoDados.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoKit.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoContas.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPag.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoDocs.dart';
import '../Client.dart';
// import './PgCadastroProjetoPage1.dart';


enum ProjectPages { dados, end, kit, contas, pag, docs }

List<GlobalKey<FormState>> formKeys = [];

class PgCadastroProjeto extends StatefulWidget {
  const PgCadastroProjeto({super.key});

  @override
  State<PgCadastroProjeto> createState() => _PgCadastroProjetoState();
}

class _PgCadastroProjetoState extends State<PgCadastroProjeto> {
  int _selectedPage = 0;
  int _numInverters = 1;
  int _numModules = 1;
  int _numContas = 1;
  @override
  void initState() {
    formKeys = List.generate(6, (index) => GlobalKey<FormState>());
    super.initState();
  }

  static final List<Widget> _pagesList = <Widget>[
    const PgCadastroProjetoDados(),
    const PgCadastroProjetoEnd(),
    PgCadastroProjetoKit(
      numInverters: 1,
      numModules: 1,
    ),
    PgCadastroProjetoContas(
      numContas: 1,
    ),
    const PgCadastroProjetoPag(),
    const PgCadastroProjetoDocs(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(flex: 2, child: Text('Adicionar Projeto')),
              IconButton(
                  onPressed: () {
                    formKeys[_selectedPage].currentState!.reset();
                    setState(() {
                      // projectFormValidated[_selectedPage] = false;
                    });
                  },
                  icon: const Icon(Icons.backspace)),
              IconButton(
                onPressed: () {
                  if (formKeys[_selectedPage].currentState!.validate()) {
                    formKeys[_selectedPage].currentState!.save();
                    setState(() {
                      // projectFormValidated[_selectedPage] = true;
                    });
                    // project.sendData();
                    // Navigator.pushNamed(context, '/');
                  }
                },
                icon: projectFormValidated[_selectedPage]
                    ? const Icon(Icons.check_circle)
                    : const Icon(Icons.save),
                color: projectFormValidated[_selectedPage]
                    ? Colors.green[900]
                    : Colors.red[900],
              )
            ],
          ),
        ),
        body: _pagesList[_selectedPage],
        floatingActionButtonLocation: _selectedPage == ProjectPages.kit.index
            ? ExpandableFab.location
            : null,
        floatingActionButton: _selectedPage == ProjectPages.kit.index
            ? ExpandableFab(
                overlayStyle: ExpandableFabOverlayStyle(blur: 5),
                children: [
                    FloatingActionButton.extended(
                      heroTag: 'hero1',
                      label: Text('Adicionar Inversor'),
                      icon: Icon(Icons.bolt),
                      onPressed: () {
                        setState(() {
                          _numInverters++;
                          _pagesList[ProjectPages.kit.index] = PgCadastroProjetoKit(
                            numInverters: _numInverters,
                            numModules: _numModules,
                          );
                        });
                      },
                    ),
                    FloatingActionButton.extended(
                      heroTag: 'hero2',
                      label: Text('Adicionar Módulo'),
                      icon: Icon(Icons.sunny),
                      onPressed: () {
                        setState(() {
                          _numModules++;
                          _pagesList[ProjectPages.kit.index] = PgCadastroProjetoKit(
                            numInverters: _numInverters,
                            numModules: _numModules,
                          );
                        });
                      },
                    )
                  ])
            : _selectedPage == ProjectPages.contas.index
                ? FloatingActionButton(
                    heroTag: 'hero3',
                    child: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _numContas++;
                        _pagesList[ProjectPages.contas.index] = PgCadastroProjetoContas(
                          numContas: _numContas,
                        );
                      });
                    },
                  )
                : SizedBox.shrink(),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone), label: 'Dados'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'End'),
            BottomNavigationBarItem(icon: Icon(Icons.roofing), label: 'Kit'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), label: 'Contas'),
            BottomNavigationBarItem(icon: Icon(Icons.paid), label: 'Pag'),
            BottomNavigationBarItem(
                icon: Icon(Icons.description), label: 'Docs'),
          ],
          currentIndex: _selectedPage,
          onTap: (value) {
            setState(() {
              _selectedPage = value;
            });
          },
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedFontSize: 13,
          iconSize: 25,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(
            overflow: TextOverflow.visible,
          ),
          unselectedLabelStyle: const TextStyle(overflow: TextOverflow.visible),
        ));
  }
}
