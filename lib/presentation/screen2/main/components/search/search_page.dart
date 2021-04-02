import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen2/main/components/search/search_page_provider.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  bool isShowSuggest = true;
  SearchPageProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<SearchPageProvider>(context, listen: false);
    provider.editingController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    provider.editingController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, SearchPageProvider provider, child) {
          return Column(
            children: [buildSearchInput(), Stack(
              children: [
                isShowSuggest ? buildSuggestion() : buildList()
                ,
              ],
            )
            ],
          );
        },

      ),
    );
  }

  Widget buildSuggestion() {
    return Container(

    );
  }

  Widget buildList() {
    return Container(

    );
  }

  Widget buildSearchInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       Expanded(
         child: Container(
           margin: EdgeInsets.only(left: 20, right: 20, top: 20),
           padding: EdgeInsets.only(left: 20, right: 20),
           decoration: BoxDecoration(
             borderRadius:   BorderRadius.all(Radius.circular(60)),
             color: AppTheme.bottomNavigationBarBackgroundt,

           ),
           child: Row(
             children: [
               Expanded(
                 child: TextField(
                   decoration: InputDecoration(
                     hintText: "Search movies, TV show…",

                     hintStyle: TextStyle(
                         color: Color(0xFF666F7A),
                         fontSize: 16
                     ),
                     fillColor: Colors.white,
                     hoverColor: Colors.white,
                     focusColor: Colors.white,
                   ),
                   style: TextStyle(
                       color: Colors.white
                   ),
                   controller: provider.editingController,
                   onSubmitted: (newValue) {

                   },
                   autofocus: false,

                 ),
               ),
               SizedBox(width: 10,),
               Icon(
                 Icons.close, color: AppTheme.item_list_background,
               )
             ],
           ),
         ),
       ),
       Center(
         child: Container(
           alignment: Alignment.center,
           child: Text(

             "Cancel",

             style: TextStyle(
               color: AppTheme.bg_rank_top_rate
             ),
           ),
         ),
       )
     ],
    );
  }
}