import 'package:project_praktikum/model/MediaModel.dart';

class ApiModel {
  final String? maintainer;
  final String? github;
  final List<MediaModel>? endpoints;

  ApiModel({
    this.maintainer,
    this.github,
    this.endpoints
  });

  factory ApiModel.fromJson(Map<String, dynamic> json){
    return ApiModel(
      maintainer: json['maintainer'] as String?,
      github: json['github'] as String?,
      endpoints: (json['endpoints'] as List?)?.map((dynamic e) => MediaModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'maintainer': maintainer,
        'github': github,
        'endpoints': endpoints,
      };

}

class Media {
  final String? name;
  final String? paths;

  Media({
    required this.name,
    required this.paths,
  });

  factory Media.fromJson(Map<String, dynamic> json){
    return Media(
      name: json['name'] as String?,
      paths: json['paths'] as String?,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'paths': paths,
      };

}

