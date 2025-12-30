import 'package:flutter/material.dart';

class CommunityHeader extends StatelessWidget {
  final String communityName;
  final String description;
  final int memberCount;
  final String? bannerUrl;
  final String? iconUrl;
  final bool isJoined;
  final VoidCallback onJoinPressed;

  const CommunityHeader({
    super.key,
    required this.communityName,
    required this.description,
    required this.memberCount,
    this.bannerUrl,
    this.iconUrl,
    this.isJoined = false,
    required this.onJoinPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Banner
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
        // Info Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Join Button Row
              Transform.translate(
                offset: const Offset(0, -20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: iconUrl != null ? NetworkImage(iconUrl!) : null,
                        child: iconUrl == null
                            ? Text(
                                communityName[0].toUpperCase(),
                                style: const TextStyle(fontSize: 24, color: Colors.white),
                              )
                            : null,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: FilledButton(
                        onPressed: onJoinPressed,
                        style: FilledButton.styleFrom(
                          backgroundColor: isJoined
                              ? Theme.of(context).colorScheme.outline
                              : Theme.of(context).colorScheme.primary,
                          foregroundColor: isJoined
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text(isJoined ? 'Joined' : 'Join'),
                      ),
                    ),
                  ],
                ),
              ),
              // Name and Stats
              Text(
                'r/$communityName',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '$memberCount members',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              // Description
              Text(
                description,
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
