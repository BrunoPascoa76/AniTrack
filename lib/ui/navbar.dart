import 'package:anitrack/ui/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Navbar extends StatefulWidget{
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex=0;
  final _controller=PageController();
  late ValueNotifier<GraphQLClient> client;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final HttpLink httpLink = HttpLink('https://graphql.anilist.co');
    
    final AuthLink authLink = AuthLink(
      getToken: () async {
        final secureStorage=const FlutterSecureStorage();
        final token=await secureStorage.read(key: "anilist_token");
        return "Bearer $token";
      }
    );

    final link=authLink.concat(httpLink);
    client = ValueNotifier(
      GraphQLClient(
        link: link,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: Scaffold(
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
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: "Settings"
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
          children: const [
            Text("page 1"),
            Text("page 2"),
            SettingsPage()
          ],
        )
      ),
    );
  }
}