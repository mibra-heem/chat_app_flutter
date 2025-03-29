import 'package:dartz/dartz.dart';
import 'package:mustye/core/errors/failure.dart';

typedef RFuture<T> = Future<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
