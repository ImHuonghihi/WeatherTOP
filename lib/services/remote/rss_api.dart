import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/presentation/notification_screen/rss.dart';
import 'package:weather/services/local/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class RssData {
  final String title;
  final String description;
  final String link;
  final String pubDate;
  final imageUrl;
  RssData({
    required this.title,
    required this.description,
    this.imageUrl,
    required this.pubDate,
    required this.link,
  });

  // xml to rssdata
  factory RssData.fromXml(XmlElement xml) {
    var title, description, link, imageUrl, pubDate;
    if (SharedHandler.getSharedPref(SharedHandler.rssValueKey) == 'vnexpress') {
      var data = _vnexpressData(xml,
          title: title, description: description, link: link, pubDate: pubDate);
      title = data[0];
      description = data[1];
      link = data[2];
      imageUrl = data[3];
      pubDate = data[4];
    } else {
      title = xml.findAllElements('title').first.innerText;
      description = xml
          .findAllElements('description')
          .first
          .innerText
          .split("</a><br/>")
          .last;
      link = xml.findAllElements('link').first.innerText;
      imageUrl = xml
          .findAllElements('description')
          .first
          .innerText
          .split("img src=\"")
          .last
          .split("\"")
          .first;
      pubDate = xml.findAllElements('pubDate').first.innerText;
    }

    return RssData(
      title: title,
      description: description,
      link: link,
      imageUrl: imageUrl,
      pubDate: pubDate,
    );
  }

  static _vnexpressData(
    XmlElement xml, {
    title,
    description,
    link,
    imageUrl,
    pubDate,
  }) {
    title = xml.findAllElements('title').first.innerText;
    description = xml
        .findAllElements('description')
        .first
        .innerText
        .split("</a><br/>")
        .last;
    link = xml.findAllElements('link').first.innerText;
    imageUrl = xml
        .findAllElements('description')
        .first
        .innerText
        .split("img src=\"")
        .last
        .split("\"")
        .first;
    pubDate = xml.findAllElements('pubDate').first.innerText;
    return [title, description, link, imageUrl, pubDate];
  }
}

// wrapper class for rss api
class RSSApi {
  static Future<List<RssData>> getRSS({String? forceURL}) async {
    final keyRss = SharedHandler.getSharedPref(SharedHandler.rssValueKey);
    final url = newsFeedRSS[keyRss];
    final response = await http.get(Uri.parse(forceURL ?? url!));
    if (response.statusCode == 200) {
      final rss = XmlDocument.parse(utf8.decode(response.bodyBytes));
      final items = rss.findAllElements('item');
      return items.map((item) => RssData.fromXml(item)).toList();
    } else {
      throw Exception('Failed to load RSS');
    }
  }
}
