import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_refresh_indicator.dart';
import 'transaction_card.dart';
import 'transaction_loading_card.dart';

class TransactionsListView extends StatelessWidget {
  const TransactionsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final cubit = context.read<WalletCubit>();
        return Expanded(
          child: CustomRefreshIndicator(
            onRefresh: () {
              cubit.transactions.clear();
              cubit.pagination = null;
              cubit.page = 0;
              return cubit.getTransations();
            },
            child: ListView.builder(
              controller: cubit.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 26.rH(context)),
              itemCount: cubit.transactions.length +
                  (state is WalletLoadingState
                      ? cubit.transactions.isEmpty
                          ? 10
                          : 2
                      : 0),
              itemBuilder: (context, index) {
                //! Shimmer Card
                if ((state is WalletLoadingState &&
                        index + 1 > cubit.transactions.length) ||
                    (state is WalletLoadingState &&
                        cubit.transactions.isEmpty)) {
                  return const TransactionLoadingCard();
                }
                //! Transaction Card
                return TransactionCard(
                  model: cubit.transactions[index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
