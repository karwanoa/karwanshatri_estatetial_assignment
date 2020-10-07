import 'package:assignment/widget/sliding_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'widget/each_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => MyHomePage(),
      },
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // _pageController is used controll the page such animating to a new page
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // _currentPageIndex is used to know the the current index of the page displayed
  int _currentPageIndex = 0;
  //creating scaffold key so BottomSheet can be displayed from a method
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      backgroundColor: Colors.grey,
      bottomNavigationBar: buildSlidingNavigationBar(context),
      body: buildBodyOfMyHomePage(context),
    );
  }

  buildSlidingNavigationBar(BuildContext context) {
    return SlidingNavigationBar(
      tappedIndex: (int index) {
        //Checking current button tapped from NavBar
        //if current button index tapped is 2, then the add button is tapped and we show the BottomSheet
        if (index == 2) {
          showModalBottomSheetMethod();
          setState(() {
            _currentPageIndex = 2;
          });
        }
        //if current button is not the add button, index 2, then we navigate to the tapped page
        else {
          //making sure that the BottomSheet is closed
          Navigator.popUntil(context, ModalRoute.withName('/'));
          //if tapped button index is 3 or 4, we need to decrease there value because we have only 4 pages
          if (index == 3 || index == 4) {
            index--;
          }
          //navigating to the page corresponding to the index tapped
          _pageController.animateToPage(index,
              curve: Curves.linear, duration: Duration(milliseconds: 300));
        }
      },
      //passing current page index to our NavBar so we can update selected button
      //based on the sliding gesture used to change current page displayed
      scrolledToPageIndex: _currentPageIndex,
    );
  }

  buildBodyOfMyHomePage(BuildContext context) {
    //using page view to show four different screens with different colors
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        //making sure that the BottomSheet is closed
        Navigator.popUntil(context, ModalRoute.withName('/'));
        //changing currentPageIndex value on page change from sliding gesture of the PageView
        // and updating ui so the NavBar also shows the correct page displayed
        setState(() {
          if (index < 2) {
            _currentPageIndex = index;
          } else
            _currentPageIndex = index + 1;
        });
      },
      children: [
        EachPage(
          color: Colors.blueGrey,
          text: 'First Page',
          textColor: Colors.white,
        ),
        EachPage(
          color: Colors.red.shade300,
          text: 'Second Page',
          textColor: Colors.black,
        ),
        EachPage(
          color: Colors.yellow.shade300,
          text: 'Third Page',
          textColor: Colors.black,
        ),
        EachPage(
          color: Colors.indigo.shade300,
          text: 'Fourth Page',
          textColor: Colors.white,
        ),
      ],
    );
  }

  showModalBottomSheetMethod() async {
    //Showing BottomSheet when add button tapped on the NavBar
    PersistentBottomSheetController persistentBottomSheetController;
    persistentBottomSheetController =
        scaffoldState.currentState.showBottomSheet(
            (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Open Camera'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo),
                      title: Text('Choose from Gallary'),
                    ),
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Write a Story'),
                    ),
                  ],
                ),
            backgroundColor: Colors.white);
    persistentBottomSheetController.closed.then((v) {
      setState(() {
        _currentPageIndex = _pageController.page.round() < 2
            ? _pageController.page.round()
            : _pageController.page.round() + 1;
      });
    });
  }
}
