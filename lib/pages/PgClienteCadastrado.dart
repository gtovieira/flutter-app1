import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:json_theme/json_theme_schemas.dart';

class PgClienteCadastrado extends StatelessWidget {
  const PgClienteCadastrado({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(flex: 2, child: Text('Gauss Energia')),
            ],
          ),
        ),
        body: Center(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  runSpacing: 40,
                  spacing: 100,
                  children: [
                    const Text(
                        'Cliente cadastrado com sucesso. Deseja adicionar um projeto para este cliente?',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(minHeight: 60, minWidth: 300),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/cadastro-projeto');
                          },
                          child: const Text('Adicionar Projeto', style: TextStyle(color: Colors.white),)),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 50, minWidth: 300),
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.popUntil(context, ModalRoute.withName('/'));
                          },
                          child: const Text('Voltar ao menu inicial')),
                    )
                  ],
                ))));
  }
}
