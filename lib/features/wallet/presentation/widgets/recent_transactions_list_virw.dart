import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_refresh_indicator.dart';
import '../views/transactions_view.dart';
import 'transaction_card.dart';
import 'transaction_loading_card.dart';

class RecentTransactionsListView extends StatelessWidget {
  const RecentTransactionsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final cubit = context.read<WalletCubit>();
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! Title & See More
              Row(
                children: [
                  Text(
                    AppStrings.recentTransactions.tr(context),
                    style: Styles.medium16Primary(context).copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Spacer(),
                  //! See More
                  if (cubit.transactions.isNotEmpty)
                    UnderLineText(
                      text: AppStrings.seeMore.tr(context),
                      onTap: () {
                        navBarNavigate(
                          context: context,
                          widget: BlocProvider.value(
                            value: cubit..initPagination(),
                            child: const TransactionsView(),
                          ),
                        );
                      },
                    ),
                ],
              ),
              SizedBox(height: 10.rH(context)),
              //! Transactions List View
              Expanded(
                child: CustomRefreshIndicator(
                  onRefresh: () {
                    cubit.transactions.clear();
                    cubit.pagination = null;
                    cubit.page = 0;
                    return cubit.getTransations();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state is WalletLoadingState
                        ? 10
                        : cubit.transactions.length > 10
                            ? 10
                            : cubit.transactions.length,
                    itemBuilder: (context, index) {
                      if (state is WalletLoadingState) {
                        return const TransactionLoadingCard();
                      }
                      return TransactionCard(
                        model: cubit.transactions[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
