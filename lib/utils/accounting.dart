import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_services.dart';

enum DatabaseOperation {
  dbRead,
  // Future operations: dbWrite, dbDelete
}

class Accounting {
  static final _storage = FlutterSecureStorage();
  static int _readCount = 0;  // Client-side counter
  static const int _storageThreshold = 500;  // Limit before clearing storage

  static Future<void> detectAndStoreRead(int documentCount) async {
    if (documentCount <= 0) {
      return;  // Skip logging if no documents were read
    }

    // Increment the client-side counter by the number of documents received
    _readCount += documentCount;

    // Save the updated count to secure storage
    await _saveReadCountToStorage();
  }

  static Future<void> _saveReadCountToStorage() async {
    String? userId = AuthService.getCurrentUserId();  // Get the current user ID
    if (userId == null) {
      print('Error: No user ID found. Cannot store read count.');
      return;
    }

    // Retrieve the current stored count
    String? storedCountStr = await _storage.read(key: 'dbRead_$userId');
    int storedCount = storedCountStr != null ? int.parse(storedCountStr) : 0;

    if (_readCount > 0) {
      // Add the client-side count to the stored count
      int newStoredCount = storedCount + _readCount;

      // Store the updated count back in secure storage
      await _storage.write(key: 'dbRead_$userId', value: newStoredCount.toString());

      print('User $userId: Saved $_readCount reads to storage. Total reads: $newStoredCount');

      // Reset the client-side counter after saving
      _readCount = 0;

      // Check if the total stored count has reached or exceeded the threshold
      if (newStoredCount >= _storageThreshold) {
        await _clearStorage(userId);  // Clear the storage if the threshold is reached
      }
    }
  }

  static Future<void> _clearStorage(String userId) async {
    await _storage.delete(key: 'dbRead_$userId');
    print('User $userId: Cleared stored reads after reaching the threshold.');
  }

  // Retrieve the total operation count from storage for the current user
  static Future<int> getTotalOperationCount() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      print('Error: No user ID found. Cannot retrieve read count.');
      return 0;
    }

    String? storedCountStr = await _storage.read(key: 'dbRead_$userId');
    int storedCount = storedCountStr != null ? int.parse(storedCountStr) : 0;
    return storedCount + _readCount;  // Include unsaved client-side counts
  }
}
