import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class MediaService {
  static final ImagePicker _picker = ImagePicker();
  
  // Seleziona immagine dalla galleria
  static Future<File?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        return File(image.path);
      }
      
      return null;
    } catch (e) {
      debugPrint('Errore durante la selezione dell\'immagine: $e');
      return null;
    }
  }
  
  // Seleziona immagine dalla fotocamera
  static Future<File?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        return File(image.path);
      }
      
      return null;
    } catch (e) {
      debugPrint('Errore durante l\'acquisizione della foto: $e');
      return null;
    }
  }
  
  // Salva un'immagine nel dispositivo
  static Future<String?> saveImageToLocalStorage(File image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${const Uuid().v4()}.jpg';
      final savedImage = await image.copy('${directory.path}/$fileName');
      
      return savedImage.path;
    } catch (e) {
      debugPrint('Errore durante il salvataggio dell\'immagine: $e');
      return null;
    }
  }
  
  // Elimina un'immagine dal dispositivo
  static Future<bool> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Errore durante l\'eliminazione dell\'immagine: $e');
      return false;
    }
  }
  
  // Mostra dialog per la selezione dell'immagine
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleziona fonte immagine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galleria'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Fotocamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
        ],
      ),
    );
    
    if (source == null) {
      return null;
    }
    
    return source == ImageSource.gallery
        ? await pickImage()
        : await takePhoto();
  }
}