import 'package:anitrack/utils/calendar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarPage extends StatelessWidget{
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme=Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        elevation: 1,
      ),
      body: SafeArea(
        child: BlocBuilder<CalendarCubit,CalendarDisplay>(
          builder: (context,currentDisplay) {
            final CalendarCubit cubit=context.read<CalendarCubit>();

            return Padding(
              padding: const EdgeInsets.only(top:10,left: 10,right: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Row(
                  children: [
                    _generateSelectableBox(theme, cubit, CalendarDisplay.all, "All", currentDisplay),
                    _generateSelectableBox(theme, cubit, CalendarDisplay.watching, "Watching", currentDisplay),
                  ])
              ]),
            );
          }
        )
      )
    );
  }
}

_generateSelectableBox(ThemeData theme, CalendarCubit cubit, CalendarDisplay display, String label, CalendarDisplay currentDisplay){
    BorderRadius? radius;
  
    if(display==CalendarDisplay.all){
      radius=const BorderRadius.horizontal(left:Radius.circular(8));
    }else if(display==CalendarDisplay.watching){
      radius=const BorderRadius.horizontal(right:Radius.circular(8));
    }

    return GestureDetector(
      onTap: (){
        cubit.setThemeMode(display);
      },
      child: Container(
        decoration: BoxDecoration(
          border:Border.all(color:theme.colorScheme.secondary),
          color: currentDisplay==display?theme.colorScheme.secondaryContainer:Colors.transparent,
          borderRadius: radius,
        ),
        width: theme.buttonTheme.minWidth,
        height: theme.buttonTheme.height,
        child:Align(
          alignment: Alignment.center,
          child:currentDisplay==display?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[Icon(Icons.check,color:theme.colorScheme.onSecondaryContainer),Text(label,style:TextStyle(color:theme.colorScheme.onSecondaryContainer))])
            :Text(label,style:TextStyle(color: theme.colorScheme.secondary)
          )
        )
      )
    );
  }