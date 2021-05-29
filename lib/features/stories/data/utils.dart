import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rotary_nl_rye/features/stories/models/exchange_student.dart';
import 'package:rotary_nl_rye/features/stories/models/story.dart';

Future getDataStories(String url) async {
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  } catch (e) {
    print(e);
    throw 'unable to fetch stories json';
  }
  var data = json.decode(response.body);
  List<Story> stories = StoryResult.fromJson(data).stories;
  return stories;
}

Future getDataStudents(String url) async {
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  } catch (e) {
    print(e);
    throw 'unable to fetch stories json';
  }
  var data = json.decode(response.body);
  List<ExchangeStudent> students = ExchangeResult.fromJson(data).students;
  return students;
}
