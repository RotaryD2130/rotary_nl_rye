// 🎯 Dart imports:
import 'dart:async';

// 🌎 Project imports:
import 'package:rotary2130_2140_rye/core/domain/entities/exchange_student.dart';
import 'package:rotary2130_2140_rye/core/domain/entities/story.dart';

abstract class StoriesRepository {
  Stream<List<Story>> getStoriesOf(ExchangeStudent exchangeStudent);

  Future<void> dispose();
}
