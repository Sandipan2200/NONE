import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'api_service.dart';

class SyncService {
  final ApiService _apiService;
  final Duration syncInterval;
  Timer? _syncTimer;
  bool _isSyncing = false;

  SyncService(this._apiService, {this.syncInterval = const Duration(minutes: 15)});

  void startSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(syncInterval, (_) => syncData());
  }

  void stopSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> syncData() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        _isSyncing = false;
        return;
      }

      // Sync local data with server
      await _syncFoodLogs();
      await _syncNutritionSummaries();
      await _syncUserProfile();
    } catch (e) {
      print('Sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncFoodLogs() async {
    // Implement local database synchronization
    // Here you would:
    // 1. Get unsynchronized food logs from local database
    // 2. Upload them to server
    // 3. Update local sync status
  }

  Future<void> _syncNutritionSummaries() async {
    // Sync nutrition summaries
    // Similar to food logs, but for daily summaries
  }

  Future<void> _syncUserProfile() async {
    try {
      final profile = await _apiService.getUserProfile();
      // Update local profile data
    } catch (e) {
      print('Profile sync error: $e');
    }
  }

  bool get isSyncing => _isSyncing;
}
