part of 'my_qr_codes_cubit.dart';

@immutable
sealed class MyQrCodesState {}

final class MyQrCodesInitial extends MyQrCodesState {}

final class MyQrCodesLoading extends MyQrCodesState {}

final class MyQrCodesSuccess extends MyQrCodesState {}

final class MyQrCodesFailure extends MyQrCodesState {
  final String errorMessage;

  MyQrCodesFailure({required this.errorMessage});
}
