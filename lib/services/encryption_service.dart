import 'dart:convert';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';

class EncryptionService {
  // Fixed key for demo purposes (32 bytes = 256 bits)
  // In production, this should be stored securely using secure storage
  // or derived from user password using PBKDF2
  static final _key = enc.Key.fromBase64('BIpD6lRGwDN5AiHcJMIHZLj4bF683LfGisFPg7kNfsM=');

  // Fixed IV for demo purposes (16 bytes = 128 bits)
  // In production, IV should be unique for each encryption and prepended to encrypted data
  static final _iv = enc.IV.fromBase64('E4aEMT2UBsIi1vgshu1ooA==');

  // AES encryption instance
  static final _encrypter = enc.Encrypter(enc.AES(_key));

  /// Encrypts plain text using AES-256-CBC
  /// [plainText] - The text to encrypt
  /// Returns encrypted text in base64 format
  static String encrypt(String plainText) {
    try {
      if (plainText.isEmpty) {
        throw ArgumentError('Plain text cannot be empty');
      }

      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      if (kDebugMode) {
        print('Encryption error: $e');
      }
      rethrow;
    }
  }

  /// Decrypts encrypted text using AES-256-CBC
  /// [encryptedText] - The base64 encrypted text to decrypt
  /// Returns decrypted plain text
  static String decrypt(String encryptedText) {
    try {
      if (encryptedText.isEmpty) {
        throw ArgumentError('Encrypted text cannot be empty');
      }

      final encrypted = enc.Encrypted.fromBase64(encryptedText);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return decrypted;
    } catch (e) {
      if (kDebugMode) {
        print('Decryption error: $e');
      }
      rethrow;
    }
  }

  /// Checks if a string is likely encrypted (base64 format)
  static bool isEncrypted(String text) {
    try {
      if (text.isEmpty) return false;
      // Try to decode as base64
      base64Decode(text);
      // Additional check: encrypted text is typically longer and has specific patterns
      return text.length > 16 && text.contains(RegExp(r'^[A-Za-z0-9+/=]+$'));
    } catch (e) {
      return false;
    }
  }
}
