import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';
import '../repositories/numbet_trivia_repositoty.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> execute({
    required int number,
  }) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
