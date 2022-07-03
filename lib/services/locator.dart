import 'package:get_it/get_it.dart';
import 'package:group_lunch_app/services/authentication_service.dart';

import 'navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthenticationService());
}