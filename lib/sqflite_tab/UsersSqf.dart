

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:final_review/DatabaseHelper.dart';
import 'package:final_review/UserModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersSqfPage extends StatefulWidget {

  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<UsersSqfPage> {
  List<UserForm> userForms = [];


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
      // body: _buildListEmpList(),
      body: userForms.isEmpty
          ? const Center(child: const Text("No users in Sqflite DB"))
          :
      ListView.builder(
        itemCount: userForms.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "First Name: ${userForms[index].firstName}"),
                    Text("Last Name: ${userForms[index].lastName}",textAlign: TextAlign.start,),
                    Text("Mobile: ${userForms[index].mobNo}",textAlign: TextAlign.start,),
                    Text("Email: ${userForms[index].email}",textAlign: TextAlign.start,),
                    Text("Is Upload: ${userForms[index].is_upload}",textAlign: TextAlign.start,),


                  ],

                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(userForms.length>0) {
            bool isConnected = await hasNetwork();
            print("isConnected $isConnected");
            if (isConnected == true) {
              print("FB data");
              addRecordstoFB();
            }
            else if (isConnected == false) {
              print("No internet");
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No internet')));
            }
          }
          else {
            print("No Records");
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No Records')));
          }

        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              const Icon(Icons.sync),
              Text("Sync")
            ],
          ),
        ),
      ),
    );
  }

  addRecordstoFB(){
    userForms.forEach((element) {
      final userForm = <String,dynamic>{
        "firstName": element.firstName,
        "lastName": element.lastName,
        "mobNo": element.mobNo,
        "email": element.email,
        "is_upload": 1,
      };

      DatabaseReference ref = FirebaseDatabase.instance.ref();
      print("inside firebase adding");
      ref.child("Users")
          .push()
          .set(userForm)
          .then((_) async {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Users added in Firebase')));
                       DatabaseRepository.instance.delete(element.userId!).then((value) {
                         ScaffoldMessenger.of(context)
                             .showSnackBar( SnackBar(content: Text('Deleted ${element.userId!}')));
                         Navigator.pop(context);
                         setState(() {
                           getRecords();
                         });
                       }).catchError((e) => debugPrint(e.toString()));
                    })
          .catchError((onError){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(onError.toString())));
          });
    });

  }

  void getRecords() async {
    await DatabaseRepository.instance.getAllTodos().then((value) {
      setState(() {
        userForms = value;
      });
    }).catchError((e) => debugPrint(e.toString()));
  }

  Future<bool> hasNetwork() async {
    try {
      Dio dio= new Dio();
      final result = await dio.get('http://www.google.com');
      if(result.statusCode==200){
        print("true");
        return true;
      }
      else{
        print("false");
        return false;
      }
    }
    on SocketException catch (_) {
      return false;
    }
    on DioError catch(_){
      return false;
    }
  }

}