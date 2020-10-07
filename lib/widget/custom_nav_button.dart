import 'package:flutter/material.dart';

//This widget is used to build every button on the custon NavBar
class CustomNavButton extends StatelessWidget {
  final Function function;
  final String text;
  final IconData iconData;
  final bool isSelected;
  final GlobalKey widgetKey;

  const CustomNavButton({
    Key key,
    @required this.function,
    @required this.text,
    @required this.iconData,
    @required this.isSelected,
    @required this.widgetKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? buildGestureDetector()
        : Expanded(child: buildGestureDetector());
  }

  GestureDetector buildGestureDetector() {
    return GestureDetector(
      key: widgetKey,
      onTap: function,
      child: Container(
        padding: isSelected
            ? EdgeInsets.symmetric(horizontal: 10)
            : EdgeInsets.symmetric(horizontal: 0),
        color: isSelected ? null : Colors.transparent,
        // using a row to build each button which consists of an icon and/or a text
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: isSelected ? Colors.white : Colors.black,
              size: 18,
            ),
            isSelected
                ? Container(
                    width: 2,
                  )
                : Container(),
            isSelected
                ? Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
