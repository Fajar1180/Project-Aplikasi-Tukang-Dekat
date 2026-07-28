<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\ProviderProfile;
use App\Models\ProviderService;
<<<<<<< HEAD
use Illuminate\Support\Facades\Hash;

=======
use App\Models\ProviderCoverage;
use App\Models\ServiceCategory;
use App\Models\WilayahKota;
use App\Models\WilayahKecamatan;
use Illuminate\Support\Facades\Hash;


>>>>>>> repo-b/main
class ProviderSeeder extends Seeder
{
  /**
   * Run the database seeds.
   */
  public function run(): void
  {
    // Create sample providers
    $providers = [
      [
        'user' => [
          'name' => 'Tukang Listrik Andi',
          'email' => 'andi.listrik@example.com',
          'phone' => '081234567890',
        ],
        'profile' => [
          'business_name' => 'Andi Jasa Listrik',
          'description' => 'Berpengalaman 10 tahun di bidang listrik',
          'area' => 'Bojongloa Kaler',
          'address' => 'Jl. Merdeka No. 123',
        ],
<<<<<<< HEAD
        'category_ids' => [1],
=======
        'coverage_city' => 'Bandung',
        'category_ids' => ['Listrik'],
>>>>>>> repo-b/main
      ],
      [
        'user' => [
          'name' => 'Tukang Plumbing Budi',
          'email' => 'budi.plumbing@example.com',
          'phone' => '081298765432',
        ],
        'profile' => [
          'business_name' => 'Budi Plumbing Service',
          'description' => 'Ahli sistem perpipaan dan air',
          'area' => 'Bojongloa Kaler',
          'address' => 'Jl. Ahmad Yani No. 456',
        ],
<<<<<<< HEAD
        'category_ids' => [2],
=======
        'coverage_city' => 'Bandung',
        'category_ids' => ['Plumbing'],
>>>>>>> repo-b/main
      ],
      [
        'user' => [
          'name' => 'Teknisi AC Citra',
          'email' => 'citra.ac@example.com',
          'phone' => '081345678901',
        ],
        'profile' => [
          'business_name' => 'Citra AC Service',
          'description' => 'Spesialis service AC semua merk',
          'area' => 'Bojongloa Kaler',
          'address' => 'Jl. Sudirman No. 789',
        ],
<<<<<<< HEAD
        'category_ids' => [3],
=======
        'coverage_city' => 'Bandung',
        'category_ids' => ['AC'],
>>>>>>> repo-b/main
      ],
    ];

    foreach ($providers as $providerData) {
      $categoryIds = $providerData['category_ids'];
      $userData = $providerData['user'];
      $profileData = $providerData['profile'];

<<<<<<< HEAD
      // Create user
      $user = User::create(array_merge($userData, [
        'password' => Hash::make('password123'),
        'role' => 'PROVIDER',
        'status' => 'ACTIVE',
      ]));

      // Create provider profile
      $profile = ProviderProfile::create(array_merge($profileData, [
        'user_id' => $user->id,
        'is_verified' => true,
        'avg_rating' => 0,
      ]));

      // Create services
      foreach ($categoryIds as $categoryId) {
        ProviderService::create([
          'provider_profile_id' => $profile->id,
          'category_id' => $categoryId,
          'name' => 'Service Standard',
          'base_price' => 150000,
          'price_unit' => 'per kunjungan',
          'is_active' => true,
        ]);
=======
      // Create or update user by unique email
      $user = User::updateOrCreate(
        ['email' => $userData['email']],
        array_merge($userData, [
          'password' => Hash::make('password123'),
          'role' => 'PROVIDER',
          'status' => 'ACTIVE',
        ])
      );

      // Create or update provider profile
      $profile = ProviderProfile::updateOrCreate(
        ['user_id' => $user->id],
        array_merge($profileData, [
          'is_verified' => true,
          'is_active' => true,
          'avg_rating' => 0,
        ])
      );

      // Create or update services to keep them active
      foreach ($categoryIds as $categoryName) {
        $category = ServiceCategory::where('name', $categoryName)->first();
        if (!$category) {
          // If categories haven't been seeded (or name mismatch), skip to avoid FK violation
          continue;
        }

        ProviderService::updateOrCreate(
          [
            'provider_profile_id' => $profile->id,
            'category_id' => $category->id,
            'name' => 'Service Standard',
          ],
          [
            'base_price' => 150000,
            'price_unit' => 'per kunjungan',
            'is_active' => true,
          ],
        );
      }

      // Provider contoh beroperasi di Bandung. Simpan cakupan kecamatan agar
      // pencarian customer berdasarkan kota/kecamatan memakai data yang sama
      // dengan validasi saat membuat order.
      $city = WilayahKota::where('name', $providerData['coverage_city'])->first();
      if ($city) {
        $districts = WilayahKecamatan::where('kota_id', $city->id)->get();
        foreach ($districts as $district) {
          ProviderCoverage::updateOrCreate(
            [
              'provider_profile_id' => $profile->id,
              'kecamatan_id' => $district->id,
            ],
            ['is_active' => true],
          );
        }
>>>>>>> repo-b/main
      }
    }
  }
}
