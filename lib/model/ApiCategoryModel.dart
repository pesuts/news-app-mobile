class ApiCategoryModel {
  final bool? success;
  final String? message;
  final MediaDetail? data;

  ApiCategoryModel({
    this.success,
    this.message,
    this.data
  });

  factory ApiCategoryModel.fromJson(Map<String, dynamic> json){
    return ApiCategoryModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: MediaDetail.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'success': success,
        'message': message,
        'data': data,
      };

}

class MediaDetail {
  final String? link;
  final String? image;
  final String? description;
  final String? title;
  final List<Post>? posts;

  MediaDetail({
    required this.link,
    required this.image,
    required this.description,
    required this.title,
    required this.posts,
  });

  factory MediaDetail.fromJson(Map<String, dynamic> json){
    return MediaDetail(
      link: json['link'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      title: json['title'] as String?,
      posts: (json['posts'] as List?)?.map((dynamic e) =>
          Post.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'link': link,
        'image': image,
        'description': description,
        'title': title,
        'posts': posts,
      };
}

class Post {
  final String? link;
  final String? title;
  final String? description;
  final String? pubDate;
  final String? thumbnail;

  Post({
    required this.link,
    required this.title,
    required this.description,
    required this.pubDate,
    required this.thumbnail,
  });

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      link: json['link'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      pubDate: json['pubDate'] as String?,
      thumbnail: json['thumbnail'] as String?,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'link': link,
        'title': title,
        'description': description,
        'pubDate': pubDate,
        'thumbnail': thumbnail,
      };
}

