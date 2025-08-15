import 'package:flutter/material.dart';
// import '../../utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 32),
            ),
            SizedBox(width: 8,),
            Image.asset(
              'assets/images/logo.webp',
              width: 24,
              height: 24,
            ),
            Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.favorite_border)
                ),
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.message_outlined)
                ),
              ],
            )
          ],
        ),
      ),
      // body: PostsList(),
    );
  }
}