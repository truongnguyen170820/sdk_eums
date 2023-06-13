part of 'keep_adverbox_bloc.dart';

enum KeepAdverboxStatus { initial, loading, success, failure }

enum DeleteKeepStatus { initial, loading, success, failure }

enum AdverKeepStatus { initial, loading, success, failure }

@immutable
class KeepAdverboxState extends Equatable {
  const KeepAdverboxState(
      {this.deleteKeepStatus = DeleteKeepStatus.initial,
      this.status = KeepAdverboxStatus.initial,
      this.dataKeepAdverbox,
      this.dataDetailKeepAdverbox,
      this.adverKeepStatus = AdverKeepStatus.initial});

  final KeepAdverboxStatus status;

  final DeleteKeepStatus deleteKeepStatus;
  final dynamic dataKeepAdverbox;
  final dynamic dataDetailKeepAdverbox;
  final AdverKeepStatus adverKeepStatus;

  KeepAdverboxState copyWith(
      {DeleteKeepStatus? deleteKeepStatus,
      KeepAdverboxStatus? status,
      dynamic dataKeepAdverbox,
      dynamic dataDetailKeepAdverbox,
      AdverKeepStatus? adverKeepStatus}) {
    return KeepAdverboxState(
        dataDetailKeepAdverbox:
            dataDetailKeepAdverbox ?? this.dataDetailKeepAdverbox,
        deleteKeepStatus: deleteKeepStatus ?? this.deleteKeepStatus,
        status: status ?? this.status,
        dataKeepAdverbox: dataKeepAdverbox ?? this.dataKeepAdverbox,
        adverKeepStatus: adverKeepStatus ?? this.adverKeepStatus);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        status,
        dataKeepAdverbox,
        dataDetailKeepAdverbox,
        deleteKeepStatus,
        adverKeepStatus
      ];
}
