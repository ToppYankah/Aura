import 'package:aura/network/api/auth/auth_endpoint.dart';
import 'package:aura/network/api/cities/cities_endpoint.dart';
import 'package:aura/network/api/countries/countries_endpoint.dart';
import 'package:aura/network/api/locations/location_endpoint.dart';
import 'package:aura/network/api/measurements/measurements_endpoint.dart';
import 'package:aura/network/api/parameters/parameters_endpoint.dart';

class EndpointCollection {
  AuthEndpoint get authEndpoint => AuthEndpoint();
  CitiesEndpoint get citiesEndpoint => CitiesEndpoint();
  CountriesEndpoint get countriesEndpoint => CountriesEndpoint();
  LocationsEndpoint get locationsEndpoint => LocationsEndpoint();
  ParametersEndpoint get parametersEndpoint => ParametersEndpoint();
  MeasurementsEndpoint get measurementsEndpoint => MeasurementsEndpoint();
}
