import '../../../base/data/models/pagination_model.dart';
import 'transaction_model.dart';

class TransactionsResponseModel {
  final int? balance;
  final List<TransactionModel> transactions;
  final PaginationModel? pagination;

  TransactionsResponseModel({
    required this.balance,
    required this.transactions,
    required this.pagination,
  });

  factory TransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionsResponseModel(
      balance: json["balance"],
      transactions: (json["data"] as List?)
              ?.map((e) => TransactionModel.fromJson(e))
              .toList() ??
          <TransactionModel>[],
      pagination:
          json["meta"] != null ? PaginationModel.fromJson(json["meta"]) : null,
    );
  }
}
