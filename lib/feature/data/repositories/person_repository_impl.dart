import 'package:dartz/dartz.dart';
import 'package:the_rick_and_morty_app/core/error/exception.dart';
import 'package:the_rick_and_morty_app/core/error/failure.dart';
import 'package:the_rick_and_morty_app/core/platform/network_info.dart';
import 'package:the_rick_and_morty_app/feature/data/datasources/person_local_datasource.dart';
import 'package:the_rick_and_morty_app/feature/data/datasources/person_remote_datasource.dart';
import 'package:the_rick_and_morty_app/feature/data/models/person_model.dart';
import 'package:the_rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:the_rick_and_morty_app/feature/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDatasource remoteDatasource;
  final PersonLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    return await _getPersons(() {
      return remoteDatasource.getAllPersons(page);
    });
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    return await _getPersons(() {
      return remoteDatasource.searchPerson(query);
    });
  }

  Future<Either<Failure, List<PersonModel>>> _getPersons(
    Future<List<PersonModel>> Function() getPersons,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePerson = await getPersons();
        localDatasource.personsToCache(remotePerson);
        return Right(remotePerson);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final locationPerson = await localDatasource.getLastPersonsFromCache();
        return Right(locationPerson);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
