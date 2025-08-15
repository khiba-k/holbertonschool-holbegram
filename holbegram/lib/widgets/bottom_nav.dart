import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import '../screens/pages/feed.dart';
import '../screens/pages/add_image.dart';
import '../screens/pages/profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController?.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          Feed(),
          Scaffold(body: Center(child: Text('Search - Coming Soon'))),
          AddImage(),
          Scaffold(body: Center(child: Text('Favorite - Coming Soon'))),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: onPageChanged,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Feed',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.search),
            title: Text(
              'Search',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add),
            title: Text(
              'Add',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.favorite),
            title: Text(
              'Favorite',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
