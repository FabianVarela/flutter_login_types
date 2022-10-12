import 'package:flutter/material.dart';
import 'package:login_bloc/ui/common/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.grey.withOpacity(.7),
      child: const Center(
        child: CircularProgressIndicator(
          backgroundColor: CustomColors.lightGreen,
        ),
      ),
    );
  }
}
