extension StringX on String {
  ///Returns first letter of the string as Caps eg -> Flutter
  String firstLetterUpperCase() => length > 1
      ? "${this[0].toUpperCase()}${substring(1).toLowerCase()}"
      : this;

  /// Return a bool if the string is null or empty
  bool get isEmptyOrNull => isEmpty;

  /// Returns the string if it is not `null`, or the empty string otherwise
  String get orEmpty => this;

  String? toPascalCase() {
    if (isNotEmpty) {
      return substring(0, 1).toUpperCase() + substring(1);
    } else {
      return this;
    }
  }
}
