import 'package:final_review/employee_tab/Emp_states.dart';
import 'package:final_review/employee_tab/api_provider.dart';
import 'package:final_review/employee_tab/api_repository.dart';
import 'package:final_review/employee_tab/emp_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpListBloc extends Bloc<EmpListEvent, EmpListState> {
  EmpListBloc() : super(EmpListInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<GetEmpList>((event, emit) async {
      try {
        emit(EmpListLoading());
        final mList = await _apiRepository.fetchEmpList();
        emit(EmpListLoaded(mList));
        if (mList.error != null) {
          emit(EmpListError(mList.error));
        }
      } on NetworkError {
        emit(EmpListError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
