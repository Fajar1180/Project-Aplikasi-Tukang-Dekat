<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/api_service.dart';
import '../../core/models/order_model.dart';
import '../../core/models/review_model.dart';

=======
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/services/api_service.dart';

import '../../core/models/order_model.dart';
import '../../core/models/review_model.dart';


final myOrdersStatusFilterProvider = StateProvider<String?>((ref) => null);

>>>>>>> repo-b/main
// My orders provider
final myOrdersProvider = FutureProvider<List<OrderData>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getMyOrders();
  return response.data;
});

// Order detail provider
<<<<<<< HEAD
final orderDetailProvider = FutureProvider.family<OrderData, int>((ref, orderId) async {
=======
final orderDetailProvider = FutureProvider.family<OrderData, int>((
  ref,
  orderId,
) async {
>>>>>>> repo-b/main
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getOrderDetail(orderId);
});

<<<<<<< HEAD
final orderReviewProvider = FutureProvider.family<ReviewData?, int>((ref, orderId) async {
=======
final orderReviewProvider = FutureProvider.family<ReviewData?, int>((
  ref,
  orderId,
) async {
>>>>>>> repo-b/main
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getOrderReview(orderId);
});

// Create order controller
<<<<<<< HEAD
final createOrderControllerProvider = StateNotifierProvider<CreateOrderController, CreateOrderState>((ref) {
  return CreateOrderController(ref);
});
=======
final createOrderControllerProvider =
    StateNotifierProvider<CreateOrderController, CreateOrderState>((ref) {
      return CreateOrderController(ref);
    });
>>>>>>> repo-b/main

class CreateOrderState {
  final bool isLoading;
  final String? errorMessage;
  final OrderData? createdOrder;
<<<<<<< HEAD
=======
  final Map<String, String?> fieldErrors;
>>>>>>> repo-b/main

  const CreateOrderState({
    this.isLoading = false,
    this.errorMessage,
    this.createdOrder,
<<<<<<< HEAD
=======
    this.fieldErrors = const {},
>>>>>>> repo-b/main
  });

  CreateOrderState copyWith({
    bool? isLoading,
    String? errorMessage,
    OrderData? createdOrder,
<<<<<<< HEAD
=======
    Map<String, String?>? fieldErrors,
>>>>>>> repo-b/main
  }) {
    return CreateOrderState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      createdOrder: createdOrder ?? this.createdOrder,
<<<<<<< HEAD
=======
      fieldErrors: fieldErrors ?? this.fieldErrors,
>>>>>>> repo-b/main
    );
  }
}

class CreateOrderController extends StateNotifier<CreateOrderState> {
  CreateOrderController(this._ref) : super(const CreateOrderState());

  final Ref _ref;

  Future<bool> createOrder(CreateOrderRequest request) async {
<<<<<<< HEAD
    state = state.copyWith(isLoading: true, errorMessage: null);
=======
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      fieldErrors: {},
    );
>>>>>>> repo-b/main
    try {
      final apiService = _ref.read(apiServiceProvider);
      final order = await apiService.createOrder(request);
      state = state.copyWith(
        isLoading: false,
        createdOrder: order,
<<<<<<< HEAD
=======
        fieldErrors: {},
>>>>>>> repo-b/main
      );
      // Refresh myOrdersProvider to show newly created order
      _ref.refresh(myOrdersProvider); // ignore: unused_result
      return true;
<<<<<<< HEAD
=======
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (e.response?.statusCode == 422 &&
          responseData is Map<String, dynamic>) {
        final fieldErrors = <String, String?>{};
        final errors = responseData['errors'];
        if (errors is Map<String, dynamic>) {
          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              fieldErrors[key] = value.first?.toString();
            } else if (value != null) {
              fieldErrors[key] = value.toString();
            }
          });
        }
        state = state.copyWith(
          isLoading: false,
          errorMessage: responseData['message'] ?? 'Order validation failed',
          fieldErrors: fieldErrors,
        );
        return false;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create order: ${e.message}',
      );
      return false;
>>>>>>> repo-b/main
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create order: $e',
      );
      return false;
    }
  }

  void reset() {
    state = const CreateOrderState();
  }
}

// Order action controller (untuk provider accept/start/complete)
<<<<<<< HEAD
final orderActionControllerProvider = StateNotifierProvider<OrderActionController, OrderActionState>((ref) {
  return OrderActionController(ref);
});
=======
final orderActionControllerProvider =
    StateNotifierProvider<OrderActionController, OrderActionState>((ref) {
      return OrderActionController(ref);
    });
>>>>>>> repo-b/main

class OrderActionState {
  final bool isLoading;
  final String? errorMessage;
  final bool success;

  const OrderActionState({
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
  });

  OrderActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? success,
  }) {
    return OrderActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }
}

class OrderActionController extends StateNotifier<OrderActionState> {
  OrderActionController(this._ref) : super(const OrderActionState());

  final Ref _ref;

  Future<bool> respondToOrder(int orderId, String action) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
<<<<<<< HEAD
=======

    // Jika provider mau menerima order, wajib cek lokasi provider.
    if (action == 'accept') {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Lokasi wajib aktif untuk menerima pesanan (GPS tidak aktif).',
        );
        return false;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Lokasi wajib aktif untuk menerima pesanan (izin lokasi belum diberikan).',
        );
        return false;
      }
    }

>>>>>>> repo-b/main
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.respondToOrder(orderId: orderId, action: action);
      state = state.copyWith(isLoading: false, success: true);
      // Refresh orders after responding
      _ref.refresh(myOrdersProvider); // ignore: unused_result
      return true;
    } catch (e) {
<<<<<<< HEAD
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed: $e',
      );
=======
      state = state.copyWith(isLoading: false, errorMessage: 'Failed: $e');
>>>>>>> repo-b/main
      return false;
    }
  }

  Future<bool> startWork(int orderId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.startWork(orderId);
      state = state.copyWith(isLoading: false, success: true);
      // Refresh orders after starting work
      _ref.refresh(myOrdersProvider); // ignore: unused_result
      return true;
<<<<<<< HEAD
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed: $e',
      );
=======
    } on DioException catch (e) {
      String errorMsg = 'Gagal memulai pekerjaan';
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data['message'] != null) {
          errorMsg = data['message'].toString();
        } else {
          errorMsg =
              'DP harus dibayar terlebih dahulu sebelum memulai pekerjaan';
        }
      }
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Gagal: $e');
>>>>>>> repo-b/main
      return false;
    }
  }

<<<<<<< HEAD
  Future<bool> completeOrder(int orderId, int finalPrice) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.completeOrder(orderId: orderId, finalPrice: finalPrice);
=======
  Future<bool> completeOrder(
    int orderId,
    int finalPrice, {
    List<MultipartFile> initialConditionPhotos = const [],
    List<MultipartFile> finalConditionPhotos = const [],
    List<MultipartFile> receiptPhotos = const [],
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.completeOrder(
        orderId: orderId,
        finalPrice: finalPrice,
        initialConditionPhotos: initialConditionPhotos,
        finalConditionPhotos: finalConditionPhotos,
        receiptPhotos: receiptPhotos,
      );
>>>>>>> repo-b/main
      state = state.copyWith(isLoading: false, success: true);
      // Refresh orders after completing
      _ref.refresh(myOrdersProvider); // ignore: unused_result
      return true;
    } catch (e) {
<<<<<<< HEAD
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed: $e',
      );
=======
      state = state.copyWith(isLoading: false, errorMessage: 'Failed: $e');
      return false;
    }
  }

  Future<bool> cancelOrder(int orderId, {String? reason}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.cancelOrder(orderId: orderId, reason: reason);
      state = state.copyWith(isLoading: false, success: true);
      _ref.refresh(myOrdersProvider); // ignore: unused_result
      return true;
    } on DioException catch (e) {
      String errorMsg = 'Gagal membatalkan pesanan';
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        errorMsg = data['message'].toString();
      }
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Gagal: $e');
>>>>>>> repo-b/main
      return false;
    }
  }

  void reset() {
    state = const OrderActionState();
  }
}
