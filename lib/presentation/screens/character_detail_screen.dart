import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../constant/my_color.dart';
import '../../data/models/character.dart';

class CharacterDetailsScreen extends StatelessWidget{

  final Character character;

  const CharacterDetailsScreen({super.key, required this.character});

  Widget buildSliverAppBar(){
    return SliverAppBar(
      expandedHeight: 500.0,
      pinned: true,
      stretch: true,
      backgroundColor: MyColor.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          character.nickName,
          style: const TextStyle(color: MyColor.myWhite),
        ),
        background: Hero(
          tag: character.charId, 
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
            )
          ),
      ),
    );
  }

  Widget characterInfo(String title,String value){
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              color: MyColor.myWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: MyColor.myWhite,
              fontSize: 16,
            )
          ),
        ]
      ),
      );
  }

  Widget buildDivider(double endIndent){
    return Divider(
      color: MyColor.myYellow,
      height: 30,
      endIndent: endIndent,
      thickness: 2,
    );
  }

  Widget checkIfQuotesAreLoaded(CharactersState state){
    if(state is QoutesLoaded){
      return displayRandomQuoteOrEmptySpace(state);
    }else{
      return showProgressIndicator();
    }
  }

  Widget displayRandomQuoteOrEmptySpace(state){
    var quotes = (state).quotes;
    if(quotes.length !=0){
      int randomQuoteIndex = Random().nextInt(quotes.length - 1); // generate random number in range of list size
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: MyColor.myWhite,
            shadows: [
              Shadow(
                blurRadius: 7,
                color: MyColor.myYellow,
                offset: Offset(0,0)
              )
            ]
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQuoteIndex].quote)
            ],
          ),
        ),
      );
    } else{
      return Container();
    }
  }

  Widget showProgressIndicator(){
    return const Center(
      child: CircularProgressIndicator(
        color: MyColor.myYellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes(character.name);
    return Scaffold(
      backgroundColor: MyColor.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo('Job : ', character.jobs.join(' / ')),
                      buildDivider(285),
                      characterInfo('Appeared in : ', character.categoryForTwoSeries),
                      buildDivider(220),
                      characterInfo('Seasons : ', character.appearanceOfSeasons.join(' / ')),
                      buildDivider(250),
                      characterInfo('Status : ', character.statusIfDeadOrAlive),
                      buildDivider(260),
                      character.betterCallSauAppearance.isEmpty ? Container():
                      characterInfo('Better Call Saul Season : ', character.betterCallSauAppearance.join(' / ')),
                      character.betterCallSauAppearance.isEmpty ? Container() :
                      buildDivider(110),
                      characterInfo('Actor/Actres : ', character.actorName),
                      buildDivider(220),
                      const SizedBox(height: 20,),
                      BlocBuilder<CharactersCubit, CharactersState>(
                        builder: (context, state){
                          return checkIfQuotesAreLoaded(state);
                        }
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 500.0,)
              ]
            )
            )
        ],
      ),
    );
  }

}