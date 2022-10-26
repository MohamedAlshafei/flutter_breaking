import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constant/my_color.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../business_logic/cubit/characters_cubit.dart';
import '../../data/models/character.dart';
import '../widgets/character_item.dart';

class CharacterScreen extends StatefulWidget{
  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {

  late List<Character> allCharacters;
  late List<Character> searchedForCharacter;
  bool isSearching = false;
  final searchTextController = TextEditingController();

  Widget buildSearchField(){
    return TextField(
      controller: searchTextController,
      cursorColor: MyColor.myGrey,
      decoration: const InputDecoration(
        hintText: 'find a character...',
        hintStyle: TextStyle(color: MyColor.myGrey, fontSize: 18),
        border: InputBorder.none,
      ),
      style: const TextStyle(color: MyColor.myGrey, fontSize: 18),
      onChanged: (searchedCharacter){
        addSearchedForItemsForSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForItemsForSearchedList(String searchedCharacter){
    searchedForCharacter = allCharacters.where((character) => 
      character.name.toLowerCase().startsWith(searchedCharacter)
      ).toList();
      setState(() {});
  }
  List<Widget> buildAppBarAction(){
    if(isSearching){
      return [
        IconButton(
          onPressed: (){
            clearSearch();
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.clear,color: MyColor.myGrey,)
          )
      ];
    }else{
      return [
        IconButton(
          onPressed: startSearch, 
          icon: const Icon(Icons.search,color: MyColor.myGrey,)
          )
      ];
    }
  }

  void startSearch(){
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearch));

    setState(() {
      isSearching = true;
    });
  }

  void stopSearch(){
    clearSearch();
    setState(() {
      isSearching = false;
    });
  }

  void clearSearch(){
    setState(() {
      searchTextController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: ((context, state) {
        if(state is CharactersLoaded){
          allCharacters = (state).characters;  // characters is the list in characterLoaded class
          return buildLoadedListWidgets();
        }
        else {
          return showLoadedIndicator();
        }
      })
      );
  }

  Widget showLoadedIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColor.myYellow,
      ),
    );
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: MyColor.myGrey,
        child: Column(
          children: [
            buildCharacterList()
          ],
        ),
      ),
    );
  }

  Widget buildCharacterList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2/3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: searchTextController.text.isEmpty? 
        allCharacters.length : 
        searchedForCharacter.length ,
      itemBuilder: (ctx, index){
        return CharacterItem(
          character: searchTextController.text.isEmpty ?
            allCharacters[index] :
            searchedForCharacter[index] ,
          );
      },
      );
  }

  Widget buildAppBarTitle(){
    return const Text(
      'Characters',
      style: TextStyle(
        color: MyColor.myGrey
      ),
    );
  }

  Widget buildNoInternetWidget(){
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            const Text(
              'Can\'t connect .. check internet',
              style: TextStyle(
                fontSize: 22,
                color: MyColor.myGrey
              ),
            ),
            Image.asset('assets/images/no_internet.png'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: isSearching ? const BackButton(color: MyColor.myGrey,) : Container(),
        backgroundColor: MyColor.myYellow,
        title: isSearching ? buildSearchField():buildAppBarTitle(),
        actions: buildAppBarAction(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ){
          final bool connected = connectivity != ConnectivityResult.none;

          if(connected){
            return buildBlocWidget();
          }else{
            return buildNoInternetWidget();
          }
        },
        child: showLoadedIndicator(),
        )
    );
  }
}