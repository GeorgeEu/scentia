import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:scientia/services/school_service.dart';

class CloudStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Resize image by a percentage
  Future<Uint8List?> _resizeImageByPercentage(File imageFile, double percentage) async {
    try {
      // Read image file as bytes
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Decode the image
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage != null) {
        // Calculate new dimensions based on the percentage
        int newWidth = (originalImage.width * percentage).toInt();
        int newHeight = (originalImage.height * percentage).toInt();

        // Resize the image
        img.Image resizedImage = img.copyResize(originalImage, width: newWidth, height: newHeight);

        // Compress the resized image and return the bytes
        return Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80));  // Adjust quality as needed
      }
    } catch (e) {
      print("Error resizing image: $e");
      return null;
    }
    return null;
  }

  // Upload resized image to Firebase Storage
  Future<String?> uploadResizedImage(File image, double resizePercentage) async {
    try {
      // Resize the image by the specified percentage
      Uint8List? resizedImageBytes = await _resizeImageByPercentage(image, resizePercentage);
      if (resizedImageBytes == null) {
        print("Failed to resize image.");
        return null;
      }

      // Fetch the current user's school ID
      final String? schoolId = await SchoolService().getCurrentUserSchoolId();
      if (schoolId == null) {
        print("Failed to get school ID");
        return null;
      }

      // Create a unique file name for the image
      final String fileName = path.basename(image.path);  // Use the same name as the original image
      final Reference storageRef = _storage.ref().child('$schoolId/$fileName');

      // Upload the resized image to Firebase Storage
      UploadTask uploadTask = storageRef.putData(resizedImageBytes);

      // Wait for the upload to complete and get the download URL
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading resized image: $e');
      return null;
    }
  }
}
