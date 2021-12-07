import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/numbet_trivia_repositoty.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetConcreteNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  group('group getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTrivia = NumberTrivia(text: 'test text', number: 1);

    test('should get trivia for the number from the repository', () async {
      when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      final result = await usecase(const Params(number: tNumber));
      expect(result, const Right(tNumberTrivia));

      verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
          .called(1);

      verifyNoMoreInteractions(mockNumberTriviaRepository);
    });
  });
}
