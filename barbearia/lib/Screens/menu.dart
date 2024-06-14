

import 'package:barbearia/Screens/About.dart';
import 'package:barbearia/Screens/modalidade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';



class Menu extends StatelessWidget {
  //const Menu(BuildContext context,Animation animation1,Animation animation2,{super.key});
  const Menu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
         backgroundColor: Colors.white70,
          title: const Text('Home', style: TextStyle(color: Colors.black,fontSize: 20),),
      ),
       body: Center(
         child: Container(
          height:800.0,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.only(topLeft:Radius.circular(16) ,topRight:Radius.circular(16)  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(30),
                    child: Center(child:Image.asset ("assets/Rectangle3.png",)),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ]
                ),

                ),
                Center(
                  child: Text("Agende um horario conosco",style: TextStyle(fontSize: 20,color: Colors.white)),
                ),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: OutlinedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(Colors.white,),
                          elevation: MaterialStatePropertyAll(30.0),
                          shadowColor: MaterialStatePropertyAll<Color?>(Color(0xff000000))

                      ),
                      child: const Text('Agendar',selectionColor: Color(0xff000000),style: TextStyle(fontSize:28 ),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder:
                            (context) => MyHomePage()));
                      },
                    ),
                  ),
                ],),

              ],
            ),
          ),


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
            selectedIndex: 0,
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


