

import 'package:equatable/equatable.dart';
import 'package:final_review/employee_tab/Emp_Model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class EmpState extends Equatable {}

class EmpLoadingState extends EmpState {
  @override
  List<Object?> get props => [];
}

class EmpLoadedState extends EmpState {
  //final List<EmpList> emplist;
  final EmpList emplist;
  EmpLoadedState(this.emplist);
  @override
  List<Object?> get props => [emplist];
}

class EmpErrorState extends EmpState {
  final String error;
  EmpErrorState(this.error);
  @override
  List<Object?> get props => [error];
}