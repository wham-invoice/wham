import 'package:flutter_bloc/flutter_bloc.dart';

class PayeResult {
  final double income;
  final double gst;
  final double acc;
  final double studentLoan;
  final double tax;

  PayeResult(this.income, this.gst, this.acc, this.studentLoan, this.tax);
}

class PayeCubit extends Cubit<PayeResult> {
  PayeCubit() : super(PayeResult(0, 0, 0, 0, 0));

  @override
  void onChange(Change<PayeResult> change) {
    print("Cubit itself: $change");
    super.onChange(change);
  }

  void setIncome(double income) {
    double gst = income * 0.15;
    double acc = income * 0.013;
    double tax = income * 0.4;
    double studentLoan = income * 0.12;
    emit(PayeResult(income, gst, acc, studentLoan, tax));
  }
}
