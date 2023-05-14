import 'package:flutter/material.dart';
import 'package:weather/services/remote/rss_api.dart';
import 'package:weather/utils/functions/number_converter.dart';
import 'package:weather/utils/functions/string_ext.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


class NewsHeadlineSlider extends StatefulWidget {
  final List<RssData> rssDataList;
  
  int? timer = 10;

  NewsHeadlineSlider({super.key, required this.rssDataList, this.timer=10});

  @override
  _NewsHeadlineSliderState createState() => _NewsHeadlineSliderState();
}

class _NewsHeadlineSliderState extends State<NewsHeadlineSlider> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: widget.timer!), (Timer timer) {
      if (_currentPageIndex < widget.rssDataList.length - 1) {
        _currentPageIndex++;
      } else {
        _currentPageIndex = 0;
      }
      _pageController.animateToPage(
        _currentPageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      itemCount: widget.rssDataList.length,
      itemBuilder: (context, index) {
        return Headline(
          title: widget.rssDataList[index].title,
          imageUrl: widget.rssDataList[index].imageUrl,
          url: widget.rssDataList[index].link,
        );
      },
    );
  }
}
// widget to show news headline with image and title
class Headline extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final String? url;
  const Headline({Key? key, this.title, this.imageUrl, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // launch url in browser
        launchUrl(Uri.parse(url!));
      },
      child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            Positioned(
              left: 16.0,
              bottom: 16.0,
              child: Text(
                // limit title length based on screen size
                title!.limitLength(convertNumber<int>(
                    (MediaQuery.of(context).size.width -
                        MediaQuery.of(context).padding.horizontal) / 10)),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ));
  }

  // launch url in browser

}