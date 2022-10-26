import '../models/character_quote.dart';
import '../web_services/character_web_services.dart';

import '../models/character.dart';
import '../models/character_quote.dart';

class CharacterRepository{
  
  final CharacterWebServices characterWebServices;

  CharacterRepository(this.characterWebServices);

  Future<List<Character>> getAllCharacters() async{
    final characters = await characterWebServices.getAllCharacters();
    return characters.map((character)=> Character.fromJson(character)).toList();
  }

  Future<List<Quote>> getCharacterQuote(String charName) async{
    final qoutes = await characterWebServices.getCharacterQuotes(charName);
    return qoutes.map((charQuotes)=> Quote.fromJson(charQuotes)).toList();
  }
}