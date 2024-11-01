import 'package:anitrack/ui/settings/appearance_settings_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget{
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            _generateSettingsField(context, Icons.palette, "Appearance","Change app appearance",AppearanceSettingsPage())
          ],
        ),
      )
    );
  }

  _generateSettingsField(BuildContext context,IconData icon,String title,String? description,Widget page){
    ThemeData theme=Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder:(context)=>page)),
        icon:Icon(icon),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          foregroundColor: theme.colorScheme.onSurface
        ),
        label:description!=null?
        Padding(
          padding: const EdgeInsets.only(left:10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: theme.textTheme.bodyLarge!.fontSize,
                  fontWeight: FontWeight.bold
                )
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: theme.textTheme.labelSmall!.fontSize,
                  color:theme.colorScheme.secondary
                )
              )
          ]),
        )
        :Text(
          title
        ),
      ),
    );
  }
}