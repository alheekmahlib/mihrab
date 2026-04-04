import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../domain/repositories/hadith_repository.dart';

class HadithRepositoryImpl implements HadithRepository {
  final Random _random = Random();
  List<Map<String, dynamic>>? _collectionsCache;

  @override
  Future<List<Map<String, dynamic>>> loadCollections() async {
    if (_collectionsCache != null) return _collectionsCache!;

    final jsonString = await rootBundle.loadString(
      'assets/json/collections.json',
    );
    final data = jsonDecode(jsonString) as List;
    _collectionsCache = data.cast<Map<String, dynamic>>();
    return _collectionsCache!;
  }

  @override
  Future<HadithEntity> getRandomHadith() async {
    // Pick a random collection from the 6 books
    final collections = HadithCollection.values;
    final collection = collections[_random.nextInt(collections.length)];
    final booksCount = getBooksCount(collection);

    // Pick a random book number (1-indexed)
    final bookNumber = _random.nextInt(booksCount) + 1;

    // Load hadiths from that book
    final hadiths = await loadBookHadiths(
      collection: collection,
      bookNumber: bookNumber,
    );

    if (hadiths.isEmpty) {
      // Retry with a different book if empty
      return getRandomHadith();
    }

    // Pick a random hadith from the book
    return hadiths[_random.nextInt(hadiths.length)];
  }

  @override
  Future<List<HadithEntity>> loadBookHadiths({
    required HadithCollection collection,
    required int bookNumber,
  }) async {
    try {
      final path =
          'assets/json/books_data/${collection.name}_books/ar_$bookNumber.json';
      final jsonString = await rootBundle.loadString(path);
      final data = jsonDecode(jsonString) as List;

      return data
          .cast<Map<String, dynamic>>()
          .map((json) => HadithEntity.fromJson(json, collection))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  int getBooksCount(HadithCollection collection) {
    return collection.booksCount;
  }
}
