import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/shared/widgets/alerts/alert.dart';
import 'package:learn_hub/shared/widgets/buttons/bar_button.dart';
import 'package:learn_hub/shared/widgets/custom_progress_indicator.dart';
import 'package:learn_hub/shared/widgets/text_fields/custom_text_field.dart';

import 'package:learn_hub/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:learn_hub/features/auth/presentation/bloc/login_bloc/login_event.dart';
import 'package:learn_hub/features/auth/presentation/bloc/login_bloc/login_state.dart';
import 'package:learn_hub/core/di/injection.dart';
import 'package:learn_hub/features/auth/domain/repositories/login_repository.dart';
import 'package:learn_hub/features/home/presentation/screens/bottom_navigation_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String route = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(getIt<LoginRepository>()),
      child: Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => BottomNavigationScreen(),
                ),
              );
            }

            if (state.error != null) {
              showAlert(context, message: state.error!);
            }
          },
          builder: (context, state) {
            final bloc = context.read<LoginBloc>();

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: kToolbarHeight + 30,
                      left: 30,
                      right: 30,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Column(
                            children: [
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Welcome Developer',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),

                        CustomTextField(
                          title: 'User Name',
                          onChanged: (val) => bloc.add(PhoneNumberChanged(val)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 50),
                          child: CustomTextField(
                            title: 'Password',
                            obscureText: true,
                            onChanged: (val) => bloc.add(PasswordChanged(val)),
                          ),
                        ),

                        BarButton(
                          title: 'Sign In',
                          onTap: () => bloc.add(LoginSubmitted()),
                        ),
                      ],
                    ),
                  ),
                  if (state.isLoading) CustomProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
