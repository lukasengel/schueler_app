import 'package:dartz/dartz.dart';

/// Extension for [Either] from the `dartz` package.
extension SEitherExtension<L, R> on Either<L, R> {
  /// Returns the right value brute-forcefully.
  ///
  /// Will fail if not a right value!
  R forceRight() {
    return fold(
      (l) => throw Exception('Expected right, but got left: $l'),
      (r) => r,
    );
  }

  /// Returns the left value brute-forcefully.
  ///
  /// Will fail if not a left value!
  L forceLeft() {
    return fold(
      (l) => l,
      (r) => throw Exception('Expected left, but got right: $r'),
    );
  }
}
