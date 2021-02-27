import 'dart:convert';
import 'dart:ffi';

String fromChar(Pointer<Int8> string) => utf8.decode(iterateInt8(string).toList());

Iterable<int> iterateInt8(Pointer<Int8> ptr) sync* {
  for (var i = 0; ptr[i] != 0; i++) {
    yield ptr[i];
  }
}

/// macOS: [The wchar_t type is 32 bit and is a signed type.](https://developer.apple.com/documentation/xcode/writing_arm64_code_for_apple_platforms)
/// 
/// Windows: [In the Microsoft compiler, it represents a 16-bit wide character used to store Unicode encoded as UTF-16LE, the native character type on Windows operating systems.](https://docs.microsoft.com/en-us/cpp/cpp/char-wchar-t-char16-t-char32-t)
String fromWChar(Pointer<Int32> wstring) => utf8.decode(iterateInt32(wstring).toList());

Iterable<int> iterateInt32(Pointer<Int32> ptr) sync* {
  for (var i = 0; ptr[i] != 0; i++) {
    yield ptr[i];
  }
}