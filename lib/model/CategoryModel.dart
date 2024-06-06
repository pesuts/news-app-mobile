class CategoryModel{
  final String? name;
  final String? path;

  CategoryModel({
    this.name,
    this.path,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json){
    return CategoryModel(
      name: json['name'] as String?,
      path: json['path'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'path': path,
  };

}