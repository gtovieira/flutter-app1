import 'package:flutter/material.dart';
import 'package:flutter_application_1/ProjectData.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage1.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage2.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage3.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage4.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage5.dart';

ProjectData project = ProjectData();

class PgCadastroProjeto extends StatefulWidget {
  const PgCadastroProjeto({super.key});

  @override
  State<PgCadastroProjeto> createState() => _PgCadastroProjetoState();
}

class _PgCadastroProjetoState extends State<PgCadastroProjeto> {
  int _selectedPage = 0;
  late int _numInverters = 1;
  late int _numModules = 1;
  @override
  void initState() {
    super.initState();
  }

  static final List<Widget> _pagesList = <Widget>[
    PgCadastroProjetoPage1(),
    PgCadastroProjetoPage2(
      numInverters: 1,
      numModules: 1,
    ),
    PgCadastroProjetoPage3(),
    PgCadastroProjetoPage4(),
    PgCadastroProjetoPage5()
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
                    // _formCadProjKey.currentState!.reset();
                  },
                  icon: const Icon(Icons.backspace)),
              IconButton(
                  onPressed: () {
                    //   if (_formCadProjKey.currentState!.validate()) {
                    //     _formCadProjKey.currentState!.save();
                    //     // project.sendData();
                    //     Navigator.pushNamed(context, '/');
                    //   }
                    //   ;
                  },
                  icon: const Icon(Icons.save))
            ],
          ),
        ),
        body: _pagesList[_selectedPage],
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: _selectedPage == 1
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
                          _pagesList[1] = PgCadastroProjetoPage2(
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
                          _pagesList[1] = PgCadastroProjetoPage2(
                            numInverters: _numInverters,
                            numModules: _numModules,
                          );
                        });
                      },
                    )
                  ])
            : SizedBox.shrink(),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone), label: 'Dados'),
            BottomNavigationBarItem(icon: Icon(Icons.roofing), label: 'Kit'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), label: 'Contas'),
            BottomNavigationBarItem(icon: Icon(Icons.paid), label: 'Pagamento'),
            BottomNavigationBarItem(
                icon: Icon(Icons.description), label: 'Docs')
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
          unselectedFontSize: 12,
          selectedLabelStyle: TextStyle(
            overflow: TextOverflow.visible,
          ),
          unselectedLabelStyle: TextStyle(overflow: TextOverflow.visible),
        ));
  }
}
