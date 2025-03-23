import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_rick_and_morty_app/core/error/exception.dart';
import 'package:the_rick_and_morty_app/feature/data/models/person_model.dart';

abstract class PersonLocalDatasource {
  Future<List<PersonModel>> getLastPersonsFromCache();
  Future<void> personsToCache(List<PersonModel> persons);
}

const CACHED_PERSONS_LIST = 'CACHED_PERSONS_LIST';

class PersonLocalDatasourceImpl implements PersonLocalDatasource {
  final SharedPreferences sharedPreferences;

  PersonLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final jsonPersonsList = sharedPreferences.getStringList(CACHED_PERSONS_LIST);
    if (jsonPersonsList != null && jsonPersonsList.isNotEmpty) {
      return Future.value(jsonPersonsList.map((person) => PersonModel.fromJson(json.decode(person))).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) {
    final List<String> jsonPersonsList = persons.map((person) => json.encode(person.toJson())).toList();

    sharedPreferences.setStringList(CACHED_PERSONS_LIST, jsonPersonsList);
    print('Persons to write Cache: ${jsonPersonsList}');
    return Future.value(jsonPersonsList);
  }
}