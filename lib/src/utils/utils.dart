import 'package:flutter_calendar_week/src/models/week_item.dart';
import 'package:flutter_calendar_week/src/strings.dart';

/// Compare dates, return a bool value. [True] is same date or [false] else
bool compareDate(DateTime? dateA, DateTime? dateB) {
  if (dateA?.day == dateB?.day && dateA?.month == dateB?.month && dateA?.year == dateB?.year) {
    return true;
  }
  return false;
}

/// [findCurrentWeekIndexByDate] return -1 when cannot match
int findCurrentWeekIndexByDate(DateTime dateTime, List<WeekItem> weeks) {
  int index = -1;
  bool matched = false;
  for (int i = 0; i < weeks.length; i++) {
    index++;
    for (int j = 0; j < weeks[i].days.length; j++) {
      if (compareDate(dateTime, weeks[i].days[j])) {
        matched = true;
        break;
      }
    }
    if (matched) {
      break;
    }
  }

  return matched ? index : -1;
}

/// [firstDayOfWeek] return firstWeekday of the same week as provided date
firstDayOfWeek(DateTime date) {
  var day = DateTime.utc(date.year, date.month, date.day, 12);
  day = day.subtract(Duration(days: day.weekday - 1));
  return day;
}

/// Read from [minDate] to [maxDate] and separate weeks.
/// Return [List] contain weeks;
List<WeekItem> separateWeeks(DateTime minDate, DateTime maxDate, List<String> dayOfWeek, List<String> _months) {
  /// Count until length day of week
  int count = 1;

  /// List contain day Of Week
  final List<String> _dayOfWeek = [];

  /// List contain day
  final List<DateTime> _days = [];

  /// List contain weeks
  final List<WeekItem> _weeks = [];

  /// Clone [minDate] object
  DateTime minDateCloned = firstDayOfWeek(minDate);

  /// Read from [minDate] to [maxDate]
  while (minDateCloned.compareTo(maxDate) < 1) {
    /// If in week
    if (count < maxDayOfWeek) {
      /// Add day of week to list day of week
      _dayOfWeek.add(dayOfWeek[minDateCloned.weekday - 1]);

      /// Add day of week to list days
      _days.add(minDateCloned);
      count++;
    }

    /// If is last day of week, add list day of week and list day to a week.
    /// Then add the week to list weeks
    else if (count == maxDayOfWeek) {
      /// Reset count
      count = 1;

      /// Add last day of week to list day of week
      _dayOfWeek.add(dayOfWeek[minDateCloned.weekday - 1]);

      /// Add last day to list days
      _days.add(minDateCloned);

      /// Add the week to list week
      _weeks.add(
          WeekItem(month: _months[minDateCloned.month - 1], dayOfWeek: List.from(_dayOfWeek), days: List.from(_days)));

      /// Clear list before add new item
      _dayOfWeek.clear();
      _days.clear();
    }

    /// Push a next day
    minDateCloned = minDateCloned.add(Duration(days: 1));
  }

  /// If [while] about is not end with last day of week, add items less
  if (count > 1) {
    _weeks.add(WeekItem(month: _months[_days[0].month - 1], dayOfWeek: List.from(_dayOfWeek), days: List.from(_days)));
    _dayOfWeek.clear();
    _days.clear();
  }

  /// Fit day to list week
  if (_weeks.isNotEmpty && _weeks[_weeks.length - 1].dayOfWeek.length < maxDayOfWeek) {
    for (int i = 0; i < maxDayOfWeek; i++) {
      if (i > _weeks[_weeks.length - 1].dayOfWeek.length - 1) {
        _weeks[_weeks.length - 1].dayOfWeek.add(dayOfWeek[i]);
        _weeks[_weeks.length - 1].days.add(null);
      }
    }
  }
  return _weeks;
}
