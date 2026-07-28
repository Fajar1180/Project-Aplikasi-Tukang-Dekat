<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
<<<<<<< HEAD
=======
            WilayahSeeder::class,
>>>>>>> repo-b/main
            ServiceCategorySeeder::class,
            ProviderSeeder::class,
            CustomerSeeder::class,
            AdminSeeder::class,
<<<<<<< HEAD
=======
            TreasurerSeeder::class,
>>>>>>> repo-b/main
        ]);
    }
}
