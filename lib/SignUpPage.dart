

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:final_review/DatabaseHelper.dart';
import 'package:final_review/TabFiles.dart';
import 'package:final_review/UserModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState  extends State<SignUpPage> {
  late BuildContext _ctx;
  bool _isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _passwordVisible = false;
  final formGlobalKey = GlobalKey < FormState > ();
  final firstNameController = TextEditingController();
  final mobNoController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();

  FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  void initState() {
    initDb();
  }

  void initDb() async {
    await DatabaseRepository.instance.database;
  }

  bool ActiveConnection = false;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Network available")));
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Network unavailable")));
      });
    }
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

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    void addRecordSqf() async {

      UserForm userForm = UserForm(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobNo: int.parse(mobNoController.text),
        email: emailController.text,
        is_upload: 0,
      );
        await DatabaseRepository.instance.insert(userForm: userForm).then((value){
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('User Saved in SqFlite')));
          print("saved");
          formGlobalKey.currentState?.reset();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  TabPages()),
          );
        }).catchError((e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        });

    }

    void addRecordFB() async {

      final userForm = <String,dynamic>{
      "firstName": (firstNameController.text),
      "lastName": lastNameController.text,
      "mobNo": int.parse(mobNoController.text),
      "email": emailController.text,
      "is_upload": 1,
      };
        DatabaseReference ref = FirebaseDatabase.instance.ref();
        print("inside firebase function");
        ref.child("Users")
            .push()
            .set(userForm)
            .then((_) {  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Saved in Firebase')));
                     formGlobalKey.currentState?.reset();
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  TabPages()),);})
            .catchError((onError)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(onError.toString()))));


    }
    var loginBtn = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        minimumSize: const Size.fromHeight(40), // NEW
      ),
      onPressed: () async {
        await DatabaseRepository.instance.getAllTodos().then((value) {
          print(value);
        }).catchError((e) => debugPrint(e.toString()));
        if (formGlobalKey.currentState!.validate()) {
          print("Valid data");
          bool isConnected= await hasNetwork();
          print("isConnected $isConnected");
          if(isConnected==true){
            print("FB data");
            addRecordFB();
          }
          else if(isConnected==false){
            print("sqf data");
            addRecordSqf();
          }
        }
      },

      child: Text("Sign up",style: TextStyle(fontSize: 18),),
    );

    var loginForm = ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Sign up",
                textScaleFactor: 2.0,
              ),
              Form(
                key: formGlobalKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      focusNode: f1,
                      autofocus: true,
                      decoration: inputDecoration("First Name"),
                      keyboardType: TextInputType.name,
                      controller: firstNameController,
                      //maxLength: 30,
                      inputFormatters:[
                        LengthLimitingTextInputFormatter(30),
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      //validator: validateMobile,
                      validator: (val) {
                        // _mobile = val;
                        if (val!.length == 0) {
                          return 'Enter First Name';
                        } else
                          return null;
                      },
                      onFieldSubmitted: (val){
                        if(val!=""){
                          f1.unfocus();
                          FocusScope.of(context).requestFocus(f2);
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      focusNode: f2,
                      decoration:  inputDecoration('Last Name'),
                      keyboardType: TextInputType.name,
                      controller: lastNameController,
                      //validator: validateMobile,
                      inputFormatters:[
                        LengthLimitingTextInputFormatter(30),
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      validator: (val) {
                        // _mobile = val;
                        if (val!.length == 0) {
                          return 'Enter Last Name';
                        } else
                          return null;
                      },
                      onFieldSubmitted: (val){
                        if(val!=""){
                          f2.unfocus();
                          FocusScope.of(context).requestFocus(f3);
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                       focusNode: f3,
                        decoration: inputDecoration('Mobile No.'),
                        keyboardType: TextInputType.phone,
                        controller: mobNoController,
                        //validator: validateMobile,
                        validator: (val) {
                          // _mobile = val;
                          if (val!.length != 10) {
                            return 'Mobile Number must be of 10 digit';
                          } else
                            return null;
                        },
                        inputFormatters:[
                          LengthLimitingTextInputFormatter(10),
                        ],
                      onFieldSubmitted: (val){
                        if(val!=""){
                          f3.unfocus();
                          FocusScope.of(context).requestFocus(f4);
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      focusNode: f4,
                      decoration: inputDecoration("Email"),
                      inputFormatters:[
                        LengthLimitingTextInputFormatter(40),
                      ],
                      controller: emailController,
                      validator: (email) {
                        if (isEmailValid(email!)) return null;
                        else
                          return 'Enter a valid email address';
                      },
                      onFieldSubmitted: (val){
                        if(val!=""){
                          f4.unfocus();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              loginBtn
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Sign up"),
      // ),
      key: scaffoldKey,
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.1,
                  0.4,
                  0.6,
                  0.9,
                ],
                colors: [
                  Colors.lightBlueAccent,
                  Colors.white,
                  Colors.white,
                  Colors.lightBlueAccent,
                 //
                ],
              )
          ),
        child: Center(
          child: loginForm,
        ),
      ),
    );
  }

  void _showSnackBar(String text) {
    // scaffoldKey.currentState.showSnackBar(new SnackBar(
    //   content: new Text(text),
    // ));
  }

  // Future<void> _submit() async {
  //   final form = formKey.currentState;
  //   var user = User(_name, _username, _password, "true");
  //   var db = DatabaseHelper();
  //   var isUser=await db.selectUser(user);
  //   print(isUser);
  //   if(isUser==null) {
  //     if (form!.validate()) {
  //       setState(() {
  //         _isLoading = true;
  //         form.save();
  //         var user = User(_name, _username, _password, "true");
  //         var db = DatabaseHelper();
  //         db.saveUser(user).whenComplete(() {
  //           _isLoading = false;
  //         });
  //       });
  //     }
  //   }
  //   else if(isUser.username!=null){
  //     ScaffoldMessenger.of(context).showSnackBar( SnackBar(
  //         content: Text("User already exist"),
  //       action: SnackBarAction(
  //         label: 'Login',
  //         onPressed: () {
  //
  //         },
  //       ),
  //     ));
  //   }
  //   else{
  //     ScaffoldMessenger.of(context).showSnackBar( SnackBar(
  //       content: Text("Unable to Signup"),
  //     ));
  //   }
  // }
  bool isEmailValid(String s) {
    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(s);
    return emailValid;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobNoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration(String lable){
   return InputDecoration(
        alignLabelWithHint: true,
        labelText: lable,
        labelStyle: TextStyle(
            color: f1.hasFocus
                ? Colors.indigo
                : Colors.black),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          borderSide:
          BorderSide(color: Colors.indigo, width: 0.5),
        ));
  }
}
