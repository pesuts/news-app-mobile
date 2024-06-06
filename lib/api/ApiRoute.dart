import 'package:hive/hive.dart';

import 'ApiConfig.dart';

class ApiRoute {
  static Future getCategories(){
    return ApiConfig.get("");
  }

  static Future getNews(category) async {

    var box = await Hive.openBox('sibas');
    var media = box.get('media');
    print("rusman media");
    print("media: $media kategori: $category");
    return ApiConfig.get("$media/$category");
    // return ApiConfig.get("antara/$category");
  }
}