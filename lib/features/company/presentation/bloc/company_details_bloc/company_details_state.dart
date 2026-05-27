import 'package:equatable/equatable.dart';
import 'package:learn_hub/features/company/domain/entities/company.dart';

class CompanyDetailsState extends Equatable {
  final bool isLoading;
  final Company? company;
  final String? error;

  const CompanyDetailsState({this.isLoading = false, this.company, this.error});

  CompanyDetailsState copyWith({
    bool? isLoading,
    Company? company,
    String? error,
  }) {
    return CompanyDetailsState(
      isLoading: isLoading ?? this.isLoading,
      company: company ?? this.company,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, company, error];
}
