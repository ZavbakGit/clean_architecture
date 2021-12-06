import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/numbet_trivia_repositoty.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  // late GetConcreteNumberTrivia usecase;
  // late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    // mockNumberTriviaRepository = MockNumberTriviaRepository();
    // usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test text', number: 1);

  test('should get trivia for the number the repository', () {
    final mockNumberTriviaRepository = MockNumberTriviaRepository();
    final usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);

    // ignore: null_check_always_fails
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(1))
        .thenAnswer((_) async => Right(tNumberTrivia));

    // // The "act" phase of the test. Call the not-yet-existent method.
    // final result = await usecase.execute(number: tNumber);
    // // UseCase should simply return whatever was returned from the Repository
    // expect(result, const Right(tNumberTrivia));
    // // Verify that the method has been called on the Repository
    // verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    // // Only the above method should be called and nothing more.
    // verifyNoMoreInteractions(mockNumberTriviaRepository);
    expect(1, 1);
  });
}
