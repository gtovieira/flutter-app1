import 'package:flutter/material.dart';
import '../PageButton.dart';
import './PgCadastroCliente.dart';

class PgMainButtons extends StatelessWidget {
  const PgMainButtons({super.key});

  static const List<Map<String, dynamic>> pageList = [
    {'icon': Icons.request_quote, 'title': 'Fazer Proposta', 'page': '/proposta'},
    {'icon': Icons.person_add, 'title': 'Adicionar Cliente', 'page': '/cadastro-cliente'},
    {'icon': Icons.post_add, 'title': 'Adicionar Projeto', 'page': '/cadastro-projeto'}, 
    {'icon': Icons.person_search, 'title': 'Consultar Cliente', 'page': '/consulta-cliente'},
    {'icon': Icons.content_paste_search, 'title': 'Consultar Projeto', 'page': '/consulta-projeto'},
    {'icon': Icons.content_paste, 'title': 'Visita Técnica', 'page': '/visita-tecnica'},
    {'icon': Icons.warehouse, 'title': 'Estoque', 'page': '/estoque'},
    {'icon': Icons.picture_as_pdf, 'title': 'Envio de Documentos', 'page': '/envio-documentos'},
    {'icon': Icons.calculate, 'title': 'Tabelas de cálculo', 'page': '/tabelas'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gauss Energia'),
      ),
      body: Stack(
        children: [
          //[Image.asset('/assets/images/logo.png'),
          Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 30,
                  // mainAxisExtent: 10,
                  mainAxisSpacing: 30),
              children: pageList.map((e) => PageButton(actionName: e['title']!, icon: e['icon'], page: e['page'],)).toList()
            ),
          )
        ],
      ),
    );
  }
}
