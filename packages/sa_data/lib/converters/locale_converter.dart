import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// JSON converter for [Locale] objects.
class SLocaleConverter implements JsonConverter<Locale, String> {
  /// Create a new [SLocaleConverter].
  const SLocaleConverter();

  @override
  Locale fromJson(String json) {
    final parts = json.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }

  @override
  String toJson(Locale object) => object.toString();
}
