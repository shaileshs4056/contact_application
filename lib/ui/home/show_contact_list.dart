import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:contact_number_demo/ui/auth/store/auth_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../core/db/app_db.dart';
import '../../data/model/contact/contact.dart';
import 'package:contact_number_demo/router/app_router.dart';
import 'package:contact_number_demo/values/export.dart';
import 'package:contact_number_demo/values/extensions/widget_ext.dart';
import 'package:contact_number_demo/widget/app_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Map<String, List<ContactListModel>> groupContactsByLetter(
    List<ContactListModel> contacts) {
  final Map<String, List<ContactListModel>> groupedContacts = {};

  for (var contact in contacts) {
    final firstLetter = contact.firstname!.isNotEmpty
        ? contact.firstname![0].toUpperCase()
        : '#';
    if (!groupedContacts.containsKey(firstLetter)) {
      groupedContacts[firstLetter] = [];
    }
    groupedContacts[firstLetter]!.add(contact);
  }

  // Optionally, sort the map by key (A to Z)
  final sortedKeys = groupedContacts.keys.toList()..sort();
  final sortedGroupedContacts = {
    for (var key in sortedKeys) key: groupedContacts[key]!
  };

  return sortedGroupedContacts;
}

@RoutePage()
class ShowContactListPage extends StatefulWidget {
  @override
  State<ShowContactListPage> createState() => _ShowContactListPageState();
}

late Map<String, List<ContactListModel>> groupedContacts;

class _ShowContactListPageState extends State<ShowContactListPage> {
  late TextEditingController searchController;
  List<ContactListModel> _searchResult = [];

  Future<void> _loadContacts() async {
    final contacts = appDB.contacts;
    setState(() {
      groupedContacts = groupContactsByLetter(contacts);
    });
  }

  @override
  void initState() {
    searchController = TextEditingController();
    _loadContacts();
    _loadFavoriteContacts();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  onSearchTextChanged(String? text) {
    setState(() {
      _searchResult.clear();
      if (text == null || text.isEmpty) {
        groupedContacts = groupContactsByLetter(appDB.contacts);
        return;
      }

      appDB.contacts.forEach((userDetail) {
        if (userDetail.firstname!.toLowerCase().contains(text.toLowerCase()) ||
            userDetail.lastname!.toLowerCase().contains(text.toLowerCase())) {
          _searchResult.add(userDetail);
        }
      });

      groupedContacts = groupContactsByLetter(_searchResult);
    });
  }

  void onLongPressContact(bool ischeck) {
    setState(() {
      _value = !ischeck;
    });
  }

  void isCheck(ContactListModel contact) {
    setState(() {
      if (authStore.selectedContacts.contains(contact)) {
        authStore.selectedContacts.remove(contact);
      } else {
        authStore.selectedContacts.add(contact);
      }
    });
  }

  void isfavorite(ContactListModel contact) {
    setState(() {
      if (authStore.selectedFavorite.contains(contact)) {
        authStore.selectedFavorite.remove(contact);
      } else {
        authStore.selectedFavorite.add(contact);
      }
    });
  }

  void toggleAllFavorites() {
    setState(() {
      if (authStore.selectedFavorite.length == appDB.contacts.length) {
        // If all contacts are already favorites, clear the selection
        authStore.selectedFavorite.clear();
      } else {
        // Otherwise, add all contacts to the favorites
        authStore.selectedFavorite.addAll(appDB.contacts);
      }
    });
  }

  void selectAll() {
    setState(() {
      if (authStore.selectedContacts.length == appDB.contacts.length) {
        // If all contacts are already favorites, clear the selection
        authStore.selectedContacts.clear();
      } else {
        // Otherwise, add all contacts to the favorites
        authStore.selectedContacts.addAll(appDB.contacts);
      }
    });
  }

  Future<void> _deleteSelectedContacts() async {
    final contacts = appDB.contacts;
    contacts
        .removeWhere((contact) => authStore.selectedContacts.contains(contact));
    await appDB.setValue("contacts", contacts);
    setState(() {
      authStore.selectedFavorite.clear();
      groupedContacts = groupContactsByLetter(contacts);
    });
  }

  Future<void> _addFavoriteSelectedContacts() async {
    final selectedContacts =
        authStore.selectedContacts.toList(); // Convert to List if it's not

    // Add the list of selected contacts to favorites
    await appDB.addFavorites(selectedContacts);

    // Clear selected contacts in MobX
    authStore.selectedContacts.clear();

    // Refresh the favorite contacts list and the grouped contacts
    await _loadFavoriteContacts();
    await _loadContacts();
  }

  Future<List<ContactListModel>> getFavoriteContacts() async {
    final contacts = appDB.favorites;
    return contacts;
  }

  late List<ContactListModel> _favoriteContacts;
  Future<void> _loadFavoriteContacts() async {
    final contacts = await getFavoriteContacts();
    setState(() {
      _favoriteContacts = contacts;
    });
  }

  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: AppColor.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    appRouter.pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 15,
                    color: AppColor.blueDiamond,
                  ),
                ),
                5.horizontalSpace,
                Text(
                  "List",
                  style: textRegular.copyWith(color: AppColor.blueDiamond),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Visibility(
                  visible: _value,
                  child: InkWell(
                      onTap: () {
                        selectAll();
                      },
                      child: Text(
                        "Select all",
                        style: textRegular.copyWith(
                            color: AppColor.blueDiamond, fontSize: 15.spMin),
                      )).wrapPaddingOnly(right: 15.w),
                ),
                Visibility(
                  visible: _value,
                  child: InkWell(
                    onTap: () {
                      _deleteSelectedContacts();
                    },
                    child: Icon(
                      Icons.delete_outline_outlined,
                      color: AppColor.blueDiamond,
                    ),
                  ).wrapPaddingOnly(right: 15.w),
                ),
                Visibility(
                  visible: _value,
                  child: InkWell(
                    onTap: () {
                      _addFavoriteSelectedContacts();
                    },
                    child: Icon(
                      Icons.favorite_border_outlined,
                      color: AppColor.blueDiamond,
                    ),
                  ).wrapPaddingOnly(right: 15.w),
                ),
                InkWell(
                  onTap: () {
                    appRouter.replaceAll([AddContactNumberRoute()]);
                  },
                  child: Icon(
                    Icons.add,
                    color: AppColor.blueDiamond,
                  ),
                ).wrapPaddingOnly(right: 15.w),
              ],
            ),
          ],
        ),
        body: Observer(builder: (_) {
          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Contacts",
                    style: textBold.copyWith(fontSize: 25.spMin),
                  ),
                  10.0.verticalSpace,
                  AppTextField(
                    controller: searchController,
                    contentPadding: EdgeInsets.all(10),
                    label: "",
                    hint: "Search",
                    onChanged: onSearchTextChanged,
                    validators: passwordValidator,
                    keyboardType: TextInputType.visiblePassword,
                    keyboardAction: TextInputAction.done,
                    maxLength: 15,
                    filled: true,
                    suffixIcon: Align(
                      alignment: Alignment.centerRight,
                      heightFactor: 1.0,
                      widthFactor: 1.0,
                      child: GestureDetector(
                        onTap: () => Future.delayed(Duration.zero, () {}),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.keyboard_voice_rounded,
                            color: AppColor.grey,
                          ),
                        ),
                      ),
                    ),
                    prefixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.search_outlined,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ).wrapPaddingSymmetric(horizontal: 15.w),
              20.verticalSpace,
              _favoriteContacts.isEmpty
                  ? Center(child: Text('No favorites yet'))
                  : ListView.builder(
                      itemCount: _favoriteContacts.length,
                      itemBuilder: (context, index) {
                        final contact = _favoriteContacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(File(contact.image!)),
                          ),
                          title:
                              Text('${contact.firstname} ${contact.lastname}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Implement remove from favorites
                              appDB.removeFavorite(contact);
                              _loadFavoriteContacts(); // Refresh the list
                            },
                          ),
                        );
                      },
                    ),
              Expanded(
                child: Observer(builder: (_) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: groupedContacts.length,
                    itemBuilder: (context, index) {
                      final letter = groupedContacts.keys.elementAt(index);
                      final contactList = groupedContacts[letter]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the letter as a section header
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              letter,
                              style: textRegular.copyWith(color: AppColor.grey),
                            ),
                          ),
                          // Display the contacts for this letter
                          ...contactList.map((contact) {
                            bool isSelected = _value;

                            // bool ischeck =
                            //     authStore.selectedContacts.contains(contact);

                            bool _isfavorite =
                                authStore.selectedFavorite.contains(contact);

                            return InkWell(
                              onLongPress: () {
                                onLongPressContact(_value);
                              },
                              onTap: () {
                                // appRouter
                                //     .replaceAll([DeleteEditRoute(id: index)]);
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                          File(contact.image!),
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "${contact.firstname} ",
                                        style: textMedium.copyWith(
                                            color: AppColor.grey),
                                      ),
                                      Text(contact.lastname!,
                                          style: textMedium),
                                      Spacer(),
                                      if (isSelected)
                                        InkWell(
                                          onTap: () {
                                            isfavorite(contact);
                                          },
                                          child: Container(
                                            child: _isfavorite
                                                ? Icon(Icons.favorite,
                                                    size: 20.0,
                                                    color: Colors.red)
                                                : Icon(Icons.favorite,
                                                    size: 20.0,
                                                    color: Colors.grey),
                                          ),
                                        ),
                                      10.horizontalSpace,
                                      if (isSelected)
                                        Observer(builder: (_) {
                                          var isChecked = authStore
                                              .selectedContacts
                                              .contains(contact);

                                          return InkWell(
                                            onTap: () {
                                              authStore.isChecked(contact);
                                              setState(() {});
                                              print(authStore.selectedContacts
                                                  .contains(contact));
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: AppColor.blueDiamond,
                                                ),
                                                shape: BoxShape.circle,
                                                color: authStore
                                                        .selectedContacts
                                                        .contains(contact)
                                                    ? Colors.blue
                                                    : AppColor.transparent,
                                              ),
                                              child: authStore.selectedContacts
                                                      .contains(contact)
                                                  ? Icon(
                                                      Icons.check,
                                                      size: 15.0,
                                                      color: Colors.white,
                                                    )
                                                  : null,
                                            ),
                                          );
                                        }),
                                    ],
                                  ).wrapPaddingSymmetric(vertical: 8),
                                  Divider(),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ).wrapPaddingSymmetric(horizontal: 15.w);
                    },
                  );
                }),
              ),
            ],
          );
        }));
  }
}
