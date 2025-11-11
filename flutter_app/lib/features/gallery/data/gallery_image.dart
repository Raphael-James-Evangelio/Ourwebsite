import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryImage {
  GalleryImage({
    required this.id,
    required this.originalName,
    required this.downloadUrl,
    required this.storagePath,
    required this.uploadedAt,
  });

  final String id;
  final String originalName;
  final String downloadUrl;
  final String storagePath;
  final DateTime uploadedAt;

  factory GalleryImage.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final timestamp = data['uploadedAt'];

    return GalleryImage(
      id: doc.id,
      originalName: data['originalName'] as String? ?? 'Untitled',
      downloadUrl: data['downloadUrl'] as String? ?? '',
      storagePath: data['storagePath'] as String? ?? '',
      uploadedAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.tryParse(timestamp?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

