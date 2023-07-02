import 'package:aura/network/api/api_core.dart';

class MeasurementsRequest implements Serializable {
  String? format;
  DateTime? dateFrom;
  DateTime? dateTo;
  int? limit;
  int? page;
  int? offset;
  String? sort;
  bool? hasGeo;
  int? parameterId;
  int? parameter;
  List<String>? unit;
  String? coordinates;
  int? radius;
  String? countryId;
  List<String>? country;
  String? city;
  int? locationId;
  int? location;
  String? orderBy;
  bool? isMobile;
  bool? isAnalysis;
  int? project;
  String? entity;
  String? sensorType;
  double? valueFrom;
  double? valueTo;
  String? includeFields;

  MeasurementsRequest({
    this.format,
    this.dateFrom,
    this.dateTo,
    this.limit,
    this.page,
    this.offset,
    this.sort,
    this.hasGeo,
    this.parameterId,
    this.parameter,
    this.unit,
    this.coordinates,
    this.radius,
    this.countryId,
    this.country,
    this.city,
    this.locationId,
    this.location,
    this.orderBy,
    this.isMobile,
    this.isAnalysis,
    this.project,
    this.entity,
    this.sensorType,
    this.valueFrom,
    this.valueTo,
    this.includeFields,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (format != null) data['format'] = format;
    if (dateFrom != null) data['date_from'] = dateFrom!.toIso8601String();
    if (dateTo != null) data['date_to'] = dateTo!.toIso8601String();
    if (limit != null) data['limit'] = limit;
    if (page != null) data['page'] = page;
    if (offset != null) data['offset'] = offset;
    if (sort != null) data['sort'] = sort;
    if (hasGeo != null) data['has_geo'] = hasGeo;
    if (parameterId != null) data['parameter_id'] = parameterId;
    if (parameter != null) data['parameter'] = parameter;
    if (unit != null) data['unit'] = unit;
    if (coordinates != null) data['coordinates'] = coordinates;
    if (radius != null) data['radius'] = radius;
    if (countryId != null) data['country_id'] = countryId;
    if (country != null) data['country'] = country;
    if (city != null) data['city'] = city;
    if (locationId != null) data['location_id'] = locationId;
    if (location != null) data['location'] = location;
    if (orderBy != null) data['order_by'] = orderBy;
    if (isMobile != null) data['isMobile'] = isMobile;
    if (isAnalysis != null) data['isAnalysis'] = isAnalysis;
    if (project != null) data['project'] = project;
    if (entity != null) data['entity'] = entity;
    if (sensorType != null) data['sensorType'] = sensorType;
    if (valueFrom != null) data['value_from'] = valueFrom;
    if (valueTo != null) data['value_to'] = valueTo;
    if (includeFields != null) data['include_fields'] = includeFields;

    return data;
  }
}
