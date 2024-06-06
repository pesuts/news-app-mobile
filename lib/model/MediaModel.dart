import 'package:project_praktikum/model/CategoryModel.dart';

class MediaModel{
  final String? name;
  final String? path;
  final List<CategoryModel>? paths;

  MediaModel({
    this.name,
    this.path,
    this.paths,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json){
    return MediaModel(
      name: json['name'] as String?,
      path: json['path'] as String?,
      paths: (json['paths'] as List?)?.map((dynamic e) => CategoryModel.fromJson(e as Map<String,dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'path': path,
    'paths': paths,
  };

}