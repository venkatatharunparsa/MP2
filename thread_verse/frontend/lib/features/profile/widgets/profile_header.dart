import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String bio;
  final int karma;
  final String joinedDate;
  final String? avatarUrl;
  final String? bannerUrl;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.bio,
    required this.karma,
    required this.joinedDate,
    this.avatarUrl,
    this.bannerUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Banner and Avatar
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: bannerUrl != null
                  ? Image.network(
                      bannerUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                    )
                  : null,
            ),
            Positioned(
              bottom: -40,
              left: 16,
              child: CircleAvatar(
                radius: 44,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null
                      ? Text(
                          username[0].toUpperCase(),
                          style: const TextStyle(fontSize: 32, color: Colors.white),
                        )
                      : null,
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: 16,
              child: FilledButton.tonal(
                onPressed: () {},
                child: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        // Info Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'u/$username',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '$karma Karma • Joined $joinedDate',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                bio,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
