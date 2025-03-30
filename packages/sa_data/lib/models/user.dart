import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Possible user privileges.
///
/// Higher privilege levels automatically include all lower-level privileges.
enum SUserPrivileges {
  /// Basic access to the app.
  STUDENT,

  /// Access to the app's management panel.
  MANAGER,

  /// Access to the app's administrative panel.
  ADMIN,
}

/// Type to represent a user of the app.
@freezed
class SUser with _$SUser {
  /// Create a new [SUser].
  const factory SUser({
    /// The display name of the user.
    required String displayName,

    /// THe privileges of the user.
    required SUserPrivileges privileges,
  }) = _SUser;

  /// Create a new [SUser] from a JSON object.
  factory SUser.fromJson(Map<String, dynamic> json) => _$SUserFromJson(json);
}
