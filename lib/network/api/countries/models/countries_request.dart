class CountriesRequest {
  int? limit;
  int? page;
  int? offset;
  String? sort;
  String? country;
  String? orderBy;

  CountriesRequest({
    this.limit,
    this.page,
    this.offset,
    this.sort,
    this.country,
    this.orderBy,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (limit != null) map['limit'] = limit;
    if (page != null) map['page'] = page;
    if (offset != null) map['offset'] = offset;
    if (sort != null) map['sort'] = sort;
    if (country != null) map['country'] = country;
    if (orderBy != null) map['order_by'] = orderBy;
    return map;
  }
}
