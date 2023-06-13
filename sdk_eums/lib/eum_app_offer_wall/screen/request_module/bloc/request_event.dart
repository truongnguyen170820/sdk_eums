part of 'request_bloc.dart';

abstract class RequestEvent extends Equatable {}

class RequestInquire extends RequestEvent {
  RequestInquire({this.contents, this.type});

  final String? type;
  final String? contents;
  @override
  List<Object?> get props => [contents, type];
}

class ListInquire extends RequestEvent {
  ListInquire({this.limit , this.offset});

    final dynamic limit;
  final dynamic offset;

  @override
  List<Object?> get props => [limit , offset];
}


class LoadMoreListInquire extends RequestEvent {
  LoadMoreListInquire({this.limit , this.offset});

    final dynamic limit;
  final dynamic offset;

  @override
  List<Object?> get props => [limit , offset];
}