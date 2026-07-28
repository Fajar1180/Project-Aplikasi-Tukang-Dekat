import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_providers.dart';

class AdminVerificationPage extends ConsumerWidget {
  const AdminVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providersAsync = ref.watch(pendingProvidersProvider);
    final actionState = ref.watch(adminVerificationControllerProvider);

    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        title: const Text('Verifikasi Provider'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              // ignore: unused_result
              ref.refresh(pendingProvidersProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
=======
>>>>>>> repo-b/main
      body: providersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (providers) {
          if (providers.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Tidak ada provider yang menunggu verifikasi.'),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
<<<<<<< HEAD
              final isProcessing = actionState.processingProviderId == provider.id;
=======
              final isProcessing =
                  actionState.processingProviderId == provider.id;
>>>>>>> repo-b/main

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            child: Text(
                              (provider.businessName.isNotEmpty
                                      ? provider.businessName[0]
                                      : 'P')
                                  .toUpperCase(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.businessName,
<<<<<<< HEAD
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(provider.ownerName ?? 'Pemilik tidak diketahui'),
=======
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  provider.ownerName ??
                                      'Pemilik tidak diketahui',
                                ),
>>>>>>> repo-b/main
                                const SizedBox(height: 4),
                                Text('Area: ${provider.area ?? '-'}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            label: Text(
<<<<<<< HEAD
                              provider.isVerified ? 'Terverifikasi' : 'Belum diverifikasi',
=======
                              provider.isVerified
                                  ? 'Terverifikasi'
                                  : 'Belum diverifikasi',
>>>>>>> repo-b/main
                            ),
                            backgroundColor: provider.isVerified
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                          ),
<<<<<<< HEAD
                          Chip(label: Text('Rating ${provider.avgRating.toString()}')),
=======
                          Chip(
                            label: Text(
                              'Rating ${provider.avgRating.toString()}',
                            ),
                          ),
>>>>>>> repo-b/main
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isProcessing
                                  ? null
                                  : () async {
                                      final success = await ref
<<<<<<< HEAD
                                          .read(adminVerificationControllerProvider.notifier)
=======
                                          .read(
                                            adminVerificationControllerProvider
                                                .notifier,
                                          )
>>>>>>> repo-b/main
                                          .setVerification(
                                            providerId: provider.id,
                                            isVerified: true,
                                          );
                                      if (success && context.mounted) {
<<<<<<< HEAD
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Provider berhasil diverifikasi'),
=======
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Provider berhasil diverifikasi',
                                            ),
>>>>>>> repo-b/main
                                          ),
                                        );
                                      }
                                    },
                              icon: isProcessing
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
<<<<<<< HEAD
                                      child: CircularProgressIndicator(strokeWidth: 2),
=======
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
>>>>>>> repo-b/main
                                    )
                                  : const Icon(Icons.verified),
                              label: const Text('Verifikasi'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
