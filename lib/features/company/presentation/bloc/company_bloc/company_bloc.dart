import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_bloc/company_event.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_bloc/company_state.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyRepository repository;

  CompanyBloc(this.repository) : super(const CompanyState()) {
    on<LoadCompanies>(_onLoadCompanies);
  }

  void _onLoadCompanies(LoadCompanies event, Emitter<CompanyState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final companies = await repository.fetchCompanies();

      emit(state.copyWith(isLoading: false, companies: companies));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
