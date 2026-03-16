abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final int id;

  LoadProfile(this.id);
}

