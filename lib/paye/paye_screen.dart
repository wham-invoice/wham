import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wham/paye/paye_cubit.dart';

// Define a custom Form widget.
class PayEFormScreen extends StatefulWidget {
  const PayEFormScreen({Key? key}) : super(key: key);

  @override
  _PayEFormScreenState createState() => _PayEFormScreenState();
}

class _PayEFormScreenState extends State<PayEFormScreen> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(),
        iosContentPadding: false,
        iosContentBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: PlatformTextField(
                onChanged: (text) =>
                    context.read<PayeCubit>().setIncome(double.parse(text)),
                keyboardType: TextInputType.number,
                // TODO: use inputFormatter to prevent letters and convert to currency on the fly.
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: BlocBuilder<PayeCubit, PayeResult>(
                builder: (context, result) {
                  return Column(children: [
                    PlatformText(result.acc.toString()),
                    PlatformText(result.studentLoan.toString()),
                    PlatformText(result.gst.toString())
                  ]);
                },
              ),
            ),
            PlatformTextButton(
              // Within the `FirstScreen` widget
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/settings');
              },
              child: const Text('Launch settings'),
            ),
          ],
        ));
  }
}
