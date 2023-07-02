import 'dart:collection';

import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/locations/models/location_parameter.dart';
import 'package:aura/network/api/parameters/models/parameter_data.dart';
import 'package:aura/network/api/parameters/models/parameters_request.dart';
import 'package:aura/providers/base_provider.dart';

class ParametersProvider extends BaseProvider {
  ParametersProvider({required preferences, required apiCollection})
      : super(apiCollection: apiCollection, preferences: preferences);

  // Provider properties
  LocationParameter? _selectedParameter;
  final List<ParameterData> _parameters = [];

  // Getters
  LocationParameter? get selectedParameter => _selectedParameter;
  UnmodifiableListView<ParameterData> get parameters =>
      UnmodifiableListView(_parameters);

  // Setters
  set parameter(LocationParameter value) {
    _selectedParameter = value;
    notifyListeners();
  }

  // Provider Methods
  Future<void> getParameters() async {
    startLoading();

    final ParametersRequest request = ParametersRequest();

    final response = await apiCollection.parametersApi
        .getParameters(parametersRequest: request);

    if (response.status == ResponseStatus.successful) {
      // Clear existing parameters
      _parameters.clear();
      // Save locations data
      _parameters.addAll(response.response!.data!.results!);
    } else {
      // Show error message
      setError = response.error?.detail?[0].msg;
    }

    stopLoading();
  }
}
