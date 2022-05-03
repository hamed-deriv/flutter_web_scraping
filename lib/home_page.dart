import 'package:flutter/material.dart';

import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Article> _articles = [];

  @override
  void initState() {
    super.initState();

    _getWebsiteData();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(elevation: 0, title: Text(widget.title)),
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _articles.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
            leading: Image.network(
              _articles[index].imageUrl,
              width: 50,
              fit: BoxFit.fitHeight,
            ),
            title: Text(_articles[index].title),
            subtitle: Text(_articles[index].url),
          ),
        ),
      );

  Future<void> _getWebsiteData() async {
    final Uri url = Uri.parse('https://www.amazon.com/s?k=iphone');
    final http.Response response = await http.get(url);
    final dom.Document html = dom.Document.html(response.body);

    final List<String> titles = html
        .querySelectorAll('h2 > a > span')
        .map((dom.Element element) => element.innerHtml.trim())
        .toList();

    final List<String?> urls = html
        .querySelectorAll('h2 > a')
        .map(
          (dom.Element element) =>
              'https://www.amazon.com${element.attributes['href']}',
        )
        .toList();

    final List<String?> imageUrls = html
        .querySelectorAll('span > a > div > img')
        .map(
          (dom.Element element) => element.attributes['src'],
        )
        .toList();

    for (final String title in titles) {
      _articles.clear();

      _articles.add(
        Article(
          title,
          urls[titles.indexOf(title)] ?? '',
          imageUrls[titles.indexOf(title)] ?? '',
        ),
      );
    }

    setState(() {});
  }
}

class Article {
  const Article(this.title, this.url, this.imageUrl);

  final String title;
  final String url;
  final String imageUrl;
}
