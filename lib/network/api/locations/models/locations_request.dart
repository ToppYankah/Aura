import 'package:aura/network/api/api_core.dart';

class LocationsRequest implements Serializable {
  int? limit;
  int? page;
  int? offset;
  String? sort;
  bool? hasGeo;
  int? parameterId;
  List<int>? parameter;
  String? unit;
  String? coordinates;
  int? radius;
  List<String>? countryId;
  String? country;
  List<String>? city;
  List<int>? location;
  String? orderBy;
  bool? isMobile;
  bool? isAnalysis;
  String? sourceName;
  String? entity;
  String? sensorType;
  String? modelName;
  String? manufacturerName;
  bool? dumpRaw;

  LocationsRequest({
    this.limit = 100,
    this.page = 1,
    this.offset,
    this.sort = "desc",
    this.hasGeo,
    this.parameterId,
    this.parameter,
    this.unit,
    this.coordinates,
    this.radius,
    this.countryId,
    this.country,
    this.city,
    this.location,
    this.orderBy = "lastUpdated",
    this.isMobile,
    this.isAnalysis,
    this.sourceName,
    this.entity = "community",
    this.sensorType,
    this.modelName,
    this.manufacturerName,
    this.dumpRaw = false,
  });

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (limit != null) map['limit'] = limit;
    if (page != null) map['page'] = page;
    if (offset != null) map['offset'] = offset;
    if (sort != null) map['sort'] = sort;
    if (hasGeo != null) map['has_geo'] = hasGeo;
    if (parameterId != null) map['parameter_id'] = parameterId;
    if (parameter != null) map['parameter'] = parameter;
    if (unit != null) map['unit'] = unit;
    if (coordinates != null) map['coordinates'] = coordinates;
    if (radius != null) map['radius'] = radius;
    if (countryId != null) map['country_id'] = countryId;
    if (country != null) map['country'] = country;
    if (city != null) map['city'] = city;
    if (location != null) map['location'] = location;
    if (orderBy != null) map['order_by'] = orderBy;
    if (isMobile != null) map['isMobile'] = isMobile;
    if (isAnalysis != null) map['isAnalysis'] = isAnalysis;
    if (sourceName != null) map['sourceName'] = sourceName;
    if (entity != null) map['entity'] = entity;
    if (sensorType != null) map['sensorType'] = sensorType;
    if (modelName != null) map['modelName'] = modelName;
    if (manufacturerName != null) map['manufacturerName'] = manufacturerName;
    if (dumpRaw != null) map['dumpRaw'] = dumpRaw;
    return map;
  }
}
