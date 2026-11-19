import 'package:uuid/uuid.dart';

/// Cryptographically secure and RFC 4122 compliant UUID v4 generator.
abstract class UuidUtil {
  static const Uuid _uuid = Uuid();

  /// Generates a new random v4 UUID string.
  static String generate() => _uuid.v4();

  /// Validates if a string is a valid UUID.
  static bool isValid(String uuid) {
    try {
      Uuid.parse(uuid);
      return true;
    } catch (_) {
      return false;
    }
  }
}
