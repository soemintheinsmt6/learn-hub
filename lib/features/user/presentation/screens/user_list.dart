import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/features/user/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:learn_hub/features/user/presentation/bloc/user_bloc/user_event.dart';
import 'package:learn_hub/features/user/presentation/bloc/user_bloc/user_state.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';
import 'package:learn_hub/core/utils/navigation.dart';
import 'package:learn_hub/features/user/presentation/widgets/user_list_shimmer.dart';
import 'package:learn_hub/features/user/presentation/widgets/user_tile.dart';

import 'package:learn_hub/features/user/presentation/screens/user_details_screen.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.repository});

  final UserRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(repository)..add(LoadUser()),
      child: Scaffold(
        appBar: AppBar(title: const Text("User List")),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const UserListShimmer();
            }

            if (state.error != null) {
              return Center(child: Text("Error: ${state.error}"));
            }

            return ListView.separated(
              itemCount: state.users.length,
              padding: const EdgeInsets.all(20),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(
                  user: user,
                  onTap: () {
                    pushView(
                      context,
                      UserDetailsScreen(user: user, repository: repository),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
