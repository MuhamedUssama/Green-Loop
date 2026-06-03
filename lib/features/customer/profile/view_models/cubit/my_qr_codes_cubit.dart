import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:green_loop/core/di/dependancy_injection.dart';
import 'package:green_loop/features/customer/profile/models/qr_code_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'my_qr_codes_state.dart';

class MyQrCodesCubit extends Cubit<MyQrCodesState> {
  MyQrCodesCubit() : super(MyQrCodesInitial()) {
    getMyQrCodes();
  }

  StreamSubscription? _subscription;
  List<QrCodeModel> qrList = [];
  final supabase = getIt<SupabaseClient>();

  void getMyQrCodes() {
    emit(MyQrCodesLoading());
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        emit(MyQrCodesFailure(errorMessage: "User not logged in"));
        return;
      }

      _subscription = supabase
          .from("qr_codes")
          .stream(primaryKey: ['id'])
          .eq("user_id", userId)
          .listen((data) {
            qrList = data.map((json) => QrCodeModel.fromJson(json)).toList();
            qrList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            emit(MyQrCodesSuccess());
          }, onError: (error) {
            emit(MyQrCodesFailure(errorMessage: error.toString()));
          });
    } catch (e) {
      emit(MyQrCodesFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
