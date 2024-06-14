import 'package:barbearia/Screens/menu.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff05253B),
      body: Center(child: Image.asset('assets/Logo.png')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          child: const Text('Iniciar',selectionColor: Color(0xff000000),style: TextStyle(fontSize:24 ),
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder:
            (context) => const Menu()));
          },
        ),
      ),
    );
  }
}
