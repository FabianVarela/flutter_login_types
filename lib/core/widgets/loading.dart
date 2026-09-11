import 'package:flutter_login_types/core/theme/colors.dart';
import 'package:material_ui/material_ui.dart';

class Loading extends StatelessWidget {
  const new({super.key});

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
