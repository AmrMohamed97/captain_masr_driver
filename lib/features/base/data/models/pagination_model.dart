class PaginationModel {
  final int? currentPage, lastPage, total, perPage;

  PaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json["current_page"],
      lastPage: json["last_page"],
      total: json["total"],
      perPage: json["per_page"],
    );
  }
}
