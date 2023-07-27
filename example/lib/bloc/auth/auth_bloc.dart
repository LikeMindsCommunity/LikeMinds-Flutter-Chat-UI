import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_ui_sample/service/likeminds_service.dart';
import 'package:flutter_chat_ui_sample/service/preference_service.dart';
import 'package:flutter_chat_ui_sample/service/service_locator.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is InitAuthEvent) {
        emit(AuthLoading());
        setupChat(
          apiKey: event.apiKey,
          lmCallBack: event.callback,
        );
        emit(AuthInitiated());
      } else if (event is LoginEvent) {
        emit(AuthLoading());
        final response = await locator<LikeMindsService>()
            .initiateUser((InitiateUserRequestBuilder()
                  ..userId(event.userId)
                  ..userName(event.username))
                .build());
        if (response.success) {
          final memberRights =
              await locator<LikeMindsService>().getMemberState();
          locator<LMPreferenceService>()
              .storeUserData(response.data!.initiateUser!.user);
          locator<LMPreferenceService>()
              .storeCommunityData(response.data!.initiateUser!.community);
          locator<LMPreferenceService>().storeMemberRights(memberRights.data!);
          emit(AuthSuccess(user: response.data!.initiateUser!.user));
        } else {
          emit(AuthError(message: response.errorMessage!));
        }
      } else if (event is LogoutEvent) {}
    });
  }
}
