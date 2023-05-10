import 'dart:convert';

import 'package:hd_wallet_flutter/model/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

// セキュリティは気にせずに永続化をする
class AccountListStore {
  final _key = "wallet-account-list-key";

  static final AccountListStore _singleton = AccountListStore._internal();

  factory AccountListStore() {
    return _singleton;
  }

  AccountListStore._internal();

  Future<List<Account>?> getItem() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) {
      return null;
    }

    return (json.decode(raw) as List)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => Account.decode(e))
        .toList();
  }

  Future<void> setItem(List<Account> value) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(value.map((e) => e.encode()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<void> deleteItem() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

// セキュリティは気にせずに永続化をする
class ExternalAccountListStore {
  final _key = "wallet-external-account-list-key";

  static final ExternalAccountListStore _singleton =
      ExternalAccountListStore._internal();

  factory ExternalAccountListStore() {
    return _singleton;
  }

  ExternalAccountListStore._internal();

  Future<List<Account>?> getItem() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) {
      return null;
    }

    return (json.decode(raw) as List)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => Account.decode(e))
        .toList();
  }

  Future<void> setItem(List<Account> value) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(value.map((e) => e.encode()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<void> deleteItem() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

// セキュリティは気にせずに永続化をする
class PrimaryAccountStore {
  final _key = "wallet-primary-account-key";

  static final PrimaryAccountStore _singleton = PrimaryAccountStore._internal();

  factory PrimaryAccountStore() {
    return _singleton;
  }

  PrimaryAccountStore._internal();

  Future<Account?> getItem() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) {
      return null;
    }

    Map<String, dynamic> decoded = json.decode(raw);
    return Account.decode(decoded);
  }

  Future<void> setItem(Account value) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(value.encode());
    await prefs.setString(_key, encoded);
  }

  Future<void> deleteItem() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
