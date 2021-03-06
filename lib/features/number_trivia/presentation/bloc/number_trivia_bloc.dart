import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
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
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreateNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
  }

  FutureOr<void> _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    await inputEither.fold(
      (failure) async => emit(const Error(message: invalidInputFailureMessage)),
      (integer) async {
        emit(Loading());

        final failureOrTrivia =
            await getConcreateNumberTrivia(Params(number: integer));

        final state = _getLoadedOrErrorState(failureOrTrivia);

        emit(state);
      },
    );
  }

  FutureOr<void> _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());

    final state = _getLoadedOrErrorState(failureOrTrivia);

    emit(state);
  }

  NumberTriviaState _getLoadedOrErrorState(
    Either<Failure, NumberTrivia> either,
  ) {
    return either.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }

  @override
  void onTransition(
      Transition<NumberTriviaEvent, NumberTriviaState> transition) {
    super.onTransition(transition);
    print('->> ' + transition.toString());
  }
}
