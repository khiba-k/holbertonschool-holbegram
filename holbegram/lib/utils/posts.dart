import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/pages/methods/post_storage.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs;

        if (posts.isEmpty) {
          return const Center(child: Text("No posts yet."));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = Post.fromSnap(posts[index]);

            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  // Post header
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(post.profImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(post.username),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: () async {
                            await PostStorage().deletePost(
                              post.postId,
                              post.postUrl,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Post deleted")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Post caption
                  const SizedBox(height: 8),
                  Text(post.caption),

                  // Post image
                  const SizedBox(height: 10),
                  Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: NetworkImage(post.postUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Action buttons
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.favorite_border),
                      const Icon(Icons.comment),
                      const Icon(Icons.send),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border),
                        onPressed: () async {
                          if (user != null) {
                            await FirebaseFirestore.instance
                                .collection('favorites')
                                .add({
                              'postUrl': post.postUrl,
                              'uid': user.uid,
                              'timestamp': Timestamp.now(),
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Added to favorites')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
