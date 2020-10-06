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
  @override
  void didUpdateWidget(covariant SlidingNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    //making sure that the Selected NavBar button is reflected to what page is displayed
    calculateSelectedIndexFromPageViewGesture();
  }

  @override
  Widget build(BuildContext context) {
    //initializing screenwidth with values from MediaQuery to the width of the screen
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      color: Colors.white,
      height: 50,
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            //Positionning the balck container to the correct index of the tapped button
            AnimatedPositioned(
              // if paddingFromLeftBlackContainer is null, there we assume that we are in initial state
              //and current index is 0
              //screen with - 10 because we do not want the black container to reach sides of nighbour buttons
              left: paddingFromLeftBlackContainer == null
                  ? ((screenWidth - 10) / 9) * indexSelected
                  : paddingFromLeftBlackContainer,
              //each button is 2 flexs in value except the add button which is one
              // that is why we have intialized black contaienr to be the width of the screen minus padding divided by 9(9 flex)
              width: ((screenWidth - 10) / 9) * (indexSelected == 2 ? 1 : 2),
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
                  // whether this button is selected or not, we pass a boolean to the widget to draw correct parameters
                  isSelected: indexSelected == 0 ? true : false,
                  //flex 2, because every button is the same size except the middle one which has flex value on one, which means it has half of the size of other buttons
                  flex: 2,
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
                  isSelected: indexSelected == 1 ? true : false,
                  flex: 2,
                  function: () {
                    widget.tappedIndex(1);
                    calculateNewSelected(1);
                  },
                  text: 'Store',
                  iconData: Icons.store,
                ),
                CustomNavButton(
                  isSelected: indexSelected == 2 ? true : false,
                  flex: 1,
                  function: () {
                    widget.tappedIndex(2);
                    calculateNewSelected(2);
                  },
                  //the only button which has no text is add button
                  text: '',
                  iconData: Icons.add,
                ),
                CustomNavButton(
                  isSelected: indexSelected == 3 ? true : false,
                  flex: 2,
                  function: () {
                    widget.tappedIndex(3);
                    calculateNewSelected(3);
                  },
                  text: 'Explore',
                  iconData: Icons.explore,
                ),
                CustomNavButton(
                  isSelected: indexSelected == 4 ? true : false,
                  flex: 2,
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

  calculateSelectedIndexFromPageViewGesture() async {
    // making sure that the widget tree is build, then we update values
    await Future.delayed(Duration.zero);
    //if page scrolled to has index of 0 or 1, we proceed normally
    if (widget.scrolledToPageIndex == 0 || widget.scrolledToPageIndex == 1) {
      indexSelected = widget.scrolledToPageIndex;
      calculateNewSelected(indexSelected);
      //if page scrolled to has index of 2 or 3, we have to increase thier value by one, becase we have 4 pages with 5 buttons
      //however the middle button does not show any page and it is not connected to any pages
    } else if (widget.scrolledToPageIndex == 2 ||
        widget.scrolledToPageIndex == 3) {
      indexSelected = widget.scrolledToPageIndex + 1;
      calculateNewSelected(indexSelected);
    }
  }

  calculateNewSelected(int indexOfTappedIcon) {
    //updating and moving the black button to correct position of the button tapped
    // multiplier value is used to move the black bar to correct location
    if (indexOfTappedIcon == 0) {
      customSetState(indexOfTapped: indexOfTappedIcon, multiplierValue: 0);
    } else if (indexOfTappedIcon == 1) {
      customSetState(indexOfTapped: indexOfTappedIcon, multiplierValue: 2);
    } else if (indexOfTappedIcon == 2) {
      setState(() {
        paddingFromLeftBlackContainer = ((screenWidth - 10) / 9) * 4;
        //we make sure that widthOfBlackContainer is half when button with index 2 is tapped
        // because button 2 is the middle one
        widthOfBlackContainer =
            ((screenWidth - 10) / 9) * (indexSelected == 2 ? 1 : 2);
        indexSelected = indexOfTappedIcon;
      });
    } else if (indexOfTappedIcon == 3) {
      customSetState(indexOfTapped: indexOfTappedIcon, multiplierValue: 5);
    } else if (indexOfTappedIcon == 4) {
      customSetState(indexOfTapped: indexOfTappedIcon, multiplierValue: 7);
    }
  }

  customSetState({int indexOfTapped, int multiplierValue}) {
    setState(() {
      paddingFromLeftBlackContainer =
          ((screenWidth - 10) / 9) * multiplierValue;
      indexSelected = indexOfTapped;
    });
  }
}
