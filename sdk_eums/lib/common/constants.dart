import 'package:intl/intl.dart';

class Constants {
  static const String baseUrl = 'http://43.201.230.252:3000/api/v1/';
  static const String baseUrlImage =
      'https://abee997.co.kr/web/uploads/sponsor/';
  static const int connectTimeout = 10000; // 10 seconds
  static const int receiveTimeout = 10000; // 10 seconds
  static const bool loggingInterceptorEnabled = true;
 static const int LIMIT_DATA = 10;

  static const String showDataAdver = 'showDataAdver';

  static String formatMoney(dynamic number, {String suffix = "원"}) {
    final oCcy = NumberFormat("#,##0", "en-US");
    return oCcy.format(number) + suffix;
  }

  static String formatTime(time) {
    DateTime parseDt = DateTime.parse(time);
    String dataFormat = DateFormat('yyyy.MM.dd').format(parseDt);
    return dataFormat.toString();
  }

  static String formatTimeDay(time) {
    DateTime parseDt = DateTime.parse(time);
    String dataFormat = DateFormat('yyyy.MM.dd HH:mm').format(parseDt);
    return dataFormat.toString();
  }
}

const DATA_MEDIA = [
  {"media": "highest_reward", "name": "캐시높은 순"},
  {"media": "lowest_reward", "name": "캐시적은 순"},
  {"media": "lastest", "name": "최신순"},
];

const SCRAP_MEDIA = [
  {"media": "DATE_ASC", "name": "날짜 오름차순"},
  {"media": "DATE_DESC", "name": "날짜 내림차순"},
  {"media": "LIKE", "name": "좋아요"},
];

const QUESTION_LIST = [
  {"media": "point", "name": "포인트"},
  {"media": "inquire", "name": "문의"},
];
