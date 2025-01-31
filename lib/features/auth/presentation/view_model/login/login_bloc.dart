import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/core/common/snackbar/my_snackbar.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/login_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/home/presentation/view/home_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/home/presentation/view_model/home_cubit.dart';

import '../../../../dashboard1/dashboard_view.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RegisterBloc _registerBloc;
  final HomeCubit _homeCubit;
  final LoginUsecase _loginUsecase;
  LoginBloc({
    required RegisterBloc registerBloc,
    required HomeCubit homeCubit,
    required LoginUsecase loginUsecase,
  })  : _registerBloc = registerBloc,
        _homeCubit = homeCubit,
        _loginUsecase = loginUsecase,
        super(LoginState.initial()) {
    on<NavigateRegisterScreenEvent>((event, emit) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
              value: _registerBloc, child: event.destination),
        ),
      );
    });

    on<NavigateHomeScreenEvent>((event, emit) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _homeCubit,
            child: event.destination,
          ),
        ),
      );
    });

    on<LoginUserEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await _loginUsecase(
        LoginParams(
          email: event.email,
          password: event.password,
        ),
      );

      result.fold(
        (failure) {
          emit(state.copyWith(isLoading: false, isSuccess: false));
          showMySnackBar(
            context: event.context,
            message: "Invalid Credentials",
            color: Colors.red,
          );
        },
        (token) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
          add(
            NavigateHomeScreenEvent(
              context: event.context,
              destination: const DashboardView(),
            ),
          );
          //_homeCubit.setToken(token);
        },
      );
    });
  }
}
