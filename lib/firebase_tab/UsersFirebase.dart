
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UsersFBPage extends StatefulWidget {

  @override
  _RecordsFBState createState() => _RecordsFBState();
}

class _RecordsFBState extends State<UsersFBPage> {
  // List<UserForm> userForms = [];
  final _database = FirebaseDatabase.instance.ref();


  @override
  void initState() {
    //_newsBloc.add(GetEmpList());
    getRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Records')),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _database.child("Users").orderByKey().limitToLast(20).onValue,
          builder: (context, snapshot) {
            final list=<Card>[];
            if(snapshot.hasData){
              if(snapshot.data!.snapshot.value!=null) {
                final users = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map);
                var user;
                users.forEach((key, value) {
                  user = Map<String, dynamic>.from(value);
                  print(user["firstName"].toString());
                  final userCard = Card(
                    child: Container(
                      margin: EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "First Name: ${user["firstName"]}"),
                          Text("Last Name: ${user["lastName"]}",
                            textAlign: TextAlign.start,),
                          Text("Mobile: ${user["mobNo"]}",
                            textAlign: TextAlign.start,),
                          Text("Email: ${user["email"]}",
                            textAlign: TextAlign.start,),
                          Text("Is Upload: ${user["is_upload"]}",
                            textAlign: TextAlign.start,),
                        ],

                      ),
                    ),
                  );
                  list.add(userCard);
                });
              }
              else{
                return Center(child:Text("No users in firebase DB"));
              }

            }
            else{
              return Center(child:Text("No users in firebase DB"));
            }
            return ListView(
              shrinkWrap: true,
              children:list,
            );
          },
        ),
      )
    );
  }

  getRecords() async {
    final ref = FirebaseDatabase.instance.ref();
    //ref.child("Users").onValue
    ref.child("Users").key?.codeUnitAt(1);
    //final snapshot = await ref.child('Users/').get();
    final event = await ref.once(DatabaseEventType.value);

    if (event.snapshot.exists) {
      print(event.snapshot.value);
    } else {
      print('No data available.');
    }
  }
}