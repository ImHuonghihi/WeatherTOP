// convert number type to number type
T convertNumber<T>(dynamic number) {
  if (number is T) {
    return number;
  }
  if (T == int) {
    return int.parse(number.toString().split(".").first) as T;
  }
  if (T == double) {
    return double.parse(number.toString()) as T;
  }
  if (T == num) {
    return num.parse(number.toString()) as T;
  }
  return number as T;
}