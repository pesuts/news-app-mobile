import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailNews extends StatefulWidget {
  bool _isFavourite = false;

  final String? url;

  DetailNews({super.key, required this.url});

  @override
  State<DetailNews> createState() => _DetailNews();
}

class _DetailNews extends State<DetailNews> {
  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
    // ..loadRequest(Uri.parse('https://www.antaranews.com/berita/4139055/kemenhub-matangkan-kesiapan-wakili-indonesia-pada-marpolex-di-filipina'));
      ..loadRequest(Uri.parse(widget!.url ?? "https://bima.upnyk.ac.id/ok"));

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
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  widget._isFavourite = !widget._isFavourite;
                });
              },
              icon: Icon(
                (widget._isFavourite)
                    ? Icons.bookmark_border_outlined
                    : Icons.bookmark,
                color: widget._isFavourite ? Colors.white : Colors.red,
              )),
        ],
      ),
      body: WebViewWidget(controller: controller,),
    );
  }
}
