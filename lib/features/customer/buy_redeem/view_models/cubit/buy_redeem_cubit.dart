import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:green_loop/core/di/dependancy_injection.dart';
import 'package:green_loop/core/network/supabase/database/get_stream_data.dart';
import 'package:green_loop/features/company/redeem/models/redeem_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'buy_redeem_state.dart';

class BuyRedeemCubit extends Cubit<BuyRedeemState> {
  BuyRedeemCubit() : super(BuyRedeemInitial()) {
    getCompanyRedeems();
  }

  StreamSubscription? streamSubscription;
  List<RedeemModel> redeemList = [];
  final supabase = getIt.get<SupabaseClient>();

  int retryCount = 0;
  final int maxRetries = 3;

  getCompanyRedeems() {
    streamSubscription?.cancel();
    emit(BuyRedeemLoading());

    try {
      streamSubscription = streamData(
        tableName: "redeems",
      ).listen(
        (event) {
          if (event.isNotEmpty) {
            redeemList = event.map((e) => RedeemModel.fromJson(e)).toList();
            emit(BuyRedeemSuccess());
            retryCount = 0;
          } else {
            redeemList = [];
            emit(BuyRedeemSuccess());
            retryCount = 0;
          }
        },
        onError: (error) async {
          if (retryCount < maxRetries) {
            retryCount++;
            emit(BuyRedeemLoading());
            await Future.delayed(Duration(seconds: 2));
            getCompanyRedeems();
          } else {
            emit(BuyRedeemFailure(
                errorMessage: "Failed to load data after $maxRetries retries"));
          }
        },
      );
    } catch (e) {
      if (retryCount < maxRetries) {
        retryCount++;
        emit(BuyRedeemLoading());
        Future.delayed(Duration(seconds: 2), () => getCompanyRedeems());
      } else {
        emit(BuyRedeemFailure(
            errorMessage: "Failed to load data after $maxRetries retries"));
      }
    }
  }

  //!
  buyRedeem({
    required RedeemModel redeemModel,
  }) async {
    try {
      emit(CheckPoints());
      final response = await supabase
          .from("customerss")
          .select("voucher")
          .eq("id", getIt<SupabaseClient>().auth.currentUser!.id)
          .single();
      double updatedVoucher = response["voucher"].toDouble() - redeemModel.price;
      if (updatedVoucher >= 0) {
        // Generate a unique code
        final qrCodeString = const Uuid().v4();

        // Save QR code details to Supabase
        await supabase.from("qr_codes").insert({
          "user_id": supabase.auth.currentUser!.id,
          "redeem_id": redeemModel.id,
          "code": qrCodeString,
          "redeem_name": redeemModel.name,
          "redeem_description": redeemModel.description,
          "is_scanned": false,
        });

        // Deduct points
        await supabase
            .from("customerss")
            .update({"voucher": updatedVoucher}).eq(
                "id", getIt<SupabaseClient>().auth.currentUser!.id);

        emit(EnoughPoints(qrCode: qrCodeString, redeemName: redeemModel.name));
      } else {
        emit(NotEnoughPoints(
            errorMessage:
                "Not enough points to buy this redeem\n Please try another redeem\nredeem points: ${redeemModel.price} - your points: ${response["voucher"]}"));
      }
    } catch (e) {
      emit(BuyRedeemFailure(errorMessage: e.toString()));
    }
  }
}
