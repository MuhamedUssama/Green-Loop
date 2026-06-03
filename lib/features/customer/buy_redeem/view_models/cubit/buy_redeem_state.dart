part of 'buy_redeem_cubit.dart';

@immutable
sealed class BuyRedeemState {}

final class BuyRedeemInitial extends BuyRedeemState {}

final class BuyRedeemLoading extends BuyRedeemState {}

final class BuyRedeemSuccess extends BuyRedeemState {}

final class BuyRedeemFailure extends BuyRedeemState {
  final String errorMessage;

  BuyRedeemFailure({required this.errorMessage});
}

final class NotEnoughPoints extends BuyRedeemState {
  final String errorMessage;

  NotEnoughPoints({required this.errorMessage});
}

final class EnoughPoints extends BuyRedeemState {
  final String qrCode;
  final String redeemName;

  EnoughPoints({required this.qrCode, required this.redeemName});
}

final class CheckPoints extends BuyRedeemState {}
