class NewsModel{
  final List<Agents>? data;

  NewsModel({
    required this.data
});

  factory NewsModel.fromJson(Map<String, dynamic> json){
    return NewsModel(
      data: (json['data'] as List?)?.map((dynamic e) => Agents.fromJson(e as Map<String,dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data,
  };

}

class Agents{
  final String? uuid;
  final String? displayName;
  final String? developerName;
  final String? displayIcon;

  Agents({
    required this.uuid,
    required this.displayName,
    required this.developerName,
    required this.displayIcon,
});

  factory Agents.fromJson(Map<String, dynamic> json){
    return Agents(
      uuid: json['uuid'] as String?,
      displayName: json['displayName'] as String?,
      developerName: json['developerName'] as String?,
      displayIcon: json['displayIcon'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
      'uuid': uuid,
      'displayName': displayName,
      'developerName': developerName,
      'displayIcon': displayIcon,
  };

}