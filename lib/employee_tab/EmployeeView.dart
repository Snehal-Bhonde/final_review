
import 'dart:io';

import 'package:final_review/employee_tab/Emp_states.dart';
import 'package:final_review/employee_tab/api_provider.dart';
import 'package:final_review/employee_tab/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'Emp_Model.dart';
import 'Emp_bloc.dart';
import 'package:final_review/employee_tab/emp_event.dart';

class EmployeeView extends StatefulWidget{
  @override
  EmployeeViewPage createState() {
   return EmployeeViewPage();
  }

}
/*class EmployeeViewPage extends State<EmployeeView> {

  @override
  void initState() {
    //checkNetwork();
    super.initState();
  }

  Future checkNetwork() async {
    var listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case InternetConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });

    // close listener after 30 seconds, so the program doesn't run forever
    await Future.delayed(Duration(seconds: 30));
    await listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
        BlocProvider<EmpBloc>(
        create: (BuildContext context) => EmpBloc(ApiRepository()),
    ),
    ],
    child:Scaffold(
      appBar: AppBar(title: Text('Employee List')),
      body: blocBody(),
    ));
  }

  Widget _buildListEmpList() {
    return Container(
      margin: EdgeInsets.all(8.0),
      // child: BlocProvider(
      //   create: (_) => _newsBloc,
      //   child: BlocListener<EmpListBloc, EmpListState>(
      //     listener: (context, state) {
      //       if (state is EmpListError) {
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(
      //             content: Text(state.message!),
      //           ),
      //         );
      //       }
      //     },
      //     child: BlocBuilder<EmpListBloc, EmpListState>(
      //       builder: (context, state) {
      //         if (state is EmpListInitial) {
      //           return _buildLoading();
      //         } else if (state is EmpListLoading) {
      //           return _buildLoading();
      //         } else if (state is EmpListLoaded) {
      //           return _buildCard(context, state.empList);
      //         } else if (state is EmpListError) {
      //           return Container();
      //         } else {
      //           return Container();
      //         }
      //       },
      //     ),
      //   ),
      // ),
    );
  }

  Widget blocBody() {
    return BlocProvider(
      create: (context) => EmpBloc(
        ApiRepository(),
      )..add(LoadEmpEvent()),
      child: BlocBuilder<EmpBloc, EmpState>(
        builder: (context, state) {
          if (state is EmpLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is EmpErrorState) {
            return const Center(child:  Text("Error"));
          }
          if (state is EmpLoadedState) {
            var emplist = state.emplist;
            return ListView.builder(
                itemCount:2,
                itemBuilder: (_, index) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                  children: [
                    Text("ID: ${emplist.data}"),
                    Text("Employee Name: ${emplist.data![index].employeeName}"),
                    Text("Employee salary: ${emplist.data![index].employeeSalary}"
                      ,textAlign: TextAlign.start,),
                        ],

                  )) );
                });
          }

          return Container();
        },
      ),
    );
  }




  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}*/


// class EmpListPage extends StatefulWidget {
//   @override
//   _EmpListPageState createState() => _EmpListPageState();
// }

class EmployeeViewPage extends State<EmployeeView> {
  final EmpListBloc _newsBloc = EmpListBloc();

  @override
  void initState() {
    _newsBloc.add(GetEmpList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Employee List')),
      body: _buildListEmpList(),
    );
  }

  Widget _buildListEmpList() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocListener<EmpListBloc, EmpListState>(
          listener: (context, state) {
            if (state is EmpListError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            }
          },
          child: BlocBuilder<EmpListBloc, EmpListState>(
            builder: (context, state) {
              if (state is EmpListInitial) {
                return _buildLoading();
              } else if (state is EmpListLoading) {
                return _buildLoading();
              } else if (state is EmpListLoaded) {
                return _buildCard(context, state.empList);
              } else if (state is EmpListError) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, EmpList model) {
    return ListView.builder(
      itemCount: model.data!.length,
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
                  Text("ID: ${model.data![index].id}"),
                  Text(
                      "Employee Name: ${model.data![index].employeeName}"),
                  Text("Employee salary: ${model.data![index].employeeSalary}"
                    ,textAlign: TextAlign.start,),
                   Text("Age : ${model.data![index].employeeAge}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}