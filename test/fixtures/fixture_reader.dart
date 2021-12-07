import 'dart:io';
// String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

String fixture(String name) {
  Directory current = Directory.current;
  return File('./test/fixtures/$name').readAsStringSync();
}
