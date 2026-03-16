abstract class CompanyDetailsEvent {}

class LoadCompanyDetails extends CompanyDetailsEvent {
  final int id;

  LoadCompanyDetails(this.id);
}

