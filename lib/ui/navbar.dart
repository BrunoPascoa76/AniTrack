import 'package:anitrack/main.dart';
import 'package:anitrack/service/anilist_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Navbar extends StatefulWidget{
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex=0;
  final _controller=PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) { 
          setState(() {
            _currentIndex=index;
          });
          _controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut
          );
        },
        selectedIndex: _currentIndex,
        destinations: const<Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.video_library),
            icon: Icon(Icons.video_library_outlined),
            label: "Watchlist"
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: "Calendar"
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (index) { 
          setState(() {
            _currentIndex=index;
          });
        },
        children: [
          Text("page 1"),
          Text("page 2")
        ],
      )
    );
  }
}