import 'package:flutter/material.dart';

//This widget is used to build every button on the custon NavBar
class CustomNavButton extends StatelessWidget {
  final Function function;
  final String text;
  final int flex;
  final IconData iconData;
  final bool isSelected;

  const CustomNavButton({
    Key key,
    @required this.function,
    @required this.text,
    @required this.flex,
    @required this.iconData,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      //using gesture detetction mechanism to make sure we register every button custom button tap
      child: GestureDetector(
        onTap: function,
        child: Container(
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
      ),
    );
  }
}
