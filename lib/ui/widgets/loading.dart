import 'package:flutter/material.dart';
import 'package:login_bloc/utils/colors.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

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
