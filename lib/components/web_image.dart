import 'package:flutter/material.dart';

class WebImage extends StatelessWidget {
  final String _url;

  const WebImage(this._url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      _url,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if(loadingProgress == null) {
          return child;
        }
        return Container(
          padding: const EdgeInsets.all(15),
          child: const CircularProgressIndicator(),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: const Column(
          children: [Icon(Icons.do_not_disturb_alt), Text('Not Found!')],
        ),
      ),
    );
  }
}
