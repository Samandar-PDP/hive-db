import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 1)
class Books {
  Books({this.id,this.bookTitle,this.bookAuthor});
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? bookTitle;

  @HiveField(2)
  String? bookAuthor;
}