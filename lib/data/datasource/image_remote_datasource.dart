import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class ImageRemoteDataSource {
  Future<String> uploadImage(Uint8List bytes, String userId);
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final http.Client client;

  ImageRemoteDataSourceImpl({required this.client});

  @override
  Future<String> uploadImage(Uint8List bytes, String userId) async {
    final cloudinaryUrl = dotenv.env['CLOUDINARY_URL'] ?? '';
    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

    if (cloudinaryUrl.isEmpty || uploadPreset.isEmpty) {
      throw Exception('Cloudinary configurations missing in .env');
    }

    final uri = Uri.parse(cloudinaryUrl);
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'profile_$userId.jpg',
        ),
      );

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['secure_url'] as String;
    } else {
      throw Exception('Upload failed with status ${response.statusCode}: ${response.body}');
    }
  }
}