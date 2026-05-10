import 'pagination_model.dart';

class PaginationListModel {
  dynamic data;
  final PaginationModel? pagination;

  PaginationListModel({
    required this.data,
    required this.pagination,
  });

  factory PaginationListModel.fromJson(Map<String, dynamic> json) {
    return PaginationListModel(
      data: json["data"],
      pagination:
          json["meta"] != null ? PaginationModel.fromJson(json["meta"]) : null,
    );
  }
}
