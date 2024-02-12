// 🎯 Dart imports:
import 'dart:async';

// 🌎 Project imports:
import 'package:rotary2130_2140_rye/core/domain/entities/news.dart';

abstract class NewsRepository {
  Stream<List<News>> get news;

  Future<void> dispose();
}
