<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Payment;
use App\Models\ProviderPayout;
use Illuminate\Support\Facades\DB;
<<<<<<< HEAD
=======
use Illuminate\Support\Facades\Schema;
>>>>>>> repo-b/main
use Carbon\Carbon;

class ProcessProviderPayouts extends Command
{
<<<<<<< HEAD
  protected $signature = 'payouts:process {--dry-run}';
=======
  protected $signature = 'payouts:process {--dry-run=0}';
>>>>>>> repo-b/main
  protected $description = 'Aggregate provider payouts for PAID payments and create payout records';

  public function handle()
  {
    $this->info('Starting provider payouts process...');

<<<<<<< HEAD
    // Find paid payments with provider_payout > 0 and not yet processed
    $payments = Payment::where('status', 'PAID')
      ->where('provider_payout', '>', 0)
      ->where(function ($q) {
        $q->whereNull('provider_payout_processed')->orWhere('provider_payout_processed', false);
      })->get();
=======
    // Find paid payments with provider_payout > 0 and eligible for processing.
    $payments = Payment::with('order')
      ->where('status', 'PAID')
      ->where('provider_payout', '>', 0)
      ->get()
      ->filter(function ($payment) {
        if (!$payment->order || !$payment->order->provider_id) {
          return false;
        }

        if (!Schema::hasColumn('payments', 'provider_payout_processed')) {
          return true;
        }

        return (int) ($payment->provider_payout_processed ?? 0) === 0;
      })
      ->values();

    $this->info('Found ' . $payments->count() . ' eligible payments for payout processing.');
>>>>>>> repo-b/main

    if ($payments->isEmpty()) {
      $this->info('No payouts to process.');
      return 0;
    }

<<<<<<< HEAD
    $grouped = $payments->groupBy('order.provider_id');
=======
    // Group by provider_id from related order
    $grouped = $payments->groupBy(function ($payment) {
      return $payment->order->provider_id;
    });
    $isDryRun = filter_var($this->option('dry-run'), FILTER_VALIDATE_BOOLEAN);
>>>>>>> repo-b/main

    DB::beginTransaction();
    try {
      foreach ($grouped as $providerId => $group) {
        $sum = $group->sum('provider_payout');
        $paymentIds = $group->pluck('id')->values()->all();

        $this->info("Creating payout for provider {$providerId} amount {$sum}");

<<<<<<< HEAD
        if (!$this->option('dry-run')) {
=======
        if (!$isDryRun) {
>>>>>>> repo-b/main
          $payout = ProviderPayout::create([
            'provider_id' => $providerId,
            'amount' => $sum,
            'payment_ids' => $paymentIds,
            'status' => 'PENDING',
          ]);

          // mark payments processed
<<<<<<< HEAD
          Payment::whereIn('id', $paymentIds)->update([
            'provider_payout_processed' => true,
            'provider_paid_at' => Carbon::now(),
          ]);
=======
          $updateData = [];
          if (Schema::hasColumn('payments', 'provider_paid_at')) {
            $updateData['provider_paid_at'] = Carbon::now();
          }
          if (Schema::hasColumn('payments', 'provider_payout_processed')) {
            $updateData['provider_payout_processed'] = true;
          }

          if (!empty($updateData)) {
            Payment::whereIn('id', $paymentIds)->update($updateData);
          }
>>>>>>> repo-b/main
        }
      }

      DB::commit();
      $this->info('Provider payouts aggregated successfully.');
    } catch (\Exception $e) {
      DB::rollBack();
      $this->error('Error processing payouts: ' . $e->getMessage());
      return 1;
    }

    return 0;
  }
}
