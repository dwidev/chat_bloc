import 'dart:convert';

import 'package:encrypt/encrypt.dart';

String encryptToAes64({
  required String key,
  required String value,
}) {
  final key64 = base64Encode(key.codeUnits);
  final aesKey = Key.fromBase64(key64);
  final encrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));

  final iv = IV.fromLength(16);

  final encrypted = encrypter.encrypt(value, iv: iv);
  final valueEncrypted = encrypted.base64;
  final iv64 = base64Encode(iv.bytes);
  final encryptRes = "$iv64:$valueEncrypted";
  return encryptRes;
}

String decryptFromAes64({
  required String key,
  required String encrypted64,
}) {
  final key64 = base64Encode(key.codeUnits);
  final aesKey = Key.fromBase64(key64);
  final encrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));

  final split = encrypted64.split(":");
  final iv64 = split[0];
  final base64EncryptedText = split[1];

  final iv = IV.fromBase64(iv64);
  final decrypted = encrypter.decrypt64(base64EncryptedText, iv: iv);

  return decrypted;
}
