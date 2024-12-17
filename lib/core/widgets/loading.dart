import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/theme/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      color: Colors.grey.withValues(alpha: .7),
      child: const Center(
        child: CircularProgressIndicator(
          backgroundColor: CustomColors.lightGreen,
        ),
      ),
    );
  }
}
