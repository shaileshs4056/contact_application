import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:contact_number_demo/ui/auth/store/auth_store.dart';
import 'package:flutter/services.dart';
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




class _ShowContactListPageState extends State<ShowContactListPage> {
  late TextEditingController searchController;
  late List<ContactListModel> _searchResult = [];



  @override
  void initState() {
    searchController = TextEditingController();
    // Sync scroll controller 1 with controller 2
    authStore.loadContacts();
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
        authStore.groupedContacts = groupContactsByLetter(appDB.contacts);
        return;
      }

      appDB.contacts.forEach((userDetail) {
        if (userDetail.firstname!.toLowerCase().contains(text.toLowerCase()) ||
            userDetail.lastname!.toLowerCase().contains(text.toLowerCase())) {
          _searchResult.add(userDetail);
        }
      });

      authStore.groupedContacts = groupContactsByLetter(_searchResult);
    });
  }

  void onLongPressContact(bool ischeck) {
    setState(() {
      _value = !ischeck;
    });
  }
  bool isChecked(ContactListModel contact) {
    setState(() {
    });
    print('Current selectedContacts: $authStore.selectedContacts');
    if (authStore.selectedContacts.contains(contact)) {
      return authStore.selectedContacts.remove(contact);
    } else {
      return authStore.selectedContacts.add(contact);
    }
    setState(() {

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
    showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit'),
          content: Text('Selected item delected successfully '),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false if the user cancels
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true if the user confirms
              },
            ),
          ],
        );
      },
    );
    setState(() {
      authStore.selectedFavorite.clear();
      _value = false;
      authStore.groupedContacts = groupContactsByLetter(contacts);
    });
  }

  // Future<void> _addfavorite() async {
  //   final contacts = appDB.contacts;

  //   // Add selected contacts to the _favoriteContacts list
  //   _favoriteContacts.addAll(authStore.selectedContacts
  //       .where((contact) => !_favoriteContacts.contains(contact)));

  //   // Save the updated contacts list to the database
  //   await appDB.setValue("contacts", contacts);
  //   authStore.selectedContacts.clear();
  //   _value = false;
  //   setState(() {
  //     // Clear the selected contacts and refresh the grouped contacts
  //     authStore.selectedFavorite.clear();

  //     groupedContacts = groupContactsByLetter(contacts);
  //   });
  // }


  void onFavoriteToggle() async {
    // Convert the selected contacts to a list
    final selectedContactsList = authStore.selectedContacts.toList();

    if (selectedContactsList.isEmpty) {
      print("No contacts selected.");
      return; // Exit if no contacts are selected
    }

    print("Selected Contacts Before Toggle:");
    for (var contact in selectedContactsList) {
      print(contact.id);
      print(
          "${contact.firstname} ${contact.lastname}: isFavorite = ${contact.isFavorite}");
    }

    // Call the method to toggle the favorite status in the database
    await appDB.toggleFavorites(selectedContactsList);
    // Print the status after toggling
    print("Selected Contacts After Toggle:");
    for (var contact in selectedContactsList) {
      print(
          "${contact.firstname} ${contact.lastname}: isFavorite = ${contact.isFavorite}");
    }
    authStore.loadContacts();

    // Clear the selection after updating
    authStore.selectedContacts.clear();
    authStore.loadContacts();
    setState(() {

    });
      print("UI updated");
  }

  Future<bool> _showExitConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit'),
          content: Text('Are you sure you want to exit the application?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false if the user cancels
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true if the user confirms
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value ?? false) {
        SystemNavigator.pop(); // Exit the application
      }
      return value ?? false;
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
          leadingWidth: 70,
          leading: TextButton.icon(
            onPressed: () async {
              if (appRouter.canPop()) {
                // If there are routes to pop, pop the route
                appRouter.pop();
              } else {
                // If there are no routes to pop, show the exit confirmation dialog
                bool shouldExit = await _showExitConfirmationDialog();
                if (shouldExit) {
                  // Handle the app exit logic here if needed
                  // You might want to use SystemNavigator.pop() for exiting the app
                  SystemNavigator.pop(); // This line exits the app on Android
                }
              }
            },
            label: Text(
              "List",
              style: textRegular.copyWith(color: AppColor.blueDiamond),
            ),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.blueDiamond,
              size: 20,
            ),
          ),
          scrolledUnderElevation: 0,
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
                      Icons.delete,
                      color: AppColor.red,
                    ),
                  ).wrapPaddingOnly(right: 15.w),
                ),
                Visibility(
                  visible: _value,
                  child: InkWell(
                    onTap: () {
                      onFavoriteToggle()
                      // _addfavorite();
                          ;
                    },
                    child: Icon(
                      Icons.favorite,
                      color: AppColor.red,
                    ),
                  ).wrapPaddingOnly(right: 15.w),
                ),
                InkWell(
                  onTap: () {
                    appRouter.push(AddContactNumberRoute()).then((value) {
                      return authStore.loadContacts();
                    },);
                    // appRouter.replaceAll([AddContactNumberRoute()]);
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
        body: SingleChildScrollView(
          child: Observer(builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Text(
                    "Favorite",
                    style: textBold.copyWith(
                        color: AppColor.black, fontSize: 15.spMin),
                  ),
                ),
                Divider(
                  color: AppColor.black,
                  height: 0,
                ),
                // Flatten and filter the contacts to get only the favorites

                Observer(
                  builder: (context) {
                    return Wrap(
                      children: List.generate(
                        authStore.favoriteContacts.length,
                            (index) {
                          final data = authStore.favoriteContacts[index];
                          final name = data.firstname;
                          final lastName = data.lastname;
                          final image = data.image;
                          final isFav = data.isFavorite;

                          return authStore.favoriteContacts.isEmpty
                              ? SizedBox.shrink()
                              : Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: image != null &&
                                    image.isNotEmpty
                                    ? FileImage(File(image))
                                    : null, // Handle null or empty image paths
                              ).wrapPaddingBottom(5.h),
                              Text(name ??
                                  'No Name'), // Provide a default value if `name` is null
                              Text(isFav.toString())
                            ],
                          ).wrapPaddingSymmetric(
                            horizontal: 15.w,
                            vertical: 15.h,
                          );
                        },
                      ),
                    );
                  }
                ),

                Divider(
                  color: AppColor.black,
                  height: 0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w, top: 15.h),
                  child: Text(
                    "Contacts",
                    style: textBold.copyWith(
                        color: AppColor.black, fontSize: 16.spMin),
                  ),
                ),
                // Flexible(child: _buildFavouriteContact()),
                // _buildContactSection(),
                _buildContactList()

                // _buildFavouriteContact(),
                // _buildContactList(),
              ],
            );
          }),
        ));
  }

  /// contact section

  Widget _buildContactList() {
    return Observer(builder: (_) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: authStore.groupedContacts.length,
        itemBuilder: (context, index) {
          final letter = authStore.groupedContacts.keys.elementAt(index);
          final contactList = authStore.groupedContacts[letter]!;
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
                bool _isfavorite = authStore.selectedFavorite.contains(contact);

                return GestureDetector(
                  onLongPress: () {
                    onLongPressContact(_value);
                  },
                  onTap: () {
                    appRouter.replaceAll([DeleteEditRoute(id: contact.id!)]);
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
                            style: textMedium.copyWith(color: AppColor.grey),
                          ),
                          Text(
                            "${contact.isFavorite} ",
                            style: textMedium.copyWith(color: AppColor.grey),
                          ),
                          Text(contact.lastname!, style: textMedium),
                          Spacer(),
                            SizedBox(width: 10),
                          if (isSelected)
                            Observer(builder: (_) {
                              var isChecked =
                              authStore.selectedContacts.contains(contact);

                              return GestureDetector(
                                onTap: () {
                                  authStore.isChecked(contact);
                                  setState(() {});
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
                                    color: isChecked
                                        ? Colors.blue
                                        : AppColor.transparent,
                                  ),
                                  child: isChecked
                                      ? Icon(Icons.check,
                                      size: 15.0, color: Colors.white)
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
    });
  }
}