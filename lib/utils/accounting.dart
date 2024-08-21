import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_services.dart';

enum DatabaseOperation {
  dbRead,
  dbWrite,
  dbDelete
}

class Accounting {
  static final _storage = FlutterSecureStorage();
  static int _readCount = 0;  // Client-side counter for reads
  static int _writeCount = 0;  // Client-side counter for writes
  static int _deleteCount = 0;

  static const int readLimit = 180;  // Limit before clearing storage for reads
  static const int writeLimit = 15;  // Limit before clearing storage for writes
  static const int deleteLimit = 15;

  static bool _isSendingLogs = false;  // Flag to indicate if logs are being sent

  // Function to track and store both read and write operations
  static Future<void> detectAndStoreOperation(DatabaseOperation operation, int documentCount) async {
    if (_isSendingLogs) {
      return;  // Stop counting if logs are being sent
    }

    if (documentCount <= 0) {
      return;  // Skip logging if no documents were read or written
    }

    if (operation == DatabaseOperation.dbRead) {
      _readCount += documentCount;
    } else if (operation == DatabaseOperation.dbWrite) {
      _writeCount += documentCount;
    } else if (operation == DatabaseOperation.dbDelete) {
      _deleteCount += documentCount;
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
    String? storedReadCountStr = await _storage.read(key: 'dbReads');
    int storedReadCount = storedReadCountStr != null ? int.parse(storedReadCountStr) : 0;

    String? storedWriteCountStr = await _storage.read(key: 'dbWrites');
    int storedWriteCount = storedWriteCountStr != null ? int.parse(storedWriteCountStr) : 0;

    String? storedDeleteCountStr = await _storage.read(key: 'dbDelete');
    int storedDeleteCount = storedDeleteCountStr != null ? int.parse(storedDeleteCountStr) : 0;

    // Add the client-side counts to the stored counts
    int newStoredReadCount = storedReadCount + _readCount;
    int newStoredWriteCount = storedWriteCount + _writeCount;
    int newStoredDeleteCount = storedDeleteCount + _deleteCount;

    // Store the updated counts back in secure storage
    await _storage.write(key: 'dbReads', value: newStoredReadCount.toString());
    await _storage.write(key: 'dbWrites', value: newStoredWriteCount.toString());
    await _storage.write(key: 'dbDelete', value: newStoredDeleteCount.toString());

    _readCount = 0;
    _writeCount = 0;
    _deleteCount = 0;
    // Check if the total stored counts have reached or exceeded the thresholds
    if (newStoredReadCount >= readLimit || newStoredWriteCount >= writeLimit || newStoredDeleteCount >= deleteLimit) {
      await _prepareAndSendLogs(userId, newStoredReadCount, newStoredWriteCount, newStoredDeleteCount);
    }
  }

  // Prepare logs before sending to Firestore
  static Future<void> _prepareAndSendLogs(String userId, int reads, int writes, int deletes) async {
    if (_isSendingLogs) {
      return;  // Avoid duplicate log sending
    }

    _isSendingLogs = true;  // Indicate that logs are being prepared and sent

    // Prepare the log data
    final logData = {
      'dbReads': reads,
      'dbWrites': writes,
      'dbDelete': deletes
    };

    try {
      await sendLogs(userId, logData);
      await _clearStorage(userId);  // Clear the storage after sending logs
    } catch (error) {
      print('Error sending logs: $error');
    } finally {
      _isSendingLogs = false;  // Reset the flag after logs are sent
    }
  }

  // Send the prepared log data to Firestore
  static Future<void> sendLogs(String userId, Map<String, int> logData) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await firestore.collection('logs').doc(userId).set({
        timestamp: logData,
      }, SetOptions(merge: true)); // Merge with existing data if any

      print('Logs sent to Firestore: { uid: $userId, timestamp: $timestamp, data: $logData }');
    } catch (e) {
      print('Failed to send logs to Firestore: $e');
      throw e;  // Rethrow to handle the error in the calling method
    }
  }

  // Clear the stored counts in the secure storage
  static Future<void> _clearStorage(String userId) async {
    await _storage.delete(key: 'dbReads');
    await _storage.delete(key: 'dbWrites');
    await _storage.delete(key: 'dbDelete');
    print('User $userId: Cleared stored operations after reaching the threshold.');
  }

  // Retrieve the total read and write counts from storage for the current user
  static Future<Map<String, int>> getTotalOperationCounts() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      print('Error: No user ID found. Cannot retrieve operation counts.');
      return {'reads': 0, 'writes': 0};
    }

    String? storedReadCountStr = await _storage.read(key: 'dbReads');
    int storedReadCount = storedReadCountStr != null ? int.parse(storedReadCountStr) : 0;

    String? storedWriteCountStr = await _storage.read(key: 'dbWrites');
    int storedWriteCount = storedWriteCountStr != null ? int.parse(storedWriteCountStr) : 0;

    return {
      'reads': storedReadCount + _readCount,  // Include unsaved client-side counts
      'writes': storedWriteCount + _writeCount
    };
  }
}
