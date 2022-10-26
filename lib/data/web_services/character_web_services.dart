import 'package:dio/dio.dart';
import '../../constant/strings.dart';

class CharacterWebServices{
  late Dio dio;

  CharacterWebServices(){
    BaseOptions options = BaseOptions(
      baseUrl: baseUr,
      receiveDataWhenStatusError: true,
      connectTimeout: 20*1000,
      receiveTimeout: 20*1000,
    );
    dio = Dio(options);
  }
  //web service call
  Future<List<dynamic>> getAllCharacters() async{
    try{
      Response response = await dio.get('characters');
      print(response.data.toString());
      return response.data;
    } catch(e){
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getCharacterQuotes(String charName) async{
    try{
      Response response = await dio.get('quote', queryParameters: {'auther': charName});
      print(response.data.toString());
      return response.data;
    } catch(e){
      print(e.toString());
      return [];
    }
  }
}