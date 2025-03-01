import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/core/common/snackbar/my_snackbar.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/remote_datasource/user_profile_service.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/login_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/dashboard1/admin_dashboard_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/dashboard1/dashboard_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/home/presentation/view_model/home_cubit.dart';

import './login_state.dart';

part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RegisterBloc _registerBloc;
  final HomeCubit _homeCubit;
  final LoginUsecase _loginUsecase;
  final UserProfileService _userProfileService;

  LoginBloc({
    required RegisterBloc registerBloc,
    required HomeCubit homeCubit,
    required LoginUsecase loginUsecase,
    required UserProfileService userProfileService,
  })  : _registerBloc = registerBloc,
        _homeCubit = homeCubit,
        _loginUsecase = loginUsecase,
        _userProfileService = userProfileService,
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

    on<LoginUserEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final result = await _loginUsecase(
        LoginParams(
          email: event.email,
          password: event.password,
        ),
      );

      if (result.isLeft()) {
        // Handle Failure
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: "Invalid Credentials",
          color: Colors.red,
        );
        return;
      }

      // ✅ Ensure the event handler does not complete before async operations finish
      final token = result.getOrElse(() => "");
      emit(state.copyWith(isLoading: false, isSuccess: true));

      try {
        // ✅ Fetch user profile AFTER successful login
        final userProfile = await _userProfileService.fetchUserProfile();

        // ✅ Navigate based on user role
        if (userProfile.role == "admin") {
          if (!event.context.mounted) return;
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(
              builder: (context) => AdminDashboardApp(),
            ),
          );
        } else {
          if (!event.context.mounted) return;
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(
              builder: (context) => DashboardView(),
            ),
          );
        }
      } catch (e) {
        // ✅ Handle profile fetch error
        if (!emit.isDone) {
          emit(state.copyWith(isLoading: false, isSuccess: false));
        }
        showMySnackBar(
          context: event.context,
          message: "Failed to fetch user profile",
          color: Colors.red,
        );
      }

      // ✅ Ensure final emit is only called if the event is still active
      if (!emit.isDone) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }
}
