

import 'package:shopping_app/features/auth/domain/use_case/usercase.dart';

// import '../../data/model/user_model.dart';
import '../../data/repository/auth_repository.dart';

class Register implements UseCase<void, RegisterParams> {
  final AuthRepository repository;

  Register(this.repository);

  @override
  Future<void> call(RegisterParams params) async {
    return await repository.register(params.email, params.password,params.name);
  }
}

class RegisterParams {
  final String email; 
  final String password;
  final String name;

  RegisterParams(this.email, this.password,this.name);
}