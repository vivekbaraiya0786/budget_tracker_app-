import 'dart:typed_data';

class CategoryModel {
  int? categoryId;
  String categoryName;
  Uint8List categoryImage;

  CategoryModel({
    this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  factory CategoryModel.fromMap({required Map<String, dynamic> data}) {
    return CategoryModel(
      categoryId: data['category_id'],
      categoryName: data['category_name'],
      categoryImage: data['category_image'],
    );
  }
}
