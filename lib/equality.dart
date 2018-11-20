import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Class that implements [toString], [operator ==] and [hashCode].
/// IMPORTANT: use this class only for data model that does not inherit after
/// any other class than [Equatable]
@immutable
abstract class Equatable<T> {
  /// Default constructor, used by subclasses.
  @protected
  const Equatable();

  /// Returns stringified representation of the object
  /// If the object has
  /// - one field, then [T] is of type [String]
  /// - multiple fields, then [T] should be of [Map<String, dynamic>]
  T toJson();

  @override
  String toString() {
    final T result = toJson();
    if (result is String) {
      return '$runtimeType($result)';
    } else if (result is Map) {
      final fields = result.entries
          .map((entry) => '${entry.key}:${entry.value}')
          .join(',');
      return '$runtimeType($fields)';
    } else {
      return super.toString();
    }
  }

  @override
  bool operator ==(Object other) =>
      runtimeType == other.runtimeType && _equals(this, other);

  @override
  int get hashCode => _hash(this);
}

bool _equals(Equatable self, Equatable other) {
  final dynamic result = other.toJson();
  if (result is String) {
    return self.toJson() == result;
  } else if (result is Map) {
    return self.toJson().entries.every((entry) {
      return result[entry.key] is Map
          ? MapEquality().equals(result[entry.key], entry.value)
          : result[entry.key] == entry.value;
    });
  } else {
    return self == other;
  }
}

int _hash(Equatable object) {
  final dynamic result = object.toJson();
  if (result is String) {
    return result.hashCode;
  } else if (result is Map) {
    return hashObjects(result.values);
  } else {
    return result.hashCode;
  }
}

/// Generates a hash code for multiple [objects].
int hashObjects(Iterable objects) => _finish(objects.fold(0, (h, i) {
      if (i is Map) {
        return hashObjects(i.values);
      } else if (i is Iterable) {
        return hashObjects(i);
      } else {
        return _combine(h, i.hashCode);
      }
    }));

// Jenkins hash functions

int _combine(int hash, int value) {
  hash = 0x1fffffff & (hash + value);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
