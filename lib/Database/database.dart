import 'package:hive_flutter/hive_flutter.dart';

class Database {
  List expenses = [];
  int balance = 0;

  final mybox = Hive.box('mybox');

  void load() {
    expenses = mybox.get("list");
    balance = mybox.get("bal");
  }

  void update() {
    mybox.put("list", expenses);
    mybox.put("bal", balance);
  }
}
