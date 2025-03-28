import 'package:dartz/dartz.dart';
import 'package:the_rick_and_morty_app/core/error/failure.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}