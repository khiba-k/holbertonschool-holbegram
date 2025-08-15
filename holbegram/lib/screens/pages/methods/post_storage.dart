import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';
import 'package:crypto/crypto.dart';


class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods storage = StorageMethods();

  final String apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
  final String apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;
  final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;

  Future<String> uploadPost(
      String caption,
      String uid,
      String username,
      String profImage,
      Uint8List image,
      ) async {
    try {
      String imageUrl =
      await storage.uploadImageToStorage(true, 'posts', image);

      String postId = const Uuid().v1();

      String publicId = extractPublicIdFromCloudinaryUrl(imageUrl);

      await _firestore.collection('posts').doc(postId).set({
        'caption': caption,
        'uid': uid,
        'username': username,
        'likes': [],
        'postId': postId,
        'datePublished': DateTime.now(),
        'postUrl': imageUrl,
        'profImage': profImage,
        'publicId': publicId,
      });

      return 'Ok';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deletePost(String postId, String publicId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();

      await deleteImageFromCloudinary(publicId);
    } catch (e) {
      rethrow;
    }
  }

  String extractPublicIdFromCloudinaryUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;

      if (segments.length < 2) return '';

      final folderAndFile = segments[segments.length - 1];
      final folder = segments[segments.length - 2];
      final fileWithoutExtension =
          folderAndFile.split('.').first;

      return '$folder/$fileWithoutExtension';
    } catch (e) {
      print('Error extracting publicId: $e');
      return '';
    }
  }

  Future<void> deleteImageFromCloudinary(String publicId) async {
    final String apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
    final String apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;
    final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;

    final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final String toSign = 'invalidate=true&public_id=$publicId&timestamp=$timestamp$apiSecret';
    final String signature = sha1.convert(utf8.encode(toSign)).toString();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'public_id': publicId,
        'api_key': apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
        'invalidate': 'true',
      },
    );

    // ignore: avoid_print
    print("Cloudinary delete response: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to delete image from Cloudinary: ${response.body}');
    }
  }
}