import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sdk_eums/common/api.dart';

import 'eums_offer_wall_service.dart';

class EumsOfferWallServiceApi extends EumsOfferWallService {
  Dio api = BaseApi().buildDio();


  @override
  Future authConnect(
      {String? memId,
      String? memGen,
      String? memRegion,
      String? memBirth}) async {
    dynamic data = <String, dynamic>{
      "memId": memId,
      "memGen": memGen,
      "memRegion": memRegion,
      "memBirth": memBirth
    };
    Response result = await api.post('auth/connect', data: data);
    return result.data;
  }

  @override
  Future userInfo() async {
    Response result = await api.get('auth/profile');
    return result.data;
  }

  @override
  Future createTokenNotifi({token}) async {
    dynamic data = <String, dynamic>{"deviceToken": token};
    await api.post('device-token', data: data);
    return;
  }

  @override
  Future createInquire({type, content}) async {
    dynamic data = <String, dynamic>{"type_fl": type, "contents": content};
    await api.post('inquire', data: data);
    return;
  }

  @override
  Future deleteKeep({advertiseIdx}) async {
    await api.delete(
      'advertises/delete-keep/$advertiseIdx',
    );
  }

  @override
  Future deleteScrap({advertiseIdx}) async {
    await api.delete(
      'advertises/delete-crap/$advertiseIdx',
    );
  }

  @override
  Future getDetailOffWall({xId}) async {
    Response result = await api.get(
      'offerwall/$xId',
    );
    return result.data;
  }

  @override
  Future getListInquire({limit, offset}) async {
    var params = {};
    if (limit != null) {
      params['limit'] = limit;
    }
    if (offset != null) {
      params['offset'] = offset;
    }
    Map<String, dynamic> dataParams = jsonDecode(jsonEncode(params));
    Response result = await api.get('inquire', queryParameters: dataParams);
    return result.data['data'];
  }

  @override
  Future getListKeep({limit, offset}) async {
    var params = {};
    if (limit != null) {
      params['limit'] = limit;
    }
    if (offset != null) {
      params['offset'] = offset;
    }
    Response result = await api.get('advertises/get-keep-advertise');
    return result.data['data'];
  }

  @override
  Future getListOfferWall({limit, offset, category, filter}) async {
    var params = {};
    if (limit != null) {
      params['limit'] = limit;
    }
    if (offset != null) {
      params['offset'] = offset;
    }
    if (category != null) {
      params['category'] = category;
    }
    if (filter != null) {
      params['sort'] = filter;
    }
    Map<String, dynamic> dataParams = jsonDecode(jsonEncode(params));

    Response result = await api.get('offerwall', queryParameters: dataParams);
    return result.data['data'];
  }

  @override
  Future getListScrap({limit, offset, sort}) async {
    var params = {};
    if (limit != null) {
      params['limit'] = limit;
    }
    if (offset != null) {
      params['offset'] = offset;
    }
    if (sort != null) {
      params['sort'] = sort;
    }

    Map<String, dynamic> dataParams = jsonDecode(jsonEncode(params));
    Response result = await api.get('advertises/get-scrap-advertise',
        queryParameters: dataParams);
    return result.data['data'];
  }

  @override
  Future getPointEum() async {
    var params = {};

    params['limit'] = 1000000000;

    params['offset'] = 0;

    Map<String, dynamic> dataParams = jsonDecode(jsonEncode(params));

    Response result = await api.get('point/e-um', queryParameters: dataParams);
    return result.data['data'];
  }

  @override
  Future getPointOffWall() async {
    Response result = await api.get('offerwall-log');
    return result.data;
  }

  @override
  Future getQuestion({limit, offset, search}) async {
    var params = {};
    if (limit != null) {
      params['limit'] = limit;
    }
    if (offset != null) {
      params['offset'] = offset;
    }
    if (search != null) {
      params['search'] = search;
    }
    Map<String, dynamic> dataParams = jsonDecode(jsonEncode(params));
    Response result = await api.get('faq', queryParameters: dataParams);
    return result.data['data'];
  }

  @override
  Future getUsingTerm() async {
    Response result = await api.get('term');
    return result.data['data'];
  }

  @override
  Future missionOfferWallInternal({offerWallIdx, urlImage}) async {
    // nội bộ
    dynamic data = <String, dynamic>{
      "offerwall_idx": offerWallIdx,
      'img': urlImage
    };
    await api.post('point/offerwall/mission-complete', data: data);
    return;
  }

  @override
  Future missionOfferWallOutside({advertiseIdx, pointType}) async {
    // bên ngoài
    print("advertiseIdx$advertiseIdx");
    dynamic data = <String, dynamic>{
      "advertise_idx": advertiseIdx,
      "pointType": pointType
    };
    await api.post('point/advertises/mission-complete', data: data);
    return;
  }

  @override
  Future saveKeep({advertiseIdx}) async {
    dynamic data = <String, dynamic>{"advertise_idx": advertiseIdx};
    await api.post('advertises/save-keep-advertise', data: data);
    return;
  }

  @override
  Future saveScrap({advertiseIdx}) async {
    dynamic data = <String, dynamic>{"advertise_idx": advertiseIdx};
    await api.post('advertises/save-scrap-advertise', data: data);
    return;
  }

  @override
  Future uploadImageOfferWallInternal({List<File>? files}) async {
    dynamic multiFiles = files
        ?.map((item) async => await MultipartFile.fromFile(
              item.path,
              // contentType:  MediaType('image', 'jpeg')
            ))
        .toList();

    FormData formData =
        FormData.fromMap({"image": await Future.wait(multiFiles)});
    Response result = await api.post('upload', data: formData);
    return result.data;
  }
}
