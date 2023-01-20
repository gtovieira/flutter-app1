import 'package:flutter/material.dart';
import '../Masks.dart';
import './PgCadastroProjeto.dart';

const List<Widget> _enviaCreditosList = [Text('Sim'), Text('Não')];
final List<bool> _enviaCreditosSelected = [false, true];

TextEditingController cpfCnpjController = TextEditingController();
// final formCadProjPg3Key = GlobalKey<FormState>();

class InputContas extends StatelessWidget {
  int widgetNumContas;
  InputContas({super.key, required this.widgetNumContas});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 40,
      children: List.generate(widgetNumContas, (index) {
        return Wrap(runSpacing: 10, children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Conta Contrato $index'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'CPF/CNPJ'),
            inputFormatters: [Masks.contaMasks[index]],
            controller: cpfCnpjController,
            onChanged: (value) {
              if (value.length > 14) {
                Masks.contaMasks[index].updateMask(
                  mask: '##.###.###/####-##',
                  filter: {'#': RegExp(r'[0-9]')},
                );
              } else {
                Masks.contaMasks[index].updateMask(
                  mask: '###.###.###-###',
                  filter: {'#': RegExp(r'[0-9]')},
                );
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Porcentagem'),
          )
        ]);
      }),
    );
  }
}



class PgCadastroProjetoContas extends StatefulWidget {
  int numContas;
  PgCadastroProjetoContas({super.key, required this.numContas});

  @override
  State<PgCadastroProjetoContas> createState() => _PgCadastroProjetoContasState();
}

class _PgCadastroProjetoContasState extends State<PgCadastroProjetoContas> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                key: formKeys[ProjectPages.contas.index],
                // autovalidateMode: AutovalidateMode.always,
                child: ListView(children: [
                  Wrap(runSpacing: 30, children: <Widget>[
                    Text('Há contas para receber créditos?'),
                    Center(
                      child: ToggleButtons(
                        isSelected: _enviaCreditosSelected,
                        onPressed: (index) {
                          setState(() {
                            for (int i = 0;
                                i < _enviaCreditosSelected.length;
                                i++) {
                              _enviaCreditosSelected[i] = i == index;
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
                        children: _enviaCreditosList,
                      ),
                    ),
                    _enviaCreditosSelected[0]
                        ? InputContas(widgetNumContas: widget.numContas)
                        : SizedBox.shrink()
                  ])
                ]))));
  }
}
