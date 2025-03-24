import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_rick_and_morty_app/core/platform/network_info.dart';
import 'package:the_rick_and_morty_app/feature/data/datasources/person_local_datasource.dart';
import 'package:the_rick_and_morty_app/feature/data/datasources/person_remote_datasource.dart';
import 'package:the_rick_and_morty_app/feature/data/repositories/person_repository_impl.dart';
import 'package:the_rick_and_morty_app/feature/domain/repositories/person_repository.dart';
import 'package:the_rick_and_morty_app/feature/domain/usecases/get_all_persons.dart';
import 'package:the_rick_and_morty_app/feature/domain/usecases/search_person.dart';
import 'package:the_rick_and_morty_app/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:the_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void>init() async {
  //BloC / Cubit
  sl.registerFactory(() => PersonListCubit(getAllPersons: sl()));
  sl.registerFactory(() => PersonSearchBloc(searchPerson: sl()));
  //UseCases
  sl.registerLazySingleton(() => GetAllPersons(sl()));
  sl.registerLazySingleton(() => SearchPerson(sl()));
  //Repository
  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(
      remoteDatasource: sl(),
      localDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<PersonRemoteDatasource>(() => PersonRemoteDatasourceImpl(client: http.Client()));
  sl.registerLazySingleton<PersonLocalDatasource>(() => PersonLocalDatasourceImpl(sharedPreferences: sl()));
  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
