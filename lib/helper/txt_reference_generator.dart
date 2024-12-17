import 'dart:math';

String generateTransactionReference() {
  const length = 34;
  const charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random.secure();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => charset.codeUnitAt(random.nextInt(charset.length))));

  final firstPart = getRandomString(length);

  final finalPart = getRandomString(length);

  return firstPart + finalPart;
}
