import '../../../../core/imports/imports.dart';
import '../widgets/transactions_body.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TransactionsBody(),
    );
  }
}
