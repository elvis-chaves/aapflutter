import 'package:barbearia/Screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';



class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        title: const Text('Sobre', style: TextStyle(color: Colors.black,fontSize: 35),),
      ),
      body: Center(
        child: Container(
          height:800.0,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.only(topLeft:Radius.circular(16) ,topRight:Radius.circular(16)  ),
          ),
          child: Image.asset("assets/Group 3.jpg"),
        ),
      ),

      bottomNavigationBar:Container(

        color: Colors.black,
        child: Padding(

          padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white70,
            tabBackgroundColor: Colors.grey,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            gap: 12,
            selectedIndex: 1 ,

            tabs: [
              GButton(icon: Icons.home,text: "Home",onPressed: () {Navigator.push(context, MaterialPageRoute(builder:
                  (context) => Menu()));},),
              GButton(icon: Icons.settings,text: "Sobre",onPressed: () {Navigator.push(context, MaterialPageRoute(builder:
                  (context) => About()));},)
            ],

          ),
        ),
      ),
    );
  }
}
