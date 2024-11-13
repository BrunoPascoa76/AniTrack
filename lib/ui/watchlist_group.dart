import 'package:anitrack/ui/watchlist.dart';
import 'package:flutter/material.dart';

class WatchlistGroup extends StatelessWidget{
  const WatchlistGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length:3,
      child:Scaffold(
        appBar: AppBar(
          title: const Text("Watchlist"),
          bottom: const TabBar(
            tabs:[
              Tab(
                icon:Icon(Icons.visibility),
                text: "Watching"
              ),
              Tab(
                icon:Icon(Icons.check),
                text:"Completed"
              ),
              Tab(
                icon:Icon(Icons.watch_later),
                text: "Plan to Watch"
              )
            ]
          ),
        ),
        body: const TabBarView(children: [
          Watchlist(status: "CURRENT"),
          Watchlist(status: "COMPLETED"),
          Watchlist(status: "PLANNING")
        ])
      )
    );
  }
}