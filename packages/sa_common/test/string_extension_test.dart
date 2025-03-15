import 'package:sa_common/sa_common.dart';
import 'package:test/test.dart';

void main() {
  test("Test 'isBlank' and 'isNotBlank'", () {
    expect(''.isBlank, true);
    expect(' \t'.isBlank, true);
    expect(''.isNotBlank, false);
    expect(' \t'.isNotBlank, false);
    expect('a'.isBlank, false);
    expect('a'.isNotBlank, true);
    expect(' a\t'.isBlank, false);
    expect(' a\t'.isNotBlank, true);
  });

  test("Test 'trimOrNull'", () {
    expect(''.trimOrNull(), null);
    expect(' \t'.trimOrNull(), null);
    expect('a'.trimOrNull(), 'a');
    expect(' a\t'.trimOrNull(), 'a');
  });

  test("Test 'hasContent' and 'hasNoContent'", () {
    expect(''.hasContent, false);
    expect(' \t'.hasContent, false);
    expect('a'.hasContent, true);
    expect(' a\t'.hasContent, true);
    expect(''.hasNoContent, true);
    expect(' \t'.hasNoContent, true);
    expect('a'.hasNoContent, false);
    expect(' a\t'.hasNoContent, false);
  });
}
