import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:shopping_app/features/auth/presentation/view_model/bloc/auth/auth_state.dart';
import 'package:shopping_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:shopping_app/features/auth/domain/use_case/register_usecase.dart';

import '../../../../data/model/user_hive_model.dart';
import '../../../../../../app/constant/api_config.dart';
import 'auth_event.dart';

import 'package:http/http.dart' as http;
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
final http.Client client = http.Client();
  AuthBloc(this.login, this.register) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await login(LoginParams(event.email, event.password));
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

   on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await register(RegisterParams(event.email, event.password,event.name));
        emit(AuthRegistered()); // Emit success without user data
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await client.put(
          Uri.parse('${ApiConfig.baseUrl}/password/reset/${event.token}'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'password': event.password,
            'passwordConfirm': event.passwordConfirm,
          }),
        );


        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final authBox = Hive.box<UserHiveModel>('authBox');
          final userHiveModel = UserHiveModel(
            success: data['success'],
            user: UserData(
              avatar: Avatar(
                publicId: data['user']['avatar']['public_id'],
                url: data['user']['avatar']['url'],
              ),
              id: data['user']['_id'],
              name: data['user']['name'],
              email: data['user']['email'],
              password: event.password, // Update with new password
              role: data['user']['role'],
              createdAt: data['user']['createdAt'],
            ),
            token: data['token'],
          );
          await authBox.put('currentUser', userHiveModel);
          emit(AuthPasswordResetSuccess());
        } else {
          final error = json.decode(response.body)['message'] ?? 'Unknown error';
          throw Exception(error);
        }
      } catch (e) {
        log('Bloc: Error resetting password: $e');
        emit(AuthError('Failed to reset password: $e.toString()'));
      }
    });
  }
}