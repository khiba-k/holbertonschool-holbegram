import 'package:flutter/material.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/home.dart';
import 'package:holbegram/screens/pages/methods/post_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _file;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void selectImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _file = imageBytes;
      });
    }
  }

  void selectImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _file = imageBytes;
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Image Source',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        selectImageFromGallery();
                      },
                      child: Column(
                        children: [
                          Icon(Icons.image_outlined, size: 50, color: Colors.red),
                          Text('Gallery'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        selectImageFromCamera();
                      },
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 50, color: Colors.red),
                          Text('Camera'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          )
        );
      },
    );
  }

  void postImage() async {
    print("postImage called");
    final User? user = Provider.of<UserProvider>(context, listen: false).user;
    print("User: $user");

    if (_file == null) {
      print("No File");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first'),
        backgroundColor: Colors.red,
        ),
      );
      return;
    }

  if (user == null) {
    print("No User");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User not logged in'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    print("Trying to post image");
    String result = await PostStorage().uploadPost(
      _captionController.text, 
      user.uid, 
      user.username, 
      user.photoUrl, 
      _file!
    );

    print("Post Result: $result");

    if (result == "Ok") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Posted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _file = null;
        _captionController.clear();
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $result'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Add Image', 
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Center(
            child: GestureDetector(
              onTap: postImage,
              child: Text(
                'Post',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Billabong',
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ),
        )
      ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
        children: [
          if (_isLoading)
            LinearProgressIndicator(
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          SizedBox(height: 16,),
          Center(
            child: Column(
              children: [
                Text(
                  'Add Image',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  'Choose an image from your gallery or take a one.',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _captionController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: _showImagePickerOptions,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _file != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(_file!, fit: BoxFit.contain),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/add.webp',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ],
                )
            ),
          )
        ],
      ),
        ),
      ),
    );
  }
}