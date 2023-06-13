import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdk_eums/api_eums_offer_wall/eums_offer_wall_service_api.dart';
import 'package:sdk_eums/sdk_eums_library.dart';

part 'watch_adver_event.dart';
part 'watch_adver_state.dart';

class WatchAdverBloc extends Bloc<WatchAdverEvent, WatchAdverState> {
  WatchAdverBloc()
      : _eumsOfferWallService = EumsOfferWallServiceApi(),
        super(WatchAdverState()) {
    on<WatchAdverEvent>(mapEventToState);
  }

  final EumsOfferWallService _eumsOfferWallService;

  FutureOr<void> mapEventToState(WatchAdverEvent event, emit) async {
    if (event is WatchAdver) {
      await _mapEarnCashListToState(event, emit);
    } else if (event is EarnPoin) {
      await _mapEarnCashToState(event, emit);
    } else if (event is SaveAdver) {
      await _mapSaveAdverToState(event, emit);
    }
  }

  _mapEarnCashListToState(WatchAdver event, emit) async {
    emit(state.copyWith(watchAdverStatus: WatchAdverStatus.loading));
    try {
      // dynamic data = await _eumsOfferWallService.getAddverWatch(id: event.id);

      // emit(state.copyWith(
      //     watchAdverStatus: WatchAdverStatus.success,
      //     dataWatch: data['result_code'] == 'S0000' ? data['response'] : null));
    } catch (e) {
      emit(state.copyWith(watchAdverStatus: WatchAdverStatus.failure));
    }
  }

  _mapEarnCashToState(EarnPoin event, emit) async {
    emit(state.copyWith(earnMoneyStatus: EarnMoneyStatus.loading));
    try {
      await _eumsOfferWallService.missionOfferWallOutside(
          advertiseIdx: event.advertise_idx, pointType: event.pointType);

      emit(state.copyWith(
        earnMoneyStatus: EarnMoneyStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(earnMoneyStatus: EarnMoneyStatus.failure));
    }
  }

  _mapSaveAdverToState(SaveAdver event, emit) async {
    emit(
        state.copyWith(saveKeepAdverboxStatus: SaveKeepAdverboxStatus.loading));
    try {
    await _eumsOfferWallService.saveScrap(advertiseIdx: event.advertise_idx);

      emit(state.copyWith(
        saveKeepAdverboxStatus: SaveKeepAdverboxStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          saveKeepAdverboxStatus: SaveKeepAdverboxStatus.failure));
    }
  }
}
