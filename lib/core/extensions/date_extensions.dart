import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  // Formatting
  String get formatted => DateFormat('MMM d, yyyy').format(this);
  String get formattedWithTime => DateFormat('MMM d, yyyy • h:mm a').format(this);
  String get timeOnly => DateFormat('h:mm a').format(this);
  String get dateOnly => DateFormat('yyyy-MM-dd').format(this);
  String get dayOfWeek => DateFormat('EEEE').format(this);
  String get shortDayOfWeek => DateFormat('EEE').format(this);
  String get monthYear => DateFormat('MMMM yyyy').format(this);

  // Comparisons
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Relative time
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatted;
    }
  }

  // Greeting
  String get greeting {
    final hour = this.hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  // Start/End of day
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  // Days remaining in trial
  int daysUntil(DateTime other) {
    return other.difference(this).inDays;
  }
}
