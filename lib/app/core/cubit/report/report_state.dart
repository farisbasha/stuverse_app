part of 'report_cubit.dart';

@immutable
abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportError extends ReportState {
  final String message;

  ReportError(this.message);
}

class ReportSuccess extends ReportState {}
