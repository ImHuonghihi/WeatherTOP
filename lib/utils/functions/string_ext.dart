extension StringExtension on String {
  String limitLength(int maxLength) {
    if (this.length <= maxLength) {
      return this;
    } else {
      return '${this.substring(0, maxLength)}...';
    }
  }
}