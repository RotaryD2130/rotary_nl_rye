// 🎯 Dart imports:
import 'dart:async';

// 🌎 Project imports:
import 'package:rotary2130_2140_rye/core/domain/entities/exchange_student.dart';

abstract class ExchangeStudentRepository {
  Stream<List<ExchangeStudent>> get exchangeStudents;

  Future<void> dispose();
}
