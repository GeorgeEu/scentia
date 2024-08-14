import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_services.dart';

enum DatabaseOperation {
  dbRead,
  dbWrite,
  // Future operations: dbDelete
}

class Accounting {
  static final _storage = FlutterSecureStorage();
  static int _readCount = 0;  // Client-side counter for reads
  static int _writeCount = 0;  // Client-side counter for writes
  static const int _storageThreshold = 500;  // Limit before clearing storage

  // Function to track and store both read and write operations
  static Future<void> detectAndStoreOperation(DatabaseOperation operation, int documentCount) async {
    if (documentCount <= 0) {
      return;  // Skip logging if no documents were read or written
    }

    if (operation == DatabaseOperation.dbRead) {
      _readCount += documentCount;
    } else if (operation == DatabaseOperation.dbWrite) {
      _writeCount += documentCount;
    }

    // Save the updated counts to secure storage
    await _saveCountsToStorage();
  }

  // Save the counts (both reads and writes) to secure storage
  static Future<void> _saveCountsToStorage() async {
    String? userId = AuthService.getCurrentUserId();  // Get the current user ID
    if (userId == null) {
      print('Error: No user ID found. Cannot store operation counts.');
      return;
    }

    // Retrieve the current stored counts
    String? storedReadCountStr = await _storage.read(key: 'dbRead_$userId');
    int storedReadCount = storedReadCountStr != null ? int.parse(storedReadCountStr) : 0;

    String? storedWriteCountStr = await _storage.read(key: 'dbWrite_$userId');
    int storedWriteCount = storedWriteCountStr != null ? int.parse(storedWriteCountStr) : 0;

    // Add the client-side counts to the stored counts
    int newStoredReadCount = storedReadCount + _readCount;
    int newStoredWriteCount = storedWriteCount + _writeCount;

    // Store the updated counts back in secure storage
    await _storage.write(key: 'dbRead_$userId', value: newStoredReadCount.toString());
    await _storage.write(key: 'dbWrite_$userId', value: newStoredWriteCount.toString());

    print('User $userId: Saved $_readCount reads and $_writeCount writes to storage. Total reads: $newStoredReadCount, Total writes: $newStoredWriteCount');

    // Reset the client-side counters after saving
    _readCount = 0;
    _writeCount = 0;

    // Check if the total stored counts have reached or exceeded the threshold
    if (newStoredReadCount >= _storageThreshold || newStoredWriteCount >= _storageThreshold) {
      await _clearStorage(userId);  // Clear the storage if the threshold is reached
    }
  }

  // Clear the stored counts in the secure storage
  static Future<void> _clearStorage(String userId) async {
    await _storage.delete(key: 'dbRead_$userId');
    await _storage.delete(key: 'dbWrite_$userId');
    print('User $userId: Cleared stored operations after reaching the threshold.');
  }

  // Retrieve the total read and write counts from storage for the current user
  static Future<Map<String, int>> getTotalOperationCounts() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      print('Error: No user ID found. Cannot retrieve operation counts.');
      return {'reads': 0, 'writes': 0};
    }

    String? storedReadCountStr = await _storage.read(key: 'dbRead_$userId');
    int storedReadCount = storedReadCountStr != null ? int.parse(storedReadCountStr) : 0;

    String? storedWriteCountStr = await _storage.read(key: 'dbWrite_$userId');
    int storedWriteCount = storedWriteCountStr != null ? int.parse(storedWriteCountStr) : 0;

    return {
      'reads': storedReadCount + _readCount,  // Include unsaved client-side counts
      'writes': storedWriteCount + _writeCount
    };
  }
}
