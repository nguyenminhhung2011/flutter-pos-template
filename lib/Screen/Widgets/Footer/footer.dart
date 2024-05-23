import 'package:flutter/cupertino.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/constant.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
      ),
      child: Row(
        children: [
          const Text(
            'COPYRIGHT © 2023 Acnoo, All rights Reserved',
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              text: 'Made by',
              children: [
                TextSpan(
                  text: ' Acnoo',
                  style: kTextStyle.copyWith(color: kMainColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
