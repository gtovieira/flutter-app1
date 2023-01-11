import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage1.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage2.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage3.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage4.dart';
import 'package:flutter_application_1/pages/PgCadastroProjetoPage5.dart';

class PgCadastroProjeto extends StatefulWidget {
  const PgCadastroProjeto({super.key});

  @override
  State<PgCadastroProjeto> createState() => _PgCadastroProjetoState();
}

class _PgCadastroProjetoState extends State<PgCadastroProjeto> {
  int _selectedPage = 0;

  static const List<Widget> _pagesList = <Widget>[
    PgCadastroProjetoPage1(),
    PgCadastroProjetoPage2(),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone), label: 'Dados'),
          BottomNavigationBarItem(
              icon: Icon(Icons.roofing), label: 'Kit'),
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
        selectedFontSize: 13,iconSize: 25,
        unselectedFontSize: 12, selectedLabelStyle: TextStyle(overflow: TextOverflow.visible,), unselectedLabelStyle: TextStyle(overflow: TextOverflow.visible),
    ));
  }
}
