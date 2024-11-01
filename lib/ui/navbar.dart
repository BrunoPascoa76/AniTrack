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
  @override
  Widget build(BuildContext context) {
    final auth=getIt<AnilistAuth>();

    return BlocBuilder<PageCubit,int>(
      builder: (context,currentIndex){
        final cubit=context.read<PageCubit>();

        return FutureBuilder<String>(
          future: auth.getValidToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot){

            if(snapshot.hasData){
              return Scaffold(
                body: PageView(
                  controller: cubit.controller,
                  children: const [
                    Center(child: Text('Page 1')),
                    Center(child: Text('Page 2')),
                    Center(child: Text('Page 3')),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: cubit.goto,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(currentIndex==0?Icons.video_library:Icons.video_library_outlined),
                      label: "Watchlist"
                    ),
                  ]
                )
              );
            }else{
              return const CircularProgressIndicator();
            }
          }
        );
      }
    );
  }
}

class PageCubit extends Cubit<int>{
  PageCubit() : super(0);

  final PageController controller=PageController(initialPage: 0);

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }

  void goto(int page){
    controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
    emit(page);
  }
}