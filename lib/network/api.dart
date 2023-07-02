import 'package:aura/network/api/auth/auth_api.dart';
import 'package:aura/network/api/cities/cities_api.dart';
import 'package:aura/network/api/countries/countries_api.dart';
import 'package:aura/network/api/locations/location_api.dart';
import 'package:aura/network/api/measurements/measurements_api.dart';
import 'package:aura/network/api/parameters/parameters_api.dart';
import 'package:aura/network/requester.dart';

class ApiCollection {
  Requester requester;

  ApiCollection({required this.requester});

  AuthApi get authApi => AuthApi(requester: requester);
  CitiesApi get citiesApi => CitiesApi(requester: requester);
  CountriesApi get countriesApi => CountriesApi(requester: requester);
  LocationsApi get locationsApi => LocationsApi(requester: requester);
  ParametersApi get parametersApi => ParametersApi(requester: requester);
  MeasurementsApi get measurementsApi => MeasurementsApi(requester: requester);
}
