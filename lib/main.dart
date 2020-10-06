import 'package:assignment/widget/sliding_navigation_bar.dart';
import 'package:flutter/material.dart';

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
      bottomNavigationBar: SlidingNavigationBar(
        tappedIndex: (int index) {
          //Checking current button tapped from NavBar
          //if current button index tapped is 2, then the add button is tapped and we show the BottomSheet
          if (index == 2)
            showModalBottomSheetMethod();
          //if current button is not the add button, index 2, then we navigate to the tapped page
          else {
            //making sure that the BottomSheet is closed
            Navigator.popUntil(context, ModalRoute.withName('/'));
            //if tapped button index is 3 or 4, we need to decrease there value because we have only 4 pages
            if (index == 3 || index == 4) {
              index--;
            }
            //updating the ui and navigating to the page corresponding to the index tapped
            setState(() {
              _pageController.animateToPage(index,
                  curve: Curves.linear, duration: Duration(milliseconds: 100));
              _currentPageIndex = index;
            });
          }
        },
        //passing current page index to our NavBar so we can update selected button
        //based on the sliding gesture used to change current page displayed
        scrolledToPageIndex: _currentPageIndex,
      ),
      body: buildBodyOfMyHomePage(context),
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
        setState(() => _currentPageIndex = index);
      },
      children: [
        Container(
          color: Colors.blueGrey,
        ),
        Container(
          color: Colors.red,
        ),
        Container(
          color: Colors.yellow,
        ),
        Container(
          color: Colors.indigo,
        ),
      ],
    );
  }

  showModalBottomSheetMethod() {
    //Showing BottomSheet when add button tapped on the NavBar
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
    );
  }
}
