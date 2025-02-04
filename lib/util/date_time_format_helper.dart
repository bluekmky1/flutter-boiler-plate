class DateTimeFormatter {
  static String getFormattedDateTimeString(DateTime dateTime) {
    final String formattedDateTime =
        // ignore:lines_longer_than_80_chars
        '${dateTime.year}.${_twoDigitFormat(dateTime.month)}.${_twoDigitFormat(dateTime.day)} ${_twoDigitFormat(dateTime.hour)}:${_twoDigitFormat(dateTime.minute)}';
    return formattedDateTime;
  }

  // static String getDateUsingSlash({required DateTime dateTime}) {
  //   final String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  //   return formattedDate;
  // }

  static String _twoDigitFormat(int number) =>
      number.toString().padLeft(2, '0');

  // 2024.12.12 형식
  static String getFormattedDateTime(DateTime dateTime) {
    final String formattedDateTime =
        // ignore:lines_longer_than_80_chars
        '${dateTime.year}.${_twoDigitFormat(dateTime.month)}.${_twoDigitFormat(dateTime.day)}';
    return formattedDateTime;
  }

  static String getNumburicDateTime(DateTime dateTime) {
    final String formattedDateTime =
        // ignore:lines_longer_than_80_chars
        '${dateTime.year}${_twoDigitFormat(dateTime.month)}${_twoDigitFormat(dateTime.day)}${_twoDigitFormat(dateTime.hour)}${_twoDigitFormat(dateTime.minute)}';
    return formattedDateTime;
  }

  static String getDateAndTime(DateTime dateTime) => '${<String>[
        dateTime.year.toString().substring(2, 4),
        _twoDigitFormat(dateTime.month),
        _twoDigitFormat(dateTime.day),
      ].join('.')} ${getSimpleTimeString(dateTime)}';

  static String getSimpleTimeString(DateTime dateTime) {
    final String formattedTime =
        '${_twoDigitFormat(dateTime.hour)}:${_twoDigitFormat(dateTime.minute)}';
    return formattedTime;
  }

  static String getDateRangeString(DateTime start, DateTime end) =>
      '${start.toString().split(' ')[0]} ~ ${end.toString().split(' ')[0]}';
}
