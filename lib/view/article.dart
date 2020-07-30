import 'package:flutter/material.dart';
import '../helper/api-helper.dart';

class Article extends StatefulWidget {
  Article({Key key}) : super(key: key);
  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  Widget createArticleView(snapshot) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            snapshot.data.title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.amber[900],
            ),
          ),
          Text(snapshot.data.body, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget createArticle(BuildContext context, String id) {  
    return Center(
      // child: createArticleView(snapshot),
      child: FutureBuilder<ArticleReponse>(
        future: getArticle(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return createArticleView(snapshot);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        createArticle(context, "1"),
        createArticle(context, "4"),
      ],
    );
  }
}
