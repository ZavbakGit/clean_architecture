import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreateNumberTrivia;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreateNumberTrivia,
    required this.random,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      inputEither.fold(
        (failure) {
          emit(const Error(message: invalidInputFailureMessage));
        },
        (integer) async {
          emit(Loading());
          final failureOrTrivia = await getConcreateNumberTrivia(
            Params(number: integer),
          );

          failureOrTrivia.fold(
            (failure) => {
              emit(const Error(message: serverFailureMessage)),
            },
            (trivia) {
              emit(Loaded(trivia: trivia));
            },
          );
        },
      );
    });
  }

  @override
  void onTransition(
      Transition<NumberTriviaEvent, NumberTriviaState> transition) {
    super.onTransition(transition);
    print('->> ' + transition.toString());
  }
}
