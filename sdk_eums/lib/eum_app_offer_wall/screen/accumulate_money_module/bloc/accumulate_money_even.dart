part of 'accumulate_money_bloc.dart';

abstract class AccumulateMoneyEvent extends Equatable {}

class AccumulateMoneyList extends AccumulateMoneyEvent {
  AccumulateMoneyList();

  @override
  List<Object?> get props => [];
}

class ListOfferWall extends AccumulateMoneyEvent {
  ListOfferWall({this.category, this.limit, this.filter});

  final dynamic category;
  final dynamic limit;
  final dynamic filter;
  @override
  List<Object?> get props => [category, limit, filter];
}

class LoadmoreListOfferWall extends AccumulateMoneyEvent {
  LoadmoreListOfferWall({this.category, this.limit, this.offset, this.filter});

  final dynamic category;
  final dynamic limit;
  final dynamic offset;
  final dynamic filter;
  @override
  List<Object?> get props => [category, limit, offset, filter];
}

class OnOrOffAdver extends AccumulateMoneyEvent {
  OnOrOffAdver({this.checkOnOff});
  final bool? checkOnOff;
  @override
  List<Object?> get props => [checkOnOff];
}

class GetOnOrOffAdver extends AccumulateMoneyEvent {
  GetOnOrOffAdver();
  @override
  List<Object?> get props => [];
}

class SaveAdverKeep extends AccumulateMoneyEvent {
  SaveAdverKeep();
  @override
  List<Object?> get props => [];
}

class NextPageOverlay extends AccumulateMoneyEvent {
  NextPageOverlay();
  @override
  List<Object?> get props => [];
}

// class GetToken extends AccumulateMoneyEvent {
//   GetToken({this.token});
//   final dynamic token;
//   @override
//   List<Object?> get props => [token];
// }

class SaveKeepAdver extends AccumulateMoneyEvent {
  SaveKeepAdver({this.advertise_idx});
  final dynamic advertise_idx;
  @override
  List<Object?> get props => [advertise_idx];
}