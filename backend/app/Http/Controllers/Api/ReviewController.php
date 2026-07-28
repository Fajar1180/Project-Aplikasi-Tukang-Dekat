<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
<<<<<<< HEAD
use App\Models\Order;
use App\Models\Review;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ReviewController extends Controller
{
  /**
   * Create review untuk order
   */
  public function createReview(Request $request, $orderId)
  {
    $user = Auth::user();

    if ($user->role !== 'CUSTOMER') {
      return response()->json([
        'message' => 'only customer can create review',
      ], 403);
    }

    $order = Order::find($orderId);

    if (!$order) {
      return response()->json([
        'message' => 'order not found',
      ], 404);
    }

    if ($order->customer_id !== $user->id) {
      return response()->json([
        'message' => 'unauthorized',
      ], 403);
    }

    if ($order->status !== 'COMPLETED' && $order->status !== 'CLOSED') {
      return response()->json([
        'message' => 'order not completed yet',
      ], 400);
    }

    // Check apakah sudah ada review
    if ($order->review) {
      return response()->json([
        'message' => 'review already exists for this order',
      ], 400);
    }

    $validated = $request->validate([
      'rating' => 'required|integer|between:1,5',
      'comment' => 'nullable|string',
    ]);

    $review = Review::create([
      'order_id' => $order->id,
      'customer_id' => $user->id,
      'provider_id' => $order->provider_id,
      'rating' => $validated['rating'],
      'comment' => $validated['comment'] ?? null,
    ]);

    // Update provider avg_rating
    $providerProfile = $order->provider->providerProfile;
    if ($providerProfile) {
      $avgRating = Review::where('provider_id', $order->provider_id)->avg('rating');
      $providerProfile->update(['avg_rating' => round($avgRating, 2)]);
    }

    return response()->json([
      'message' => 'review created',
      'data' => $review,
    ], 201);
  }

  /**
   * Get reviews untuk provider
   */
  public function getProviderReviews($providerId)
  {
    $reviews = Review::where('provider_id', $providerId)
      ->with(['customer', 'order'])
      ->latest()
      ->get();

    return response()->json([
      'data' => $reviews,
    ], 200);
  }

  /**
   * Get review untuk order
   */
  public function getOrderReview($orderId)
  {
    $review = Review::where('order_id', $orderId)
      ->with(['customer', 'provider'])
      ->first();

    if (!$review) {
      return response()->json([
        'message' => 'review not found',
      ], 404);
    }

    return response()->json([
      'data' => $review,
    ], 200);
  }
=======
use App\Http\Requests\Review\CreateReviewRequest;
use App\Models\Order;
use App\Models\Review;
use App\Models\ProviderProfile;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ReviewController extends Controller
{
    use ApiResponse;

    public function createReview(CreateReviewRequest $request, $orderId)
    {
        $user = Auth::user();

        $order = Order::find($orderId);

        if (!$order) {
            return $this->notFound('Order not found');
        }

        if ($order->customer_id !== $user->id) {
            return $this->forbidden('You can only review your own orders');
        }

        if ($order->status !== 'CLOSED') {
            return $this->conflict('Reviews can only be submitted for closed orders');
        }

        $existing = Review::where('order_id', $orderId)->first();
        if ($existing) {
            return $this->conflict('A review has already been submitted for this order');
        }

        $validated = $request->validated();

        try {
            $review = DB::transaction(function () use ($order, $validated, $user) {
                $review = Review::create([
                    'order_id' => $order->id,
                    'customer_id' => $user->id,
                    'provider_id' => $order->provider_id,
                    'rating' => $validated['rating'],
                    'comment' => $validated['comment'] ?? null,
                ]);

                $this->recalculateProviderRating($order->provider_id);

                return $review;
            });

            return $this->success([
                'review_id' => $review->id,
                'rating' => $review->rating,
                'comment' => $review->comment,
            ], 'Review submitted successfully', 201);
        } catch (\Throwable $e) {
            Log::error('Create review error: ' . $e->getMessage());
            return $this->internalServerError('Failed to submit review');
        }
    }

    public function getOrderReview($orderId)
    {
        $review = Review::where('order_id', $orderId)
            ->with(['customer:id,name', 'provider:id,name'])
            ->first();

        if (!$review) {
            return $this->notFound('Review not found for this order');
        }

        return $this->success($review, 'Review retrieved');
    }

    public function getProviderReviews($providerId)
    {
        $perPage = request()->query('per_page', 20);

        $provider = ProviderProfile::find($providerId);
        if (!$provider) {
            return $this->notFound('Provider not found');
        }

        $reviews = Review::where('provider_id', $provider->user_id)
            ->with('customer:id,name')
            ->latest()
            ->paginate($perPage);

        $avgRating = Review::where('provider_id', $provider->user_id)->avg('rating');
        $reviewCount = Review::where('provider_id', $provider->user_id)->count();

        return $this->success([
            'reviews' => $reviews->items(),
            'average_rating' => round($avgRating ?? 0, 2),
            'review_count' => $reviewCount,
            'meta' => [
                'current_page' => $reviews->currentPage(),
                'last_page' => $reviews->lastPage(),
                'per_page' => $reviews->perPage(),
                'total' => $reviews->total(),
            ],
        ], 'Provider reviews retrieved');
    }

    private function recalculateProviderRating(int $providerId): void
    {
        $avgRating = Review::where('provider_id', $providerId)->avg('rating') ?? 0;

        ProviderProfile::where('user_id', $providerId)->update([
            'avg_rating' => round($avgRating, 2),
        ]);
    }
>>>>>>> repo-b/main
}
