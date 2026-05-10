import '../../../../core/imports/imports.dart';
import 'recent_transactions_list_virw.dart';
import 'wallet_card.dart';

class WalletBody extends StatelessWidget {
  const WalletBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.wallet.tr(context),
            popOnTap: () {
              context.read<GlobalCubit>().isDriver
                  ? Navigator.pop(context)
                  : context.read<GlobalCubit>().navBarController.jumpToTab(0);
            },
          ),

          SizedBox(height: 26.rH(context)),

          //! Wallet Card
          const WalletCard(),

          SizedBox(height: 26.rH(context)),

          //! Recent Transactions
          const RecentTransactionsListView(),
        ],
      ),
    );
  }
}
