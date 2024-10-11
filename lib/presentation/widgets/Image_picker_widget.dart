import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final Function(String) onImageSelected;
  final String? imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final String buttonText;

  const ImagePickerWidget({
    Key? key,
    required this.onImageSelected,
    this.imageUrl,
    this.height = 200,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    required this.buttonText,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 1000,
      imageQuality: 40,
    );

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Cropper'),
        ],
      );
      if (croppedFile != null) {
        onImageSelected(croppedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          image: imageUrl != null && imageUrl!.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: fit,
                )
              : null,
        ),
        child: imageUrl == null || imageUrl!.isEmpty
            ? Center(child: Text(buttonText, style: const TextStyle(fontSize: 16)))
            : null,
      ),
    );
  }
}
class CircleAvatarPickerWidget extends StatelessWidget {
  final Function(String) onImageSelected;
  final String? imageUrl;
  final String buttonText;

  const CircleAvatarPickerWidget({
    Key? key,
    required this.onImageSelected,
    this.imageUrl,
    required this.buttonText,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 1000,
      imageQuality: 40,
    );

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Circular aspect ratio
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Cropper'),
        ],
      );
      if (croppedFile != null) {
        onImageSelected(croppedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: CircleAvatar(
        radius: 50, // Fixed radius for the avatar
        backgroundColor: Colors.grey,
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? NetworkImage(imageUrl!)
            : null,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Center(child: Text(buttonText, style: const TextStyle(fontSize: 16)))
            : null,
      ),
    );
  }
}
