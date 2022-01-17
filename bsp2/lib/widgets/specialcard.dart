import 'package:flutter/material.dart';

class SpecialCard extends StatelessWidget {
  String title;
  String subtitle = "";
  String value;
  List<Color> colorlist;
  Color boxshadowcolor;
  SpecialCard({
    Key? key,
    @required required this.title,
    @required required this.value,
    @required required this.subtitle,
    @required required this.colorlist,
    @required required this.boxshadowcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 5,
        // color: Colors.white,

        // margin: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colorlist,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: boxshadowcolor,
                blurRadius: 5.0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 3),
                child: FittedBox(
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                // height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 0),
                child: FittedBox(
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 0),
                child: FittedBox(
                  child: Text(
                    value,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
