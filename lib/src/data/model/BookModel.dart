class BookModel {
  int id;
  String name;
  String author;

  BookModel({
    this.id,
    this.name,
    this.author,
  });

  factory BookModel.fromMap(Map<String, dynamic> map) => BookModel(
      id: map["id"],
      name: map["name"],
      author: map["author"]);

  Map<String, dynamic> toMap() =>
      {"id": id, "name": name, "author": author};
}
