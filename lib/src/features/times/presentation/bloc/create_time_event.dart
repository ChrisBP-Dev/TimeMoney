sealed class CreateTimeEvent {
  const CreateTimeEvent();
}

final class CreateTimeHourChanged extends CreateTimeEvent {
  const CreateTimeHourChanged({required this.value});
  final String value;
}

final class CreateTimeMinutesChanged extends CreateTimeEvent {
  const CreateTimeMinutesChanged({required this.value});
  final String value;
}

final class CreateTimeSubmitted extends CreateTimeEvent {
  const CreateTimeSubmitted();
}

final class CreateTimeReset extends CreateTimeEvent {
  const CreateTimeReset();
}
