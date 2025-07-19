/// Example (1) Extension for String
extension StringExtension on String? {
bool isNullOrEmpty() => this == null || this ==" " || this!.isEmpty;
}

extension ListExtension<T> on List<T>? {
bool isNullOrEmpty() => this == null || this!.isEmpty;
}

