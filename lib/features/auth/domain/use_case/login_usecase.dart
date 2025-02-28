

// import 'package:shopping_app/features/auth/data/model/user_hive_model.dart';
import 'package:shopping_app/features/auth/domain/use_case/usercase.dart';

import '../../data/model/user_model.dart';
import '../../data/repository/auth_repository.dart';

class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<User> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams(this.email, this.password);
}