

import 'package:final_review/SignUpPage.dart';
import 'package:final_review/employee_tab/EmployeeView.dart';
import 'package:final_review/firebase_tab/UsersFirebase.dart';
import 'package:final_review/sqflite_tab/UsersSqf.dart';
import 'package:flutter/material.dart';

class TabPages extends StatefulWidget {
  @override
  TabPagesState createState() => TabPagesState();
}

class TabPagesState extends State<TabPages> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
              backgroundColor: Colors.indigo,
                elevation: 0,
                  actions: [TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  SignUpPage()),);
                  }, child: Text("Signup",style: TextStyle(color: Colors.white),))],
                bottom: const TabBar(
                dividerColor: Colors.indigoAccent,
                labelColor: Colors.indigo,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white),
                tabs: [
                  Tab(child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Employee List",style: TextStyle(color: Colors.black,fontSize: 14),),
                  )),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Tab(child: Text("Firebase Users",style: TextStyle(color: Colors.black,fontSize: 14),)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Tab(child:Text("Sqflite Users",style: TextStyle(color: Colors.black,fontSize: 14),)),
                  )
                ],
              ),
              ),
              body:  TabBarView(
                children: [
                  EmployeeView(),
                  UsersFBPage(),
                  UsersSqfPage(),
                ],
              ),

            )));
  }
}