import 'package:anitrack/utils/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppearanceSettingsPage extends StatelessWidget {
  AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme=Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Appearance")),
      body:SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20),
        child: ListView(
          children: [
            Text("Theme: ",style: theme.textTheme.bodyLarge),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: BlocBuilder<ThemeCubit,ThemeController>(
                builder: (context,controller) {
                  final ThemeCubit cubit=context.read<ThemeCubit>();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _generateSelectableBox(theme, cubit, controller, ThemeMode.system, "System"),
                      _generateSelectableBox(theme, cubit, controller, ThemeMode.light, "Light"),
                      _generateSelectableBox(theme, cubit, controller, ThemeMode.dark, "Dark"),
                    ]
                  );
                }
              ),
            )
          ],
        )
      ))
    );
  }

  _generateSelectableBox(ThemeData theme, ThemeCubit cubit, ThemeController controller, ThemeMode mode,String label){
    BorderRadius? radius;
  
    if(mode==ThemeMode.system){
      radius=const BorderRadius.horizontal(left:Radius.circular(8));
    }else if(mode==ThemeMode.dark){
      radius=const BorderRadius.horizontal(right:Radius.circular(8));
    }

    return GestureDetector(
      onTap: (){
        cubit.setThemeMode(mode);
      },
      child: Container(
        decoration: BoxDecoration(
          border:Border.all(color:theme.colorScheme.secondary),
          color: controller.mode==mode?theme.colorScheme.secondaryContainer:Colors.transparent,
          borderRadius: radius,
        ),
        width: theme.buttonTheme.minWidth,
        height: theme.buttonTheme.height,
        child:Align(
          alignment: Alignment.center,
          child:controller.mode==mode?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[Icon(Icons.check,color:theme.colorScheme.onSecondaryContainer),Text(label,style:TextStyle(color:theme.colorScheme.onSecondaryContainer))])
            :Text(label,style:TextStyle(color: theme.colorScheme.secondary)
          )
        )
      )
    );
  }
}