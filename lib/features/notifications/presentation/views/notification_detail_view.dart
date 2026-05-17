import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../cubit/notification_detail_cubit.dart';

class NotificationDetailView extends StatelessWidget {
  const NotificationDetailView({
    super.key,
    required this.notificationId,
    required this.notificationTitle,
  });

  final String notificationId;
  final String notificationTitle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationDetailCubit(notificationId),
      child: _NotificationDetailContent(
        notificationTitle: notificationTitle,
      ),
    );
  }
}

// ─── Internal content widget ─────────────────────────────────────────────────

class _NotificationDetailContent extends StatelessWidget {
  const _NotificationDetailContent({required this.notificationTitle});

  final String notificationTitle;

  static _NotifStyle _styleFor(String? type, String? title) {
    final t = (type ?? title ?? '').toLowerCase();
    if (t.contains('ride_request') || t.contains('driver request')) {
      return _NotifStyle(
        icon: Icons.directions_car_rounded,
        color: const Color(0xff009EAA),
        label: 'Driver Request',
      );
    } else if (t.contains('cancel')) {
      return _NotifStyle(
        icon: Icons.cancel_rounded,
        color: const Color(0xffD02828),
        label: 'Cancellation',
      );
    } else if (t.contains('arrived') || t.contains('arrival')) {
      return _NotifStyle(
        icon: Icons.location_on_rounded,
        color: const Color(0xff038A37),
        label: 'Driver Arrived',
      );
    } else if (t.contains('payment') || t.contains('wallet')) {
      return _NotifStyle(
        icon: Icons.account_balance_wallet_rounded,
        color: const Color(0xffF9A71A),
        label: 'Payment',
      );
    } else {
      return _NotifStyle(
        icon: Icons.notifications_rounded,
        color: const Color(0xff009EAA),
        label: 'Notification',
      );
    }
  }

  String _formatDate(String? iso, String locale) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final fmt = DateFormat('dd MMM yyyy  •  HH:mm', locale);
      return fmt.format(dt);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xff0F0F0F) : const Color(0xffF5F5F5),
      body: BlocBuilder<NotificationDetailCubit, NotificationDetailState>(
        builder: (context, state) {
          final cubit = context.read<NotificationDetailCubit>();

          if (state is NotificationDetailLoadingState) {
            return _buildLoading(context, isDark);
          }

          if (state is NotificationDetailErrorState) {
            return _buildError(context, state.error, isDark);
          }

          final detail = cubit.detail;
          if (detail == null) return const SizedBox.shrink();

          final style = _styleFor(detail.type, detail.title);
          final lang = context.read<GlobalCubit>().language;

          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop(detail.unreadCount);
              return false;
            },
            child: CustomScrollView(
              slivers: [
                //! Hero App Bar
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: style.color,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () =>
                        Navigator.of(context).pop(detail.unreadCount),
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _AppBarBackground(
                      style: style,
                      isRead: detail.isRead ?? true,
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.rW(context),
                    vertical: 20.rH(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //! Title + unread badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              detail.title ?? '',
                              style: TextStyle(
                                fontSize: 22.rT(context),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Nunito',
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xff141414),
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (detail.isRead == false) ...[
                            const SizedBox(width: 10),
                            _UnreadBadge(color: style.color),
                          ],
                        ],
                      ),

                      SizedBox(height: 8.rH(context)),

                      //! Timestamp
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: AppColors.greyText,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(detail.createdAt, lang),
                            style: TextStyle(
                              fontSize: 12.rT(context),
                              color: AppColors.greyText,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.rH(context)),

                      //! Body message card
                      _InfoCard(
                        isDark: isDark,
                        color: style.color,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.message_rounded,
                                    size: 16,
                                    color: style.color,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Message',
                                    style: TextStyle(
                                      fontSize: 12.rT(context),
                                      fontWeight: FontWeight.w700,
                                      color: style.color,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                detail.body ?? '',
                                style: TextStyle(
                                  fontSize: 15.rT(context),
                                  fontFamily: 'Nunito',
                                  height: 1.6,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.85)
                                      : const Color(0xff374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 14.rH(context)),

                      //! Ride & Driver data
                      if (detail.data != null) ...[
                        _InfoCard(
                          isDark: isDark,
                          color: style.color,
                          child: Column(
                            children: [
                              if (detail.data!.rideId != null)
                                _DataRow(
                                  icon: Icons.directions_rounded,
                                  label: 'Ride ID',
                                  value: '#${detail.data!.rideId}',
                                  color: style.color,
                                  isDark: isDark,
                                  divider: detail.data!.driverId != null,
                                ),
                              if (detail.data!.driverId != null)
                                _DataRow(
                                  icon: Icons.person_rounded,
                                  label: 'Driver ID',
                                  value: '#${detail.data!.driverId}',
                                  color: style.color,
                                  isDark: isDark,
                                  divider: false,
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.rH(context)),
                      ],

                      //! Type & status
                      _InfoCard(
                        isDark: isDark,
                        color: style.color,
                        child: Column(
                          children: [
                            if (detail.type != null)
                              _DataRow(
                                icon: Icons.label_rounded,
                                label: 'Type',
                                value: detail.type!
                                    .replaceAll('_', ' ')
                                    .split(' ')
                                    .map((w) => w.isEmpty
                                        ? ''
                                        : '${w[0].toUpperCase()}${w.substring(1)}')
                                    .join(' '),
                                color: style.color,
                                isDark: isDark,
                                divider: true,
                              ),
                            _DataRow(
                              icon: detail.isRead == true
                                  ? Icons.mark_email_read_rounded
                                  : Icons.mark_email_unread_rounded,
                              label: 'Status',
                              value: detail.isRead == true ? 'Read' : 'Unread',
                              color: detail.isRead == true
                                  ? AppColors.green
                                  : AppColors.yellow,
                              isDark: isDark,
                              divider: false,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.rH(context)),
                    ],
                  ),
                ),
              ),
            ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading(BuildContext context, bool isDark) {
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xff0F0F0F) : const Color(0xffF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20.rW(context),
            vertical: 20.rH(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmer(h: 220.rH(context), w: double.infinity, borderRadius: 0),
              SizedBox(height: 20.rH(context)),
              CustomShimmer(h: 28.rH(context), w: double.infinity, borderRadius: 8),
              SizedBox(height: 10.rH(context)),
              CustomShimmer(h: 14.rH(context), w: 180.rW(context), borderRadius: 8),
              SizedBox(height: 20.rH(context)),
              CustomShimmer(h: 100.rH(context), w: double.infinity, borderRadius: 16),
              SizedBox(height: 14.rH(context)),
              CustomShimmer(h: 80.rH(context), w: double.infinity, borderRadius: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String error, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 64, color: AppColors.greyText),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Styles.regular14(context)
                  .copyWith(color: AppColors.greyText),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _NotifStyle {
  final IconData icon;
  final Color color;
  final String label;
  const _NotifStyle(
      {required this.icon, required this.color, required this.label});
}

class _AppBarBackground extends StatelessWidget {
  final _NotifStyle style;
  final bool isRead;
  const _AppBarBackground({required this.style, required this.isRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            style.color,
            style.color.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Center icon
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(style.icon, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    style.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final Color color;
  const _UnreadBadge({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 7,
            width: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            'New',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final Color color;
  const _InfoCard(
      {required this.child, required this.isDark, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.greyText.withOpacity(0.12)
              : AppColors.grey.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;
  final bool divider;
  const _DataRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyText,
                  fontFamily: 'Nunito',
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xff141414),
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
        ),
        if (divider)
          Divider(
            height: 1,
            color: isDark
                ? AppColors.greyText.withOpacity(0.10)
                : AppColors.grey.withOpacity(0.5),
          ),
      ],
    );
  }
}
