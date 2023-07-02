import 'package:aura/network/api/api_core.dart';

class ParametersRequest implements Serializable {
  int? limit;
  int? page;
  int? offset;
  String? sort;
  List<String>? sourceName;
  List<int>? sourceId;
  List<String>? sourceSlug;
  String? orderBy;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (limit != null) data['limit'] = limit;
    if (page != null) data['page'] = page;
    if (offset != null) data['offset'] = offset;
    if (sort != null) data['sort'] = sort;
    if (sourceName != null && sourceName!.isNotEmpty) {
      data['sourceName'] = sourceName;
    }
    if (sourceId != null && sourceId!.isNotEmpty) data['sourceId'] = sourceId;
    if (sourceSlug != null && sourceSlug!.isNotEmpty) {
      data['sourceSlug'] = sourceSlug;
    }
    if (orderBy != null) data['order_by'] = orderBy;

    return data;
  }
}
