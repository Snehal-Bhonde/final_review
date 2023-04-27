import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'Emp_Model.dart';

class ApiProvider{
  final Dio _dio=Dio();

  final String url="https://dummy.restapiexample.com/api/v1/employees";

  Future<EmpList> fetchEmpList() async{
        late Response response;
        print('connected');
        response= await _dio.get(url);
        //return EmpList.fromJson(response.data);
        return EmpList.fromJson(response.data);
  }

}