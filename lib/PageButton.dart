import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  late String actionName;
  late IconData icon;
  String page;
  PageButton(
      {super.key,
      required this.actionName,
      required this.icon,
      required this.page});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(page);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(colors: [
              Color.fromARGB(60, 56, 180, 73),
              Color.fromARGB(60, 190, 215, 48)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        padding: const EdgeInsets.all(1),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 5, child: Icon(icon, size: 30)),
              Expanded(
                flex: 3,
                child: Text(
                  actionName,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
