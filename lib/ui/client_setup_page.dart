import 'package:anitrack/ui/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClientSetupPage extends StatefulWidget {
  const ClientSetupPage({super.key});

  @override
  State<ClientSetupPage> createState() => ClientSetupState();
}

class ClientSetupState extends State<ClientSetupPage>{
  final _formKey = GlobalKey<FormState>();
  final _controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme=Theme.of(context);
    return Scaffold(
      appBar: AppBar(title:const Text("enter client id")),
      body: Column(children: [
        Text("Instructions:",style: TextStyle(fontWeight: FontWeight.bold,fontSize:theme.textTheme.headlineLarge!.fontSize)),
        const Text("1. Go to anilist development console"),
        const Text("2. Create a new application"),
        const Text("3. Copy the client id and paste it here"),
        const Text("4. Press the button below to continue"),
        Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller:_controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              }
            ),
            ElevatedButton(onPressed: () {
              if(_formKey.currentState!.validate()){
                String clientId=_controller.text;
                FlutterSecureStorage storage=const FlutterSecureStorage();
                storage.write(key:"clientId", value: clientId);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Navbar())
                );
              }
            }, child: const Text("Continue"))
          ])
        )
      ])
    );
  }
}