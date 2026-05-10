import '../../../../core/imports/imports.dart';
import 'earnings_calender.dart';
import 'earnings_filter_row.dart';
import 'earnings_status.dart';
import 'earnings_summary_card.dart';
import 'total_earnings_card.dart';

class EarningsBody extends StatelessWidget {
  const EarningsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(title: AppStrings.earnings.tr(context)),

          SizedBox(height: 26.rH(context)),

          //! Filter Row
          const EarningsFilterRow(),

          SizedBox(height: 16.rH(context)),

          //! Calender
          const EarningsCalender(),

          SizedBox(height: 16.rH(context)),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                //! Total Earnings Card
                const TotalEarningsCard(),

                //! Status
                const EarningsStatus(),

                SizedBox(height: 26.rH(context)),

                //! Summary
                const EarningsSummaryCard(),

                SizedBox(height: 16.rH(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
