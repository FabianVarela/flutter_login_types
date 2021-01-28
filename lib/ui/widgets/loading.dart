import 'package:flutter/material.dart';
import 'package:login_bloc/utils/colors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.grey.withOpacity(.7),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: CustomColors.lightGreen,
        ),
      ),
    );
  }
}
