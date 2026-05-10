class PaymentMethodModel {
  final int? id;
  final String? name, logo;
  final bool? status;
  final List<PaymentMethodModel> subPayments;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.status,
    required this.subPayments,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json["id"],
      name: json["name"],
      logo: json["logo"],
      status: json["status"],
      subPayments: (json["sub_payments"] as List?)
              ?.map((e) => PaymentMethodModel.fromJson(e))
              .toList() ??
          <PaymentMethodModel>[],
    );
  }
}
