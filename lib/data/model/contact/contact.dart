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

  @HiveField(5)
  final bool? isFavorite;

  ContactListModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.company,
    required this.image,
    this.isFavorite = false, // Ensure a default value
  });

  ContactListModel copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? company,
    String? image,
    bool? isFavorite,
  }) {
    return ContactListModel(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      company: company ?? this.company,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
