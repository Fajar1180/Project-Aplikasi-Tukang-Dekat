import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/provider_model.dart';
import '../../core/services/api_service.dart';

<<<<<<< HEAD
final pendingProvidersProvider = FutureProvider<List<ProviderProfile>>((ref) async {
=======
final pendingProvidersProvider = FutureProvider<List<ProviderProfile>>((
  ref,
) async {
>>>>>>> repo-b/main
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getPendingProviders();
  return response.data;
});

final adminVerificationControllerProvider =
<<<<<<< HEAD
    StateNotifierProvider<AdminVerificationController, AdminVerificationState>((ref) {
  return AdminVerificationController(ref);
});
=======
    StateNotifierProvider<AdminVerificationController, AdminVerificationState>((
      ref,
    ) {
      return AdminVerificationController(ref);
    });
>>>>>>> repo-b/main

class AdminVerificationState {
  final bool isLoading;
  final int? processingProviderId;
  final String? errorMessage;

  const AdminVerificationState({
    this.isLoading = false,
    this.processingProviderId,
    this.errorMessage,
  });

  AdminVerificationState copyWith({
    bool? isLoading,
    int? processingProviderId,
    String? errorMessage,
  }) {
    return AdminVerificationState(
      isLoading: isLoading ?? this.isLoading,
      processingProviderId: processingProviderId,
      errorMessage: errorMessage,
    );
  }
}

<<<<<<< HEAD
class AdminVerificationController extends StateNotifier<AdminVerificationState> {
  AdminVerificationController(this._ref) : super(const AdminVerificationState());
=======
class AdminVerificationController
    extends StateNotifier<AdminVerificationState> {
  AdminVerificationController(this._ref)
    : super(const AdminVerificationState());
>>>>>>> repo-b/main

  final Ref _ref;

  Future<bool> setVerification({
    required int providerId,
    required bool isVerified,
  }) async {
    state = state.copyWith(
      isLoading: true,
      processingProviderId: providerId,
      errorMessage: null,
    );

    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.updateProviderVerification(
        providerId: providerId,
        isVerified: isVerified,
      );
      // ignore: unused_result
      _ref.refresh(pendingProvidersProvider);
      state = state.copyWith(isLoading: false, processingProviderId: null);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        processingProviderId: null,
        errorMessage: 'Gagal update verifikasi: $e',
      );
      return false;
    }
  }
}
