import 'package:shared_preferences/shared_preferences.dart';

// セキュリティは気にせずに永続化をする
class MnemonicStore {
  final _key = "wallet-mnemonic-key";

  static final MnemonicStore _singleton = MnemonicStore._internal();

  factory MnemonicStore() {
    return _singleton;
  }

  MnemonicStore._internal();

  Future<String?> getItem() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  Future<void> setItem(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value);
  }

  Future<void> deleteItem() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
