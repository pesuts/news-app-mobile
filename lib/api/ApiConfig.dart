import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConfig{
  static final String baseUrl = "https://api-berita-indonesia.vercel.app/";

  static Future get(String partUrl) async {
    final url = baseUrl + partUrl;
    print(url);
    final response = await http.get(Uri.parse(url));
    final body = response.body;
    if(body.isNotEmpty){
      return json.decode(body);
    }
    return;
  }
}