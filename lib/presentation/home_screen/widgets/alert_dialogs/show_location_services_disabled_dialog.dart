import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/presentation/home_screen/home_screen_cubit/home_screen_cubit.dart';
import 'package:weather/utils/functions/navigation_functions.dart';

import '../../../shared_widgets_constant/progress_indicatior.dart';
import '../../home_screen_cubit/home_screen_states.dart';
import 'location_services_disabled_alert.dart';
import 'location_services_not_allowed_alert.dart';

class ShowLocationServicesDisabledDialog extends StatelessWidget {
  final HomeScreenCubit cubit;
  const ShowLocationServicesDisabledDialog({Key? key, required this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: const SizedBox(
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ),
        ElasticIn(
          child: BlocProvider(
            create: (context) => cubit,
            child: BlocBuilder<HomeScreenCubit, HomeScreenStates>(
              builder: (context, state) {
                return ConditionalBuilder(
                  condition: state is LocationServicesDisabledState,
                  builder: (context) =>
                      LocationServicesDisabledAlert(cubit: cubit),
                  fallback: (context) => ConditionalBuilder(
                    condition: state is LoadingSettingLocationState,
                    builder: (context) => const MainProgressIndicator(
                        loadingMessage:
                            "We'r trying to get your current location..."),
                    fallback: (context) => ConditionalBuilder(
                      condition: state is LoadingGettingPositionState,
                      builder: (context) => const MainProgressIndicator(
                          loadingMessage: "Getting position..."),
                      fallback: (context) => ConditionalBuilder(
                        condition: state is DeniedPermissionState,
                        builder: (context) =>
                            LocationServicesNotAllowedAppAlert(cubit: cubit),
                        fallback: (context) {
                          //Do this to pop any dialog
                          navigateBack(context);
                          return const Center(); //return a dummy widget
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
