import 'dart:typed_data';

class SpendingModel {
  int? spendingId;
  String spendingDesc;
  num spendingAmount;
  String spendingMode;
  String spendingType;
  String spendingDate;
  String spendingTime;
  int spendingCategory;

  SpendingModel({
    this.spendingId,
    required this.spendingDesc,
    required this.spendingAmount,
    required this.spendingMode,
    required this.spendingType,
    required this.spendingDate,
    required this.spendingTime,
    required this.spendingCategory,
  });

  factory SpendingModel.fromMap({required Map<String, dynamic> data}) {
    return SpendingModel(
      spendingId: data['spending_id'],
      spendingDesc: data['spending_desc'],
      spendingAmount: data['spending_amount'],
      spendingMode: data['spending_mode'],
      spendingType: data['spending_type'],
      spendingDate: data['spending_date'],
      spendingTime: data['spending_time'],
      spendingCategory: data['spending_category'],
    );
  }
}
