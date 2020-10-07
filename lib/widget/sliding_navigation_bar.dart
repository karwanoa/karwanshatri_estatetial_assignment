import 'package:flutter/material.dart';

import 'custom_nav_button.dart';

class SlidingNavigationBar extends StatefulWidget {
  final Function(int) tappedIndex;
  final int scrolledToPageIndex;
  SlidingNavigationBar({
    this.tappedIndex,
    this.scrolledToPageIndex,
  });
  @override
  _SlidingNavigationBarState createState() => _SlidingNavigationBarState();
}

class _SlidingNavigationBarState extends State<SlidingNavigationBar> {
  //Selected index of button, default is 0. there are 5 buttons from index 0 to 4
  int indexSelected = 0;
  //widthOfBlackContainer is used to calculate value of black container
  double widthOfBlackContainer;
  //how far the black container should be from left side of the given size of NavBar widget
  double paddingFromLeftBlackContainer;
  //width of the screen in double
  double screenWidth;
  //boolean to determine if middle button is tapped
  bool middleButtonTapped = false;
  List<GlobalKey> _listOfKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];
  @override
  void initState() {
    super.initState();
    setBlackContainerSizeAndPadding(indexSelected);
  }

  @override
  void didUpdateWidget(covariant SlidingNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    //making sure that the Selected NavBar button is reflected to what page is displayed
    setBlackContainerSizeAndPadding(indexSelected);
  }

  setBlackContainerSizeAndPadding(indexSelected) async {
    indexSelected = widget.scrolledToPageIndex;
    calculateNewSelected(widget.scrolledToPageIndex);

    await Future.delayed(Duration.zero);

    final buttonRenderBox = _listOfKeys[indexSelected]
        .currentContext
        .findRenderObject() as RenderBox;
    final position = buttonRenderBox.localToGlobal(Offset.zero);
    setState(() {
      paddingFromLeftBlackContainer = position.dx - 5;
      widthOfBlackContainer = indexSelected == 2
          ? _listOfKeys[indexSelected].currentContext.size.width
          : _listOfKeys[indexSelected].currentContext.size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing screenwidth with values from MediaQuery to the width of the screen
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      color: Colors.white,
      height: 55,
      child: Container(
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: [
            //Positionning the balck container to the correct index of the tapped button
            AnimatedPositioned(
              // if paddingFromLeftBlackContainer is null, there we assume that we are in initial state
              //and current index is 0
              //screen with - 10 because we do not want the black container to reach sides of nighbour buttons
              left: paddingFromLeftBlackContainer,
              //each button is 2 flexs in value except the add button which is one
              // that is why we have intialized black contaienr to be the width of the screen minus padding divided by 9(9 flex)
              // width: ((screenWidth - 10) / 9) * (indexSelected == 2 ? 1 : 2),
              width: widthOfBlackContainer,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black,
                ),
              ),
              // to make the sliding black container move faster decrease duration value and vice versa
              duration: Duration(milliseconds: 300),
            ),
            Row(
              children: [
                // creating a custom button
                CustomNavButton(
                  widgetKey: _listOfKeys[0],
                  // whether this button is selected or not, we pass a boolean to the widget to draw correct parameters
                  isSelected: indexSelected == 0 ? true : false,
                  //a funtion which is triggered by a gesture detector
                  function: () {
                    //callig this funtion makes sure the page displayed is changed with tapping each button
                    widget.tappedIndex(0);
                    //internally to the navbar updating the selected button to the one tapped
                    calculateNewSelected(0);
                  },
                  //title of each button
                  text: 'Home',
                  //icon date for each button
                  iconData: Icons.home,
                ),
                CustomNavButton(
                  widgetKey: _listOfKeys[1],
                  isSelected: indexSelected == 1 ? true : false,
                  function: () {
                    widget.tappedIndex(1);
                    calculateNewSelected(1);
                  },
                  text: 'Store',
                  iconData: Icons.store,
                ),
                CustomNavButton(
                  widgetKey: _listOfKeys[2],
                  isSelected: indexSelected == 2 ? true : false,
                  function: () async {
                    middleButtonTapped = true;
                    widget.tappedIndex(2);
                    await calculateNewSelected(2);
                    setBlackContainerSizeAndPadding(2);
                  },
                  //the only button which has no text is add button
                  text: '',
                  iconData: Icons.add,
                ),
                CustomNavButton(
                  widgetKey: _listOfKeys[3],
                  isSelected: indexSelected == 3 ? true : false,
                  function: () {
                    widget.tappedIndex(3);
                    calculateNewSelected(3);
                  },
                  text: 'Explore',
                  iconData: Icons.explore,
                ),
                CustomNavButton(
                  widgetKey: _listOfKeys[4],
                  isSelected: indexSelected == 4 ? true : false,
                  function: () {
                    widget.tappedIndex(4);
                    calculateNewSelected(4);
                  },
                  text: 'Profile',
                  iconData: Icons.person,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  calculateNewSelected(int indexOfTappedIcon) async {
    indexSelected = indexOfTappedIcon;
  }
}
