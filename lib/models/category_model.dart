class CategoryModel {
  String categoryId;
  String name;
  String imageUrl;

  CategoryModel({
    required this.categoryId,
    required this.name,
    this.imageUrl = '', // optional, can be empty during testing
  });

  Map<String, dynamic> toMap() {
    return {'categoryId': categoryId, 'name': name, 'imageUrl': imageUrl};
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryId: map['categoryId'],
      name: map['name'],
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
