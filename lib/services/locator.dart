import 'package:get_it/get_it.dart';
import 'authentication_service.dart';
import 'firestore_service.dart';
import 'navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirestoreService());
}