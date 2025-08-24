import 'package:collection/collection.dart';

enum EventType {
  BUSINESS_EVENT,
  EXTERNAL_CALL,
  SECURITY_EVENT,
  USER_ACTION,
  BATCH_PROCESS,
}

enum ResultType {
  SUCCESS,
  FAILURE,
  PENDING,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (EventType):
      return EventType.values.deserialize(value) as T?;
    case (ResultType):
      return ResultType.values.deserialize(value) as T?;
    default:
      return null;
  }
}
