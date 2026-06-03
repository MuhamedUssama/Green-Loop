import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_loop/features/company/redeem/views/widgets/redeem_items_title.dart';
import 'package:green_loop/features/customer/buy_redeem/view_models/cubit/buy_redeem_cubit.dart';
import 'package:green_loop/features/customer/buy_redeem/views/widgets/buy_redeems_list_view.dart';
import 'package:green_loop/features/customer/categories/views/widgets/triple_bottom_wave_painter.dart';

class BuyRedeemScreenBody extends StatelessWidget {
  const BuyRedeemScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuyRedeemCubit(),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            child: CustomPaint(
              painter: TripleBottomWavePainter(),
            ),
          ),
          RedeemItemsTitle(),
          const SizedBox(height: 16),
          RedeemsListView(),
        ],
      ),
    );
  }
}
