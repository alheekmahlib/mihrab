import 'package:mihrab_shared/mihrab_shared.dart';

abstract class HadithRepository {
  /// Load all collection metadata
  Future<List<Map<String, dynamic>>> loadCollections();

  /// Get a random hadith from any of the 6 books
  Future<HadithEntity> getRandomHadith();

  /// Get all hadiths from a specific book file
  Future<List<HadithEntity>> loadBookHadiths({
    required HadithCollection collection,
    required int bookNumber,
  });

  /// Get total number of books for a collection
  int getBooksCount(HadithCollection collection);
}
