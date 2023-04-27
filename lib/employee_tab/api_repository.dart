

import 'Emp_Model.dart';
import 'api_provider.dart';

class ApiRepository{
  final _provider=ApiProvider();
  Future<EmpList> fetchEmpList(){
    return _provider.fetchEmpList();
  }
}
class NetworkError extends Error {}