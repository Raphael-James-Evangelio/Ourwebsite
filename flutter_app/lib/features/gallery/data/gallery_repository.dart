import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'gallery_image.dart';

class GalleryRepository {
  GalleryRepository._();

  static final GalleryRepository instance = GalleryRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('gallery_images');

  Stream<List<GalleryImage>> watchImages({int? limit}) {
    Query<Map<String, dynamic>> query =
        _collection.orderBy('uploadedAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs.map(GalleryImage.fromDocument).toList(),
        );
  }

  Future<void> saveImage({
    required Uint8List bytes,
    required String originalName,
    String? contentType,
  }) async {
    final now = DateTime.now();
    final sanitizedName = originalName.trim().isEmpty ? 'photo' : originalName;
    final extension = _extractExtension(sanitizedName);
    final id = _uuid.v4();
    final safeExtension = extension.isNotEmpty ? '.$extension' : '';
    final storagePath = 'uploads/$id$safeExtension';

    final metadata = SettableMetadata(
      customMetadata: <String, String>{
        'originalName': sanitizedName,
        'uploadedAt': DateFormat('yyyy-MM-ddTHH:mm:ss').format(now),
      },
      contentType: contentType ?? _inferContentType(extension),
    );

    final storageRef = _storage.ref(storagePath);
    await storageRef.putData(bytes, metadata);
    final downloadUrl = await storageRef.getDownloadURL();

    await _collection.add(<String, dynamic>{
      'originalName': sanitizedName,
      'storagePath': storagePath,
      'downloadUrl': downloadUrl,
      'uploadedAt': FieldValue.serverTimestamp(),
      'fileExtension': extension,
    });
  }

  Future<void> deleteImage(GalleryImage image) async {
    final docRef = _collection.doc(image.id);
    await _firestore.runTransaction((transaction) async {
      transaction.delete(docRef);
    });

    if (image.storagePath.isNotEmpty) {
      final storageRef = _storage.ref(image.storagePath);
      try {
        await storageRef.delete();
      } on FirebaseException catch (error) {
        if (error.code != 'object-not-found') {
          rethrow;
        }
      }
    }
  }

  String _extractExtension(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  String? _inferContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return null;
    }
  }
}

