extension StringExtensions on String {
  // Validation
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isValidPassword {
    return length >= 8;
  }

  bool get isValidName {
    return length >= 2 && RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);
  }

  // Formatting
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  // Truncation
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  // Initials
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(' ');
    if (words.length == 1) {
      return words.first[0].toUpperCase();
    }
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}
