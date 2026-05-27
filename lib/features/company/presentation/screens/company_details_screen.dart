import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/core/utils/app_color.dart';
import 'package:learn_hub/core/utils/company_data_formatter.dart';
import 'package:learn_hub/features/company/domain/entities/company.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_details_bloc/company_details_bloc.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_details_bloc/company_details_event.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_details_bloc/company_details_state.dart';
import 'package:learn_hub/shared/widgets/images/cached_image.dart';
import 'package:learn_hub/shared/widgets/info_row.dart';
import 'package:learn_hub/shared/widgets/metric_card.dart';

class CompanyDetailsScreen extends StatelessWidget {
  const CompanyDetailsScreen({
    super.key,
    required this.company,
    required this.repository,
  });

  final Company company;
  final CompanyRepository repository;

  static const _aboutCompanyText =
      'Tech Solutions Ltd. is a leading global provider of software '
      'development and IT consulting services. Our mission is to empower '
      'businesses with cutting-edge technology solutions that drive growth '
      'and efficiency.';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CompanyDetailsBloc(repository)..add(LoadCompanyDetails(company.id)),
      child: Scaffold(
        backgroundColor: AppColors.secondaryBackground,
        appBar: AppBar(
          backgroundColor: AppColors.secondaryBackground,
          centerTitle: true,
          title: Text('${company.name}\'s Details'),
        ),
        body: SafeArea(
          child: BlocBuilder<CompanyDetailsBloc, CompanyDetailsState>(
            builder: (context, state) {
              // Prefer freshly fetched details, but fall back to the company
              // passed in from the list so a failed (or pending) detail fetch
              // still renders a usable screen instead of a bare error.
              final company = state.company ?? this.company;

              return _CompanyDetailsBody(company: company);
            },
          ),
        ),
      ),
    );
  }
}

class _CompanyDetailsBody extends StatelessWidget {
  const _CompanyDetailsBody({required this.company});

  final Company company;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE6FBF9), Color(0xFFFDFEFF)],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: company.logo.isNotEmpty
                      ? CachedImage(url: company.logo)
                      : const Icon(
                          Icons.apartment,
                          size: 40,
                          color: AppColors.secondaryBackground,
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  company.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Innovating the future, today.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('+ Follow'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Website'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MetricCard(
                icon: Icons.group,
                label: 'EMPLOYEES',
                value: formatEmployees(company.employeeCount),
              ),
              MetricCard(
                icon: Icons.show_chart,
                label: 'MARKET CAP',
                value: formatMarketCap(company.marketCap),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'About Company',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            CompanyDetailsScreen._aboutCompanyText,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Company Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(label: 'Industry', value: company.industry),
                const SizedBox(height: 12),
                InfoRow(label: 'Domain', value: company.domain),
                const SizedBox(height: 12),
                InfoRow(label: 'CEO', value: company.ceoName),
                const SizedBox(height: 12),
                InfoRow(label: 'Address', value: company.fullAddress),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
