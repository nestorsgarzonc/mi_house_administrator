import 'package:flutter/material.dart';
import 'package:mi_house_administrator/features/auth/auth_provider.dart';
import 'package:mi_house_administrator/screens/auth/login_screen.dart';
import 'package:mi_house_administrator/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({Key? key}) : super(key: key);

  static const route = 'IndexScreen';

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    switch (authProv.state) {
      case AuthStates.initial:
        return const LoginScreen();
      case AuthStates.authenticated:
        return const HomeScreen();
      case AuthStates.notAuthenticated:
        return const LoginScreen();
    }
  }
}
