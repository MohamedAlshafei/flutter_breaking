import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/character.dart';
import '../../data/models/character_quote.dart';
import '../../data/repository/character_repository.dart';

part 'characters_state.dart';


class CharactersCubit extends Cubit<CharactersState> {
  final CharacterRepository characterRepository;
  List<Character>? characters;

  CharactersCubit(this.characterRepository) : super(CharactersInitial());

  List<Character>? getAllCharacters(){
    characterRepository.getAllCharacters().then((characters) => {
      emit(CharactersLoaded(characters)),
      this.characters = characters
    });
    return characters;
  }

  void getQuotes(String charName){
    characterRepository.getCharacterQuote(charName).then((quotes) =>{
      emit(QoutesLoaded(quotes))
    });
  }
}
