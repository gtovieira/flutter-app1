import 'package:flutter/material.dart';

class InverterView extends StatelessWidget {
  String mainText, secondaryText;
  double powerText;
  int voltageText;
  InverterView(
      {super.key,
      required this.mainText, required this.secondaryText,
      required this.voltageText,
      required this.powerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
      child: Card(
        color: Color.fromARGB(255, 220, 234, 215),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(children: [Text(
                    mainText,
                    style: TextStyle(fontSize: 18),
                  ),Text(
                    secondaryText,
                    style: TextStyle(fontSize: 11),
                  ),],)
                ),
                Container(
                  decoration: BoxDecoration(
                      color: voltageText == 220 ? Colors.green[300] : Colors.lightBlue[300],
                      // border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  constraints:
                      const BoxConstraints(minHeight: 40, minWidth: 60),
                  alignment: Alignment(0, 0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                      flex: 3,
                      child: Text('$voltageText', textScaleFactor: 1.5),
                    ),
                    const Flexible(
                      flex: 1,
                      child: Text(
                        'V',
                        textScaleFactor: 0.8,
                      ),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 20,
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green[400],
                      // border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  constraints:
                      const BoxConstraints(minHeight: 40, minWidth: 60),
                  alignment: Alignment(0, 0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                      flex: 3,
                      child: Text('$powerText', textScaleFactor: 1.5),
                    ),
                    const Flexible(
                      flex: 1,
                      child: Text(
                        'kW',
                        textScaleFactor: 0.8,
                      ),
                    )
                  ]),
                )
              ],
            )),
      ),
    );
  }
}

class ModuleView extends StatelessWidget {
  String mainText, secondaryText;
  int powerText;
  ModuleView(
      {super.key,
      required this.mainText, required this.secondaryText,
      required this.powerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
      child: Card(
        color: Color.fromARGB(255, 220, 234, 215),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(children: [Text(
                    mainText,
                    style: TextStyle(fontSize: 18),
                  ),Text(
                    secondaryText,
                    style: TextStyle(fontSize: 11),
                  ),],)
                ),
                
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green[400],
                      // border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  constraints:
                      const BoxConstraints(minHeight: 40, minWidth: 60),
                  alignment: Alignment(0, 0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                      flex: 3,
                      child: Text('$powerText', textScaleFactor: 1.5),
                    ),
                    const Flexible(
                      flex: 1,
                      child: Text(
                        'Wp',
                        textScaleFactor: 0.8,
                      ),
                    )
                  ]),
                )
              ],
            )),
      ),
    );
  }
}