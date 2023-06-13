part of 'keep_adverbox_bloc.dart';

abstract class KeepAdverboxEvent extends Equatable {}

class KeepAdverbox extends KeepAdverboxEvent {
  KeepAdverbox({this.limit, this.offset});

  final dynamic limit;
  final dynamic offset;
  @override
  List<Object?> get props => [limit, offset];
}

class DeleteKeep extends KeepAdverboxEvent {
  DeleteKeep({this.id});

  final dynamic id;

  @override
  List<Object?> get props => [id];
}

class EarnPoin extends KeepAdverboxEvent {
  EarnPoin({this.advertise_idx, this.pointType});

  final dynamic advertise_idx;
  final dynamic pointType;
  @override
  // TODO: implement props
  List<Object?> get props => [advertise_idx, pointType];
}