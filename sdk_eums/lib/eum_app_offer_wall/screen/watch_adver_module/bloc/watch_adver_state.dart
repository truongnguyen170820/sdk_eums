part of 'watch_adver_bloc.dart';

enum WatchAdverStatus { initial, loading, success, failure }

enum EarnMoneyStatus { initial, loading, success, failure }

enum SaveKeepAdverboxStatus { initial, loading, success, failure }

@immutable
class WatchAdverState extends Equatable {
  WatchAdverState(
      {this.dataWatch,
      this.saveKeepAdverboxStatus = SaveKeepAdverboxStatus.initial,
      this.watchAdverStatus = WatchAdverStatus.initial,
      this.earnMoneyStatus = EarnMoneyStatus.initial});

  final WatchAdverStatus watchAdverStatus;
  dynamic dataWatch;
  final EarnMoneyStatus earnMoneyStatus;
  final SaveKeepAdverboxStatus saveKeepAdverboxStatus;

  WatchAdverState copyWith(
      {WatchAdverStatus? watchAdverStatus,
      SaveKeepAdverboxStatus? saveKeepAdverboxStatus,
      dynamic dataWatch,
      EarnMoneyStatus? earnMoneyStatus}) {
    return WatchAdverState(
        dataWatch: dataWatch ?? this.dataWatch,
        earnMoneyStatus: earnMoneyStatus ?? this.earnMoneyStatus,
        saveKeepAdverboxStatus:
            saveKeepAdverboxStatus ?? this.saveKeepAdverboxStatus,
        watchAdverStatus: watchAdverStatus ?? this.watchAdverStatus);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [dataWatch, watchAdverStatus, saveKeepAdverboxStatus, earnMoneyStatus];
}
