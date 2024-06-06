import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project_praktikum/model/ApiModel.dart';
import 'package:project_praktikum/model/CategoryModel.dart';
import 'package:project_praktikum/views/HomeNews.dart';

import '../api/ApiRoute.dart';
import 'BottomNavBar.dart';


class NewsCategories extends StatefulWidget {
  // final List<String>? categories;

  NewsCategories({Key? key});
  // Categories({Key? key, required this.categories});

  @override
  _NewsCategories createState() => _NewsCategories();
}

class _NewsCategories extends State<NewsCategories> {

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

  Widget _buildCategories(){
    return Container(
      child: FutureBuilder(
          future: ApiRoute.getCategories(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            // print(snapshot);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoading();
            }
            else if (snapshot.hasError){
              return _buildError();
            }
            else if (snapshot.hasData){
              if (snapshot.data == null) {
                return _buildError();
              }
              try{
                ApiModel apiModel = ApiModel.fromJson(snapshot.data);
                if (apiModel.endpoints == null) {
                  return _buildError();
                }
                return _buildSuccess(apiModel);
              } catch (e) {
                return _buildError();
              }
            } else return _buildError();
          }
      ),
    );
  }

  Future<String?> getMediaFromHive() async {
    var box = await Hive.openBox('sibas');
    return box.get('media');
  }

  Widget _buildSuccess(ApiModel apiModel) {
    return FutureBuilder<String?>(
      future: getMediaFromHive(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final media = snapshot.data;

          final mediaIndex = apiModel.endpoints?.indexWhere((endpoint) => endpoint.name == media);

          print("media index = $mediaIndex, media name = $media");

          if (mediaIndex == null || mediaIndex == -1) {
            return Center(child: Text('Media not found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'What interest you?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 10),
                child: Text(
                  'All categories:',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemBuilder: (context, index) {
                    return CardItem(categoryModel: apiModel.endpoints![mediaIndex].paths![index]);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                  ),
                  itemCount: apiModel.endpoints![mediaIndex].paths!.length,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildError() {
    return Text("No Data");
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class CardItem extends StatelessWidget {
  final CategoryModel categoryModel;

  CardItem({Key? key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          var box = await Hive.openBox('sibas');
          // var media = box.get('media');

          // var box = Hive.box('sibas');
          print(categoryModel.name);
          box.put('category', categoryModel.name);
          Navigator.push(context,
            MaterialPageRoute(builder:
              // (context) => DetailFoodView(id: meals.idMeal ?? ""))
              (context) => HomeNews()),
          );
          // _launchUrl(categoryModel.displayIcon);
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 10),
                  child: Image.asset(
                    (categoryModel?.name != null && categoryModel?.name != "") ? 'assets/images/${categoryModel.name}.png'
                        : 'assets/images/dunia.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 25,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  categoryModel.name?.toUpperCase() ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'RobotoMono',
                      // fontSize: 15
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
