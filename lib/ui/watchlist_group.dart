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
          _BuildTabContent(0,Watchlist(status: "CURRENT")),
          _BuildTabContent(1,Watchlist(status: "COMPLETED")),
          _BuildTabContent(2,Watchlist(status: "PLANNING"))
        ])
      )
    );
  }
}

class _BuildTabContent extends StatelessWidget{

  const _BuildTabContent(this.index, this.child);

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);

    // Only build content if it's the selected tab
    if (controller.index == index) {
      return child;
    }
    return Container(); 
  }
}

  
