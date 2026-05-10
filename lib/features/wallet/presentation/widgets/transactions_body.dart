import '../../../../core/imports/imports.dart';
import 'transactions_list_view.dart';

class TransactionsBody extends StatelessWidget {
  const TransactionsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.transactions.tr(context),
          ),

          SizedBox(height: 16.rH(context)),

          //! Transactions
          const TransactionsListView(),
        ],
      ),
    );
  }
}
