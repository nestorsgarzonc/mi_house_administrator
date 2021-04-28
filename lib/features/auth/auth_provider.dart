import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mi_house_administrator/core/failure/failure.dart';
import 'package:mi_house_administrator/core/requests/http_handler.dart';
import 'package:mi_house_administrator/core/token/token.dart';
import 'package:mi_house_administrator/features/auth/models/login_model.dart';
import 'package:mi_house_administrator/features/auth/models/register_model.dart';

enum AuthStates {
  initial,
  authenticated,
  notAuthenticated,
}

class AuthProvider extends ChangeNotifier {
  final HttpHandler httpHandler;
  final Token token;
  bool isLoading = false;
  InitialRegisterArgs? initialRegisterArgs;

  //TODO: CHANGE
  AuthStates state = AuthStates.notAuthenticated;
  AuthProvider({required this.token, required this.httpHandler});

  void onRegisterArgs(InitialRegisterArgs args) {
    initialRegisterArgs = args;
    notifyListeners();
  }

  Future<Failure?> login(LoginModel login) async {
    try {
      final res = await httpHandler.performPost('/login', login.toJson(), withToken: false);
      token.saveToken(res['token'] as String);
      state = AuthStates.authenticated;
      notifyListeners();
      return null;
    } on Failure catch (e) {
      return e;
    } on SocketException catch (_) {
      return Failure(message: 'Ha ocurrido un problema, intentalo mas tarde');
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  Future<Failure?> register(RegisterModel register) async {
    try {
      await httpHandler.performPost(
        '/registro/admin',
        register.toJson(),
        withToken: false,
      );
      return null;
    } on Failure catch (e) {
      return e;
    } on SocketException catch (_) {
      return Failure(message: 'Ha ocurrido un problema, intentalo mas tarde');
    } catch (e) {
      return Failure(message: e.toString());
    }
  }
}

class InitialRegisterArgs {
  final String email;
  final String password;
  final String confirmPassword;

  InitialRegisterArgs({required this.email, required this.password, required this.confirmPassword});
}
