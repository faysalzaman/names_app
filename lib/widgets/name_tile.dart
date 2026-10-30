import 'package:flutter/material.dart';
import 'package:names_app/Model/name_model_x.dart';
import 'package:names_app/Model/names_model.dart';

/// One name in a list: initial avatar, name, meaning and Urdu script.
class NameTile extends StatelessWidget {
  const NameTile({
    super.key,
    required this.name,
    required this.onTap,
    this.trailing,
  });

  static const boyColor = Color(0xFF2B6CB0);
  static const girlColor = Color(0xFFC2457F);

  final NameModel name;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = name.isMale ? boyColor : girlColor;
    final meaning = name.meaning;
    final urdu = name.urdu;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.withValues(alpha: 0.14),
                child: Text(
                  name.initial,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (meaning != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        meaning,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (urdu != null) ...[
                const SizedBox(width: 10),
                Text(
                  urdu,
                  style: TextStyle(
                    fontSize: 20,
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(width: 6),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
