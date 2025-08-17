import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StorageMethods {
  final String cloudName = const String.fromEnvironment(
    "CLOUDINARY_CLOUD_NAME",
    defaultValue: "dkmccbbff",
  );
  final String uploadPreset = const String.fromEnvironment(
    "CLOUDINARY_UPLOAD_PRESET",
    defaultValue: "flutter_unsigned",
  );

  Future<String> uploadImageToStorage(
    bool isPost,
    String childName,
    Uint8List file,
  ) async {
    print("uploadImageToStorage called");
    print("cloudName: $cloudName");
    print("uploadPreset: $uploadPreset");
    print("childName: $childName");
    print("isPost: $isPost");
    print("file size: ${file.length} bytes");

    String uniqueId = const Uuid().v1();
    print("Generated uniqueId: $uniqueId");

    var uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );
    print("Upload URI: $uri");

    var request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = uploadPreset;
    request.fields['folder'] = childName;
    request.fields['public_id'] = isPost ? uniqueId : '';

    print("Request fields: ${request.fields}");

    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      file,
      filename: '$uniqueId.jpg',
    );
    request.files.add(multipartFile);

    print("About to send request to Cloudinary");
    var response = await request.send();
    print("Response status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var jsonResponse = jsonDecode(String.fromCharCodes(responseData));
      print("Upload successful: ${jsonResponse['secure_url']}");
      return jsonResponse['secure_url'];
    } else {
      var error = await response.stream.bytesToString();
      print("Upload failed with error: $error");
      throw Exception('Failed to upload image: $error');
    }
  }
}
