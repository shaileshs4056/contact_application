import 'package:hive/hive.dart';
part 'contact.g.dart';

@HiveType(typeId: 0)
class ContactListModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? firstname;

  @HiveField(2)
  final String? lastname;

  @HiveField(3)
  final String? company;

  @HiveField(4)
  final String? image;

  ContactListModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.company,
    required this.image,
  });
}
