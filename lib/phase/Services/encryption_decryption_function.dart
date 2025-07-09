import 'dart:convert';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

String encodeFunction(String input) {
  int modFactor = 100;
  Uint8List encodedBytes = utf8.encode(input);

  // Apply modulo offset to the base64 encoded bytes
  for (int i = 0; i < encodedBytes.length; i++) {
    encodedBytes[i] = (encodedBytes[i] + ((i + 1) % modFactor)) % 256;
  }
  // Encode using base64
  String encodedString = base64Encode(encodedBytes);
  return encodedString;
}
String decodeFunction(String encodedString) {
  int modFactor = 100;

  // Decode the base64 string to get the bytes
  Uint8List encodedBytes = base64Decode(encodedString);

  // Reverse the modulo offset applied during encoding
  for (int i = 0; i < encodedBytes.length; i++) {
    encodedBytes[i] = (encodedBytes[i] - ((i + 1) % modFactor) + 256) % 256;
  }

  // Decode the UTF-8 bytes to get the original string
  String decodedString = utf8.decode(encodedBytes);
  return decodedString;
}