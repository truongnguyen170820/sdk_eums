part of 'scrap_adverbox_bloc.dart';

enum ScrapAdverboxStatus { initial, loading, success, failure }

enum DeleteScrapAdverboxStatus { initial, loading, success, failure }


@immutable
class ScrapAdverboxState extends Equatable {
  const ScrapAdverboxState(
      {this.deleteScrapAdverboxStatus = DeleteScrapAdverboxStatus.initial,
      this.status = ScrapAdverboxStatus.initial,
      this.dataScrapAdverbox});

  final ScrapAdverboxStatus status;
  final dynamic dataScrapAdverbox;
  final DeleteScrapAdverboxStatus deleteScrapAdverboxStatus;

  ScrapAdverboxState copyWith(
      {DeleteScrapAdverboxStatus? deleteScrapAdverboxStatus,
      ScrapAdverboxStatus? status,
      dynamic dataScrapAdverbox}) {
    return ScrapAdverboxState(
        deleteScrapAdverboxStatus:
            deleteScrapAdverboxStatus ?? this.deleteScrapAdverboxStatus,
        status: status ?? this.status,
        dataScrapAdverbox: dataScrapAdverbox ?? this.dataScrapAdverbox);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [status, dataScrapAdverbox, deleteScrapAdverboxStatus];
}
