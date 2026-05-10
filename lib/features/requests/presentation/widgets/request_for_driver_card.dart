import 'dart:async';

import '../../../../core/imports/imports.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import 'luggages_row.dart';
import 'rider_details_and_cost.dart';

class RequestForDriverCard extends StatefulWidget {
  const RequestForDriverCard({
    super.key,
    required this.model,
    required this.acceptOnTap,
    required this.declineOnTap,
  });

  final TripDetailsModel model;
  final Future<bool> Function() acceptOnTap;
  final Function() declineOnTap;

  @override
  State<RequestForDriverCard> createState() => _RequestForDriverCardState();
}

class _RequestForDriverCardState extends State<RequestForDriverCard> {
  bool _isCountingDown = false;
  int _countdown = 10;
  Timer? _timer;

  void _startCountdown() {
    setState(() {
      _isCountingDown = true;
      _countdown = 12;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        if (mounted) {
          setState(() {
            _isCountingDown = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              style: Styles.semibold16Primary(context).copyWith(
                color: AppColors.white,
              ),
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
                SizedBox(height: 21.rH(context)),
                //! Riders Details & Cost
                RiderDetailsAndCost(model: widget.model),

                //! Luggages
                if (widget.model.smallCount != 0 ||
                    widget.model.mediumCount != 0 ||
                    widget.model.largeCount != 0)
                  LuggagesRow(
                    tripDetails: widget.model,
                  ),

                //! Divider
                CustomDivider(space: 12.rH(context)),

                //! Start & End Points
                StartAndEndPoint(
                  startValue: widget.model.pickupAddress ?? "??",
                  endValue: widget.model.dropoffAddress ?? "??",
                  startTitle: AppStrings.startPoint.tr(context),
                ),

                //! Divider
                CustomDivider(space: 12.rH(context)),

                //! Distantance & Duration
                DistanceAndDuration(
                  distance: widget.model.distanceKm?.toString() ?? "??",
                  duration: widget.model.timeMinutes?.toString() ?? "??",
                ),

                SizedBox(height: 20.rH(context)),

                //! Buttons
                Row(
                  children: [
                    //! Decline
                    Expanded(
                      child: CustomButton(
                        onPressed: widget.declineOnTap,
                        title: AppStrings.decline.tr(context),
                        color: AppColors.transparent,
                        textColor: AppColors.primary,
                        borderColor: AppColors.primary,
                        enabled: !_isCountingDown,
                      ),
                    ),
                    SizedBox(width: 22.rW(context)),
                    //! Accept
                    Expanded(
                      child: CustomButton(
                        onPressed: () async {
                          final success = await widget.acceptOnTap();
                          if (success) {
                            _startCountdown();
                          }
                        },
                        title: _isCountingDown
                            ? '${AppStrings.waitingRiderResponse.tr(context)} ($_countdown)'
                            : AppStrings.accept.tr(context),
                        enabled: !_isCountingDown,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13.rH(context)),
              ],
            ),
          ),

          SizedBox(height: 1.rH(context)),
        ],
      ),
    );
  }
}
