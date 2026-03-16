import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';

import 'company_details_event.dart';
import 'company_details_state.dart';

class CompanyDetailsBloc
    extends Bloc<CompanyDetailsEvent, CompanyDetailsState> {
  final CompanyRepository repository;

  CompanyDetailsBloc(this.repository) : super(const CompanyDetailsState()) {
    on<LoadCompanyDetails>(_onLoadCompanyDetails);
  }

  Future<void> _onLoadCompanyDetails(
    LoadCompanyDetails event,
    Emitter<CompanyDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final company = await repository.fetchCompanyById(event.id);

      emit(state.copyWith(isLoading: false, company: company));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
