import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Navbar extends StatefulWidget{
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    
  }
}

class PageControllerCubit extends Cubit<PageController>{
  PageControllerCubit() : super(PageController());

  @override
  Future<void> close() {
    state.dispose();
    return super.close();
  }

  void goto(int page,{Duration? duration, Curve? curve}){
    state.animateToPage(
      page,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut
    );
  }
}