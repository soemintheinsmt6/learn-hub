import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_bloc/company_bloc.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_bloc/company_event.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_bloc/company_state.dart';
import 'package:learn_hub/features/company/presentation/screens/company_details_screen.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';
import 'package:learn_hub/core/utils/navigation.dart';
import 'package:learn_hub/features/company/presentation/widgets/company_tile.dart';

import 'package:learn_hub/features/company/presentation/widgets/company_list_shimmer.dart';

class CompanyList extends StatelessWidget {
  const CompanyList({super.key, required this.repository});

  final CompanyRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompanyBloc(repository)..add(LoadCompanies()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Company List')),
        body: BlocBuilder<CompanyBloc, CompanyState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const CompanyListShimmer();
            }

            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }

            return ListView.builder(
              itemCount: state.companies.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                final company = state.companies[index];
                return CompanyTile(
                  company: company,
                  onTap: () {
                    pushView(
                      context,
                      CompanyDetailsScreen(
                        company: company,
                        repository: repository,
                      ),
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
