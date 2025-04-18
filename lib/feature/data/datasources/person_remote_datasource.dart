import 'dart:convert';

import 'package:the_rick_and_morty_app/core/error/exception.dart';
import 'package:the_rick_and_morty_app/feature/data/models/person_model.dart';
import 'package:http/http.dart' as http;

abstract class PersonRemoteDatasource {
  Future<List<PersonModel>> getAllPersons(int page);
  Future<List<PersonModel>> searchPerson(String query);
}

class PersonRemoteDatasourceImpl implements PersonRemoteDatasource {
  final http.Client client;

  PersonRemoteDatasourceImpl({required this.client});

  @override
  Future<List<PersonModel>> getAllPersons(int page) => _getPersonFromUrl(
    'https://rickandmortyapi.com/api/character/?page=$page',
  );

  @override
  Future<List<PersonModel>> searchPerson(String query) => _getPersonFromUrl(
    'https://rickandmortyapi.com/api/character/?name=$query',
  );

  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    print(url);
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final persons = json.decode(response.body);
      return (persons['results'] as List)
          .map((person) => PersonModel.fromJson(person))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
