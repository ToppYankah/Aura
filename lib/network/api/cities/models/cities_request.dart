class CitiesRequest {
  int? limit;
  int? page;
  int? offset;
  String? sort;
  List<String>? countryId;
  List<String>? cities;
  String? country;
  String? orderBy;
  String? entity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (limit != null) map['limit'] = limit;
    if (page != null) map['page'] = page;
    if (offset != null) map['offset'] = offset;
    if (sort != null) map['sort'] = sort;
    if (countryId != null) map['country_id'] = countryId;
    if (country != null) map['country'] = country;
    if (cities != null) map['city'] = cities;
    if (orderBy != null) map['order_by'] = orderBy;
    if (entity != null) map['entity'] = entity;
    return map;
  }

  CitiesRequest({
    this.limit,
    this.page,
    this.offset,
    this.sort,
    this.country,
    this.cities,
    this.orderBy,
    this.entity,
  });
}
