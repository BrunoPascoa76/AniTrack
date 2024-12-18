import 'package:anitrack/model/user.dart';
import 'package:anitrack/service/fetch_user_service.dart';
import 'package:anitrack/ui/calendar_page.dart';
import 'package:anitrack/ui/settings_page.dart';
import 'package:anitrack/ui/watchlist_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;
  final _controller = PageController();
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

    final AuthLink authLink = AuthLink(getToken: () async {
      const secureStorage = FlutterSecureStorage();
      final token = await secureStorage.read(key: "anilistAccessToken");
      return "Bearer $token";
    });

    final link = authLink.concat(httpLink);
    client = ValueNotifier(
      GraphQLClient(
        link: link,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(
            store:
                HiveStore(Hive.box<Map<dynamic, dynamic>?>("graphql_cache"))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: client,
        child: FetchUserService(
            child: Scaffold(
                bottomNavigationBar: NavigationBar(
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                    context.read<SelectedPageCubit>().selectPage(index);
                  },
                  selectedIndex: _currentIndex,
                  destinations: <Widget>[
                    const NavigationDestination(
                        selectedIcon: Icon(Icons.video_library),
                        icon: Icon(Icons.video_library_outlined),
                        label: "Watchlist"),
                    const NavigationDestination(
                        selectedIcon: Icon(Icons.calendar_month),
                        icon: Icon(Icons.calendar_month_outlined),
                        label: "Calendar"),
                    const NavigationDestination(
                        selectedIcon: Icon(Icons.explore),
                        icon: Icon(Icons.explore_outlined),
                        label: "Explore"),
                    NavigationDestination(
                      icon: generateProfileIcon(),
                      label: "Profile",
                    ),
                    const NavigationDestination(
                        selectedIcon: Icon(Icons.settings),
                        icon: Icon(Icons.settings_outlined),
                        label: "Settings"),
                  ],
                ),
                body: BlocBuilder<SelectedPageCubit, int>(
                    builder: (context, state) {
                  switch (state) {
                    case 0:
                      return const WatchlistGroup();
                    case 1:
                      return const CalendarPage();
                    case 2:
                      return const Center(
                        child: Text("Explore"),
                      );
                    case 3:
                      return const Center(
                        child: Text("Profile"),
                      );
                    case 4:
                      return const SettingsPage();
                    default:
                      return const WatchlistGroup();
                  }
                }))));
  }

  Widget generateProfileIcon() {
    return BlocBuilder<UserBloc, User?>(builder: (context, state) {
      return Image.network(
          state?.avatarMedium ??
              "https://s4.anilist.co/file/anilistcdn/user/avatar/medium/default.png",
          width: 30,
          height: 30);
    });
  }
}

class SelectedPageCubit extends Cubit<int> {
  SelectedPageCubit() : super(0);

  void selectPage(int index) => emit(index);
}
