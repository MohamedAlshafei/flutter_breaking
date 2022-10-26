import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'business_logic/cubit/characters_cubit.dart';
import 'constant/strings.dart';
import 'data/models/character.dart';
import 'data/web_services/character_web_services.dart';
import 'presentation/screens/character_screen.dart';
import 'data/repository/character_repository.dart';
import 'presentation/screens/character_detail_screen.dart';

class AppRouter {
  late CharacterRepository characterRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    characterRepository = CharacterRepository(CharacterWebServices());
    charactersCubit = CharactersCubit(characterRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case characterScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (BuildContext context) => charactersCubit,
                  child: CharacterScreen(),
                ));
      case characterDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(  //create bloc to use in ui
              create: (BuildContext context) => 
                CharactersCubit(characterRepository),
              child: CharacterDetailsScreen(
                    character: character,
                  ),
            ));
    }
  }
}
