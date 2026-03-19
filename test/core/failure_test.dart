import 'package:flutter_test/flutter_test.dart';
import 'package:vibemarket/core/error/failure.dart';

void main() {
  test('failure equality is value based', () {
    const left = Failure.authentication('Invalid credentials');
    const right = Failure.authentication('Invalid credentials');

    expect(left, equals(right));
    expect(left.type, FailureType.authentication);
  });
}
