import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String username;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;
  final List posts;
  final List saved;
  final String searchKey;

  const User({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.saved,
    required this.searchKey,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'username': username,
    'bio': bio,
    'photoUrl': photoUrl,
    'followers': followers,
    'following': following,
    'posts': posts,
    'saved': saved,
    'searchKey': searchKey,
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      uid: snapshot['uid'] as String,
      email: snapshot['email'] as String,
      username: snapshot['username'] as String,
      bio: snapshot['bio'] as String,
      photoUrl: snapshot['photoUrl'] as String,
      followers: snapshot['followers'] as List,
      following: snapshot['following'] as List,
      posts: snapshot['posts'] as List,
      saved: snapshot['saved'] as List,
      searchKey: snapshot['searchKey'] as String,
    );
  }
}
