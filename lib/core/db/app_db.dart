import 'package:contact_number_demo/core/locator/locator.dart';
import 'package:hive/hive.dart';
import '../../data/model/contact/contact.dart';
import '../../data/model/response/user_profile_response.dart';

class AppDB {
  static const _appDbBox = '_appDbBox'; // Name of the Hive box

  final Box<dynamic> _box;

  AppDB._(this._box);

  static Future<AppDB> getInstance() async {
    final box = await Hive.openBox<dynamic>(_appDbBox);
    return AppDB._(box);
  }

  T getValue<T>(String key, {T? defaultValue}) {
    final value = _box.get(key, defaultValue: defaultValue);
    if (value == null) {
      print('Value for $key is null, returning default value: $defaultValue');
      return defaultValue as T;
    }
    if (value is T) {
      return value;
    }
    throw TypeError();
  }

  Future<void> setValue<T>(String key, T value) async {
    await _box.put(key, value);
  }

  bool get firstTime {
    final value = getValue<bool>("firstTime", defaultValue: false);
    if (value is bool) {
      return value;
    }
    throw TypeError();
  }

  set firstTime(bool update) => setValue("firstTime", update);

  bool get isLogin {
    final value = getValue<bool>("isLogin", defaultValue: false);
    return value;
  }

  set isLogin(bool update) => setValue("isLogin", update);

  String get token => getValue<String>("token", defaultValue: "");

  set token(String update) => setValue("token", update);

  String get fcmToken => getValue<String>("fcm_token", defaultValue: "0");

  set fcmToken(String update) => setValue("fcm_token", update);

  int get cartCount {
    final value = getValue<int>("cart_count", defaultValue: 0);
    return value;
  }

  set cartCount(int update) => setValue("cart_count", update);

  String get apiKey => getValue<String>("apiKey", defaultValue: "TEST123");

  set apiKey(String update) => setValue("apiKey", update);

  UserData get user => getValue<UserData>("user");

  set user(UserData user) => setValue("user", user);

  List<ContactListModel> get contacts {
    final contacts = _box.get("contacts", defaultValue: <ContactListModel>[])
        as List<dynamic>;
    return contacts.cast<ContactListModel>();
  }

  Future<void> addContact(ContactListModel contact) async {
    final contacts = this.contacts;
    contacts.add(contact);
    await setValue("contacts", contacts);
  }

  Future<void> deleteContact(ContactListModel contact) async {
    final contacts = this.contacts;
    contacts.removeWhere((c) => c.id == contact.id);
    await setValue("contacts", contacts);
  }

  List<ContactListModel> get favorites {
    final favorites = _box.get("favorites", defaultValue: []) as List<dynamic>;
    return favorites.cast<ContactListModel>().where((c) => c.isFavorite!).toList();
  }

  Future<void> toggleFavorites(List<ContactListModel> selectedContacts) async {
    final contacts = this.contacts;
    for (var selectedContact in selectedContacts) {
      final index = contacts.indexWhere((c) => c.id == selectedContact.id);
      if (index != -1) {
        final updatedContact = contacts[index].copyWith(isFavorite: !contacts[index].isFavorite!);
        contacts[index] = updatedContact;
      }
    }
    await setValue("contacts", contacts);
  }

  Future<void> updateContactAtIndex(
      int index, ContactListModel updatedContact) async {
    final contacts = this.contacts;
    if (index >= 0 && index < contacts.length) {
      contacts[index] = updatedContact;
      await setValue(
          "contacts", contacts); // Use setValue to save the updated list
    } else {
      throw IndexError(index, contacts, 'Index out of range');
    }
  }

  void logout() {
    token = "";
    isLogin = false;
    firstTime = true;
  }
}

final appDB = locator<AppDB>();
