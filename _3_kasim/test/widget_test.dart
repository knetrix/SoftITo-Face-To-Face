import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:_3_kasim/main.dart';

void main() {
  test('FirebaseApp is a widget', () {
    expect(const FirebaseApp(), isA<StatelessWidget>());
  });
}
