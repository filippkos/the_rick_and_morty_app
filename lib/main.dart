import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_rick_and_morty_app/common/app_colors.dart';
import 'package:the_rick_and_morty_app/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:the_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:the_rick_and_morty_app/feature/presentation/pages/person_screen.dart';
import 'package:the_rick_and_morty_app/locator_service.dart' as di;

import 'locator_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

@override
Widget build(BuildContext context) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<PersonListCubit>(
        create: (context) => sl<PersonListCubit>()..LoadPerson(),
      ),
      BlocProvider<PersonSearchBloc>(
        create: (context) => sl<PersonSearchBloc>(),
      ),
    ],
    child: MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          surface: AppColors.mainBackground,
        ),
      ),
      home: HomePage(),
    ),
  );
}
}
