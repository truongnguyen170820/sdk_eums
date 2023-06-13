import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdk_eums/api_eums_offer_wall/eums_offer_wall_service_api.dart';
import 'package:sdk_eums/sdk_eums_library.dart';

part 'scrap_adverbox_event.dart';
part 'scrap_adverbox_state.dart';

class ScrapAdverboxBloc extends Bloc<ScrapAdverboxEvent, ScrapAdverboxState> {
  ScrapAdverboxBloc()
      : _eumsOfferWallService = EumsOfferWallServiceApi(),
        super(ScrapAdverboxState()) {
    on<ScrapAdverboxEvent>(mapEventToState);
  }

  final EumsOfferWallService _eumsOfferWallService;

  FutureOr<void> mapEventToState(ScrapAdverboxEvent event, emit) async {
    if (event is ScrapAdverbox) {
      await _mapKeepAdverboxToState(event, emit);
    } else if (event is DeleteScrapdverbox) {
      await _mapSaveScrapdverboxToState(event, emit);
    }
  }

  _mapKeepAdverboxToState(ScrapAdverbox event, emit) async {
    emit(state.copyWith(status: ScrapAdverboxStatus.loading));
    try {
      dynamic data = await _eumsOfferWallService.getListScrap(
          limit: event.limit, offset: event.offset, sort: event.sort);

      emit(state.copyWith(
          status: ScrapAdverboxStatus.success, dataScrapAdverbox: data));
    } catch (e) {
      emit(state.copyWith(status: ScrapAdverboxStatus.failure));
    }
  }

  _mapSaveScrapdverboxToState(DeleteScrapdverbox event, emit) async {
    emit(state.copyWith(
        deleteScrapAdverboxStatus: DeleteScrapAdverboxStatus.loading));
    try {
      await _eumsOfferWallService.deleteScrap(advertiseIdx: event.id);
      emit(state.copyWith(
        deleteScrapAdverboxStatus: DeleteScrapAdverboxStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          deleteScrapAdverboxStatus: DeleteScrapAdverboxStatus.failure));
    }
  }
}
