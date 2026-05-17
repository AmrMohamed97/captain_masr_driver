import 'package:flutter/material.dart';

import '../../../../core/imports/imports.dart';
import '../../data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.model,
    required this.onTap,
  });

  final NotificationModel model;
  final VoidCallback onTap;

  // Map notification type → icon & accent color
  static _NotifStyle _styleFor(String? type, String? title) {
    final t = (type ?? title ?? '').toLowerCase();
    if (t.contains('ride_request') || t.contains('driver request')) {
      return _NotifStyle(
        icon: Icons.directions_car_rounded,
        color: const Color(0xff009EAA), // primary teal
      );
    } else if (t.contains('cancel')) {
      return _NotifStyle(
        icon: Icons.cancel_rounded,
        color: const Color(0xffD02828),
      );
    } else if (t.contains('arrived') || t.contains('arrival')) {
      return _NotifStyle(
        icon: Icons.location_on_rounded,
        color: const Color(0xff038A37),
      );
    } else if (t.contains('payment') || t.contains('wallet')) {
      return _NotifStyle(
        icon: Icons.account_balance_wallet_rounded,
        color: const Color(0xffF9A71A),
      );
    } else {
      return _NotifStyle(
        icon: Icons.notifications_rounded,
        color: const Color(0xff009EAA),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = model.isRead ?? true;
    final style = _styleFor(model.type, model.title);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(
          horizontal: 2.rW(context),
          vertical: 2.rH(context),
        ),
        decoration: BoxDecoration(
          color: isRead
              ? (isDark
                  ? const Color(0xff1E1E1E)
                  : AppColors.white)
              : (isDark
                  ? style.color.withOpacity(0.12)
                  : style.color.withOpacity(0.06)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? (isDark
                    ? AppColors.greyText.withOpacity(0.15)
                    : AppColors.grey.withOpacity(0.5))
                : style.color.withOpacity(0.35),
            width: isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: style.color.withOpacity(isRead ? 0.03 : 0.10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14.rW(context),
            vertical: 14.rH(context),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! Icon Circle
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 46.rH(context),
                    width: 46.rW(context),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          style.color.withOpacity(0.18),
                          style.color.withOpacity(0.30),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      style.icon,
                      color: style.color,
                      size: 22.rT(context),
                    ),
                  ),
                  // Unread dot
                  if (!isRead)
                    PositionedDirectional(
                      top: 0,
                      end: 0,
                      child: Container(
                        height: 11,
                        width: 11,
                        decoration: BoxDecoration(
                          color: style.color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? const Color(0xff1E1E1E)
                                : AppColors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 12.rW(context)),

              //! Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! Title row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            model.title ?? '',
                            style: Styles.semibold14Primary(context).copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color,
                              fontWeight: isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.rW(context)),
                        Text(
                          model.createdAt != null
                              ? timeAgo(
                                  model.createdAt!,
                                  context.read<GlobalCubit>().language,
                                )
                              : '',
                          style: Styles.regular12(context).copyWith(
                            color: AppColors.greyText,
                            fontSize: 11.rT(context),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6.rH(context)),

                    //! Body
                    Text(
                      model.body ?? '',
                      style: Styles.regular14(context).copyWith(
                        color: isDark
                            ? AppColors.greyText
                            : const Color(0xff6B7280),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    //! Type badge (if present)
                    if (model.type != null) ...[
                      SizedBox(height: 8.rH(context)),
                      _TypeBadge(type: model.type!, color: style.color),
                    ],

                    //! Ride/Driver data pill
                    if (model.data != null) ...[
                      SizedBox(height: 8.rH(context)),
                      _DataPill(
                        rideId: model.data!.rideId,
                        driverId: model.data!.driverId,
                        color: style.color,
                        context: context,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Internal helpers ────────────────────────────────────────────────────────

class _NotifStyle {
  final IconData icon;
  final Color color;
  const _NotifStyle({required this.icon, required this.color});
}

class _TypeBadge extends StatelessWidget {
  final String type;
  final Color color;
  const _TypeBadge({required this.type, required this.color});

  String get _label => type
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 10.rT(context),
          fontWeight: FontWeight.w600,
          color: color,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }
}

class _DataPill extends StatelessWidget {
  final int? rideId;
  final int? driverId;
  final Color color;
  final BuildContext context;
  const _DataPill({
    required this.rideId,
    required this.driverId,
    required this.color,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Wrap(
      spacing: 8,
      children: [
        if (rideId != null)
          _Chip(
            label: 'Ride #$rideId',
            icon: Icons.directions_rounded,
            color: color,
          ),
        if (driverId != null)
          _Chip(
            label: 'Driver #$driverId',
            icon: Icons.person_rounded,
            color: color,
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _Chip(
      {required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: color,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }
}
