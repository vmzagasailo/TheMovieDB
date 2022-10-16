import 'package:flutter/material.dart';
import 'package:the_movie_db/ui/navigation/main_navigation.dart';

class MainScreen extends StatefulWidget {
  final ScreenFactory screenFactory;

  const MainScreen({Key? key, required this.screenFactory}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTab = 0;
  void _onSelectTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          widget.screenFactory.makeMovieListScreen(),
          widget.screenFactory.makeSeriesScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
         
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Series',
          ),
        ],
        onTap: _onSelectTab,
      ),
    );
  }
}
