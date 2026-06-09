import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../../../../core/imports/imports.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import 'luggages_row.dart';
import 'rider_details_and_cost.dart';

class RequestForDriverCard extends StatefulWidget {
  const RequestForDriverCard({
    super.key,
    required this.model,
    required this.acceptOnTap,
    required this.acceptRiderOffer,
    required this.declineOnTap,
  });

  final TripDetailsModel model;
  final Future<bool> Function(num? biddingPrice) acceptOnTap, acceptRiderOffer;
  final Function() declineOnTap;

  @override
  State<RequestForDriverCard> createState() => _RequestForDriverCardState();
}

class _RequestForDriverCardState extends State<RequestForDriverCard> {
  late double _biddingPrice;

  // Firebase listener
  StreamSubscription<DatabaseEvent>? _driversSubscription;
  Map<dynamic, dynamic>? _driversSnapshot;

  // Countdown timer (Case D)
  bool _isCountingDown = false;
  int _countdown = 20;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _biddingPrice = (widget.model.price ?? 0.0).toDouble();
    _startFirebaseListener();
  }

  void _startFirebaseListener() {
    final rideId = widget.model.rideId ?? widget.model.id ?? 0;
    if (rideId == 0) return;
    final ref = FirebaseDatabase.instance.ref('ride_requests/$rideId/drivers');
    _driversSubscription = ref.onValue.listen((event) {
      if (!mounted) return;
      final data = event.snapshot.value;
      setState(() {
        _driversSnapshot = data is Map ? data : null;
      });
      // Check if we should start/stop countdown
      _evaluateCountdown();
    });
  }

  void _evaluateCountdown() {
    final driverId = _getDriverId();
    if (driverId == null || _driversSnapshot == null) {
      _stopCountdown();
      return;
    }
    final driverData = _driversSnapshot![driverId] as Map?;
    final negotiationMap = driverData?['negotiation'] as Map?;

    final firebaseRequestSent = negotiationMap?['request_sent'];
    final combinedRequestSent =
        firebaseRequestSent ?? widget.model.negotiation?.requestSent;

    final rawRiderPrice = negotiationMap?['rider_price'];
    final firebaseRiderPrice = rawRiderPrice is num
        ? rawRiderPrice
        : (rawRiderPrice is String ? num.tryParse(rawRiderPrice) : null);
    final combinedRiderPrice =
        firebaseRiderPrice ?? widget.model.negotiation?.riderPrice;

    if (combinedRequestSent != null && combinedRiderPrice == null) {
      // Case D — start countdown if not already running
      if (!_isCountingDown) {
        _startCountdown();
      }
    } else {
      _stopCountdown();
    }
  }

  void _startCountdown() {
    _isCountingDown = true;
    _countdown = 20;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        _stopCountdown();
      }
    });
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    if (mounted) {
      setState(() {
        _isCountingDown = false;
        _countdown = 20;
      });
    }
  }

  String? _getDriverId() {
    final id = BlocProvider.of<GlobalCubit>(context).userModel?.id;
    return id?.toString();
  }

  @override
  void dispose() {
    _driversSubscription?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine card state from Firebase snapshot
    final driverIdStr = _getDriverId();
    final bool driverInMap =
        _driversSnapshot != null &&
        driverIdStr != null &&
        _driversSnapshot!.containsKey(driverIdStr);

    Map<dynamic, dynamic>? negotiationMap;
    num? riderPrice;
    dynamic requestSent;

    if (driverInMap) {
      final driverData = _driversSnapshot![driverIdStr] as Map?;
      negotiationMap = driverData?['negotiation'] as Map?;
      final rawRiderPrice = negotiationMap?['rider_price'];
      riderPrice = rawRiderPrice is num
          ? rawRiderPrice
          : (rawRiderPrice is String ? num.tryParse(rawRiderPrice) : null);
      requestSent = negotiationMap?['request_sent'];
    }

    final combinedRiderPrice =
        riderPrice ?? widget.model.negotiation?.riderPrice;
    final combinedRequestSent =
        requestSent ?? widget.model.negotiation?.requestSent;

    // Case D: requestSent != null (waiting for rider confirmation → countdown)
    final bool isCaseD =
        driverInMap &&
        combinedRequestSent != null &&
        combinedRiderPrice == null;
    // Case B: driver in map, no riderPrice, no requestSent (waiting for rider response)
    final bool isCaseB =
        driverInMap &&
        combinedRiderPrice == null &&
        combinedRequestSent == null;
    // Case C: driver in map + riderPrice != null
    final bool isCaseC = driverInMap && combinedRiderPrice != null;
    // Case A: driver NOT in map → show full negotiation
    final bool isCaseA = !driverInMap;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.rH(context)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //! Title
          Padding(
            padding: EdgeInsets.only(
              top: 13.rH(context),
              bottom: 11.rH(context),
            ),
            child: Text(
              widget.model.tripType == "classic trip"
                  ? AppStrings.classicRide.tr(context)
                  : widget.model.tripType == "group trip"
                  ? AppStrings.groupRide.tr(context)
                  : widget.model.tripType == "share trip"
                  ? AppStrings.shareRide.tr(context)
                  : widget.model.tripType == "delivery"
                  ? AppStrings.delivery.tr(context)
                  : "",
              style: Styles.semibold16Primary(
                context,
              ).copyWith(color: AppColors.white),
            ),
          ),
          //! Content
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8.rH(context)),
                //! Riders Details & Cost
                RiderDetailsAndCost(model: widget.model),

                //! Luggages
                if (widget.model.smallCount != 0 ||
                    widget.model.mediumCount != 0 ||
                    widget.model.largeCount != 0)
                  LuggagesRow(tripDetails: widget.model),

                //! Divider
                CustomDivider(space: 2.rH(context)),

                //! Start & End Points
                StartAndEndPoint(
                  startValue: widget.model.pickupAddress ?? "??",
                  endValue: widget.model.dropoffAddress ?? "??",
                  startTitle: AppStrings.startPoint.tr(context),
                ),

                //! Divider
                CustomDivider(space: 2.rH(context)),

                //! Distance & Duration
                DistanceAndDuration(
                  distance: widget.model.distanceKm?.toString() ?? "??",
                  duration: widget.model.timeMinutes?.toString() ?? "??",
                ),

                SizedBox(height: 14.rH(context)),

                //! ─── CASE A: Driver not in map → full negotiation panel ───
                if (isCaseA) ...[
                  _buildNegotiationPanel(context),
                  SizedBox(height: 14.rH(context)),
                  _buildActionButtons(
                    context,
                    disabled: false,
                    useRiderOffer: widget.model.negotiation?.riderPrice != null,
                  ),
                ]
                //! ─── CASE B: Waiting for rider response ───
                else if (isCaseB) ...[
                  _buildWaitingPanel(
                    context,
                    message: AppStrings.waitingRiderResponse.tr(context),
                    subMessage:
                        '${AppStrings.sentPrice.tr(context)}: $_biddingPrice  ${AppStrings.egp.tr(context)}',
                    icon: Icons.hourglass_top_rounded,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 14.rH(context)),
                  _buildActionButtons(
                    context,
                    disabled: true,
                    useRiderOffer: false,
                  ),
                ]
                //! ─── CASE C: Rider sent offer → show riderPrice + accept/decline ───
                else if (isCaseC) ...[
                  _buildRiderOfferPanel(
                    context,
                    riderPrice: combinedRiderPrice ?? 0,
                  ),
                  SizedBox(height: 14.rH(context)),
                  _buildActionButtons(
                    context,
                    disabled: false,
                    useRiderOffer: true,
                    firebaseRiderPrice: combinedRiderPrice ?? 0,
                  ),
                ]
                //! ─── CASE D: Request sent → countdown waiting for confirmation ───
                else if (isCaseD) ...[
                  _buildWaitingPanel(
                    context,
                    message: AppStrings.waitingRiderConfirmation.tr(context),
                    subMessage: _isCountingDown ? '$_countdown s' : '',
                    icon: Icons.timer_outlined,
                    color: AppColors.yellow,
                    showCountdown: _isCountingDown,
                    countdown: _countdown,
                  ),
                  SizedBox(height: 14.rH(context)),
                  _buildActionButtons(
                    context,
                    disabled: true,
                    useRiderOffer: false,
                  ),
                ],

                SizedBox(height: 13.rH(context)),
              ],
            ),
          ),

          SizedBox(height: 1.rH(context)),
        ],
      ),
    );
  }

  // ─── Negotiation panel (Case A + when riderPrice == null from model) ────────
  Widget _buildNegotiationPanel(BuildContext context) {
    if (widget.model.negotiation?.riderPrice != null) {
      return _buildRiderOfferPanel(
        context,
        riderPrice: widget.model.negotiation!.riderPrice!,
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.rW(context),
        vertical: 12.rH(context),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.black.withOpacity(0.3)
            : AppColors.grey3.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.grey.withOpacity(0.2)
              : AppColors.grey,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${AppStrings.negotiatePrice.tr(context)}:',
                  style: Styles.semibold14Primary(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                SizedBox(width: 10.rH(context)),
                //! Decrement Button
                IconButton(
                  onPressed: _biddingPrice <= 0.0
                      ? null
                      : () {
                          setState(() {
                            _biddingPrice -= 5;
                            if (_biddingPrice < 0.0) _biddingPrice = 0.0;
                          });
                        },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: _biddingPrice <= 0.0
                        ? AppColors.grey
                        : AppColors.primary,
                  ),
                  iconSize: 32.rW(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: 20.rW(context)),
                //! Current Bid Price Display
                Text(
                  "${_biddingPrice.toStringAsFixed(0)} ${AppStrings.egp.tr(context)}",
                  style: Styles.semibold20Primary(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20.rW(context)),
                //! Increment Button
                IconButton(
                  onPressed: () {
                    setState(() => _biddingPrice += 5);
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primary,
                  ),
                  iconSize: 32.rW(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.rH(context)),
          //! Quick Action Pills
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [5, 10, 20].map((increment) {
              final pillPrice =
                  (widget.model.price ?? 0.0).toDouble() + increment;
              final isSelected = _biddingPrice == pillPrice;
              return InkWell(
                onTap: () {
                  setState(() => _biddingPrice = pillPrice);
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.rW(context),
                    vertical: 8.rH(context),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.black.withOpacity(0.5)
                              : AppColors.white),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (Theme.of(context).brightness == Brightness.dark
                                ? AppColors.grey.withOpacity(0.3)
                                : AppColors.grey),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "+$increment ${AppStrings.egp.tr(context)}",
                    style: Styles.semibold12(context).copyWith(
                      color: isSelected
                          ? AppColors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Rider Offer Panel (Case C) ──────────────────────────────────────────────
  Widget _buildRiderOfferPanel(
    BuildContext context, {
    required num riderPrice,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 10.rH(context),
        horizontal: 12.rW(context),
      ),
      margin: EdgeInsets.only(bottom: 12.rH(context)),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.newRiderOffer.tr(context),
            style: Styles.semibold14Primary(
              context,
            ).copyWith(color: AppColors.green),
          ),
          Row(
            children: [
              Text(
                " $riderPrice ${AppStrings.egp.tr(context)}",
                style: Styles.semibold14Primary(
                  context,
                ).copyWith(color: AppColors.green, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8.rW(context)),
              Icon(
                Icons.local_offer,
                color: AppColors.green,
                size: 20.rW(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Waiting Panel (Case B & D) ──────────────────────────────────────────────
  Widget _buildWaitingPanel(
    BuildContext context, {
    required String message,
    required String subMessage,
    required IconData icon,
    required Color color,
    bool showCountdown = false,
    int countdown = 20,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 14.rH(context),
        horizontal: 12.rW(context),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24.rW(context)),
          SizedBox(width: 10.rW(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: Styles.semibold14Primary(
                    context,
                  ).copyWith(color: color),
                ),
                if (subMessage.isNotEmpty) ...[
                  SizedBox(height: 4.rH(context)),
                  Text(
                    subMessage,
                    style: Styles.semibold12(
                      context,
                    ).copyWith(color: color.withOpacity(0.8)),
                  ),
                ],
              ],
            ),
          ),
          if (showCountdown)
            Container(
              width: 44.rW(context),
              height: 44.rW(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.12),
                border: Border.all(color: color, width: 2),
              ),
              child: Center(
                child: Text(
                  '$countdown',
                  style: Styles.semibold14Primary(
                    context,
                  ).copyWith(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Action Buttons ──────────────────────────────────────────────────────────
  Widget _buildActionButtons(
    BuildContext context, {
    required bool disabled,
    required bool useRiderOffer,
    num? firebaseRiderPrice,
  }) {
    return Row(
      children: [
        //! Decline
        Expanded(
          child: CustomButton(
            onPressed: disabled ? () {} : widget.declineOnTap,
            title: AppStrings.decline.tr(context),
            color: AppColors.transparent,
            textColor: disabled ? AppColors.grey : AppColors.primary,
            borderColor: disabled ? AppColors.grey : AppColors.primary,
            enabled: !disabled,
          ),
        ),
        SizedBox(width: 22.rW(context)),
        //! Accept
        Expanded(
          child: CustomButton(
            onPressed: disabled
                ? () {}
                : () async {
                    if (!useRiderOffer) {
                      await widget.acceptOnTap(_biddingPrice);
                    } else {
                      // Prefer Firebase riderPrice, fallback to model
                      final price =
                          firebaseRiderPrice ??
                          widget.model.negotiation?.riderPrice;
                      await widget.acceptRiderOffer(price);
                    }
                  },
            title: AppStrings.accept.tr(context),
            enabled: !disabled,
          ),
        ),
      ],
    );
  }
}
