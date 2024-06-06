import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_praktikum/model/ApiCategoryModel.dart';

import '../api/ApiRoute.dart';
import 'BottomNavBar.dart';
import 'DetailNews.dart';

class HomeNews extends StatefulWidget {
  HomeNews({Key? key});

  @override
  _HomeNews createState() => _HomeNews();
}

class _HomeNews extends State<HomeNews> {
  final Map<String, bool> _selectedCategories = {
    'Technology': false,
    'Sports': false,
    'Health': false,
    'Business': false,
    'Entertainment': false,
    'Science': false,
    'General': false,
    'Politics': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.newspaper,
                size: 30,
                color: Colors.red[500],
              ),
            ),
            SizedBox(width: 10),
            Text(
              'SIBAS NEWS!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _buildCategories(),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildCategories() {
    String category;

    var box = Hive.box('sibas');
    var userCategory = box.get('category');

    if (userCategory == null || userCategory == "") {
      category = "terbaru";
    } else {
      category = userCategory;
    }
    // print("category = $category");

    return Container(
      child: FutureBuilder(
          future: ApiRoute.getNews(category),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoading();
            } else if (snapshot.hasError) {
              return _buildError();
            } else if (snapshot.hasData) {
              if (snapshot.data == null) {
                return _buildError();
              }
              try {
                ApiCategoryModel apiCategoryModel =
                ApiCategoryModel.fromJson(snapshot.data);
                if (apiCategoryModel.data == null) {
                  return _buildError();
                }
                return _buildSuccess(apiCategoryModel);
              } catch (e) {
                return _buildError();
              }
            } else {
              return _buildError();
            }
          }),
    );
  }

  Widget _buildSuccess(ApiCategoryModel apiCategoryModel) {
    return ListView.builder(
      itemCount: apiCategoryModel.data?.posts?.length ?? 0,
      itemBuilder: (context, index) {
        return CardItem(post: apiCategoryModel.data!.posts![index]);
      },
    );
  }

  Widget _buildError() {
    return Center(
      child: Text("No Data"),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class CardItem extends StatelessWidget {
  final Post post;

  CardItem({Key? key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailNews(url: post.link)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.thumbnail != null && post.thumbnail!.isNotEmpty)
              Image.network(
                post.thumbnail!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                post.title ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (post.description != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  post.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailNews(url: post.link)));
                  },
                  child: Text('Read More'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
