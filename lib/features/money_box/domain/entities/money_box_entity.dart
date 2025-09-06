// ignore_for_file: public_member_api_docs, sort_constructors_first

class MoneyBoxEntity {
  final int id;
  final String status;
  final List<int> lastReconciled;
  final double totalBalanceInSYP;
  final double totalBalanceInUSD;
  final int currentUSDToSYPRate;

  MoneyBoxEntity({
    required this.id,
    required this.status,
    required this.lastReconciled,
    required this.totalBalanceInSYP,
    required this.totalBalanceInUSD,
    required this.currentUSDToSYPRate,
  });
}
