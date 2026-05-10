import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../imports/imports.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.onRatingUpdate});

  final Function(double) onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: 1,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      unratedColor: AppColors.grey,
      onRatingUpdate: onRatingUpdate,
    );
  }
}
