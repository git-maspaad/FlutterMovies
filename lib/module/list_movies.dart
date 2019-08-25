import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies/model/remote/movie_db_contract.dart';
import 'package:flutter_movies/sources/jsonMovies.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../common/widget/movie_card.dart';
import '../model/remote/plain_object/movie.dart';
import '../model/remote/movie_db.dart';

//MovieCard(Movie.parameterized("test", "overview", "10.10.2019", "3.19", "http://image.tmdb.org/t/p/w342/keym7MPn1icW1wWfzMnW3HeuzWU.jpg"))
class ListMovies extends StatefulWidget {
  @override
  State createState() {
    return DynamicMovies();
  }
}

class DynamicMovies extends State<ListMovies> {
  List<Movie> _movies;
  List<MovieCard> _movieCards;

  DynamicMovies() {
    _movies = List();
    _movieCards = List();

    MovieDb().getPopularMovies().then((List<Movie> m) {
      setState(() {
        _movies.clear();
        _movieCards.clear();

        _movies.addAll(m);
        for (Movie movie in _movies) {
          _movieCards.add(MovieCard(movie));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    Widget widget = Container();

    if(_movies.length > 0) {
      widget = CustomScrollView(
        slivers: <Widget>[
          SliverStaggeredGrid.countBuilder(
            crossAxisCount: 2,
            itemCount: _movieCards.length,
            itemBuilder: (BuildContext context,
                int index) => _movieCards[index],
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
        ],
      );
    }

    return widget;
  }
}


// Getting started new code
class ListMovieVol2 extends StatefulWidget
{
  @override
  _ListMovieVol2State createState() => _ListMovieVol2State();
}

class _ListMovieVol2State extends State<ListMovieVol2>
{
  List lDataJsonMovies = [];

  initMovies() async
  {
    // set empty for dynamic array inside list
    setState(()=> lDataJsonMovies = []);

    // look at bellow. this is json object format.
    /*
      {
        "id": "1",
        "title": "Iron Man"
      }
    */

    // because we will add json object (from jsonMovies.dart) into list, here the code.
    // jsonMovies.dart was creating from
    // url : https://api.themoviedb.org/3/movie/popular
    // method : get
    // body : form-data
    // params :
    // 1. "api_key" : "599c34d73931abe6918cfd12792fd160"
    // 2. "page" : "1"
    lDataJsonMovies.add(dataJsonMovies);
  }

  @override
  void initState()
  {
    super.initState();
    initMovies();
  }

  @override
  Widget build(BuildContext context)
  {
    // My code :
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StaggeredGridView.countBuilder(
        scrollDirection: Axis.vertical,
        primary: true,
        shrinkWrap: false,
        crossAxisCount: 4, // this count items inside each FlexBox container item
        itemCount: lDataJsonMovies == null ? 0 : (lDataJsonMovies[0]["results"] as List).length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            child: Material(
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: MoviesContract.POSTER_URL + lDataJsonMovies[0]["results"][index]["poster_path"].toString(),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          colorFilter: ColorFilter.mode(
                            Colors.red,
                            BlendMode.colorBurn
                          ),
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                      child: Platform.isIOS ? CupertinoActivityIndicator() : Container(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue[900],
                          strokeWidth: 1.0,
                        ),
                        height: 14.0,
                        width: 14.0,
                      ),
                    ),
                    errorWidget: (context, url, error) => Platform.isIOS ? CupertinoActivityIndicator() : Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue[900],
                        strokeWidth: 1.0,
                      ),
                      height: 14.0,
                      width: 14.0,
                    ),
                    fit: BoxFit.cover,
                  ),

                  InkWell(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(child: Container(),),

                          Container(
                            child: Text(
                              lDataJsonMovies[0]["results"][index]["original_title"].toString(),
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              softWrap: true,
                            ),
                            color: Colors.white.withOpacity(0.85),
                            padding: EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                      alignment: Alignment.bottomLeft,
                    ),
                    onTap: (){
                      print("Click movie -> " + lDataJsonMovies[0]["results"][index]["original_title"].toString());
                    },
                  ),
                ],
                fit: StackFit.expand,
              ),
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              clipBehavior: Clip.antiAlias,
              elevation: 0.25,
              color: Colors.white,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle, // BoxShape.circle or BoxShape.retangle
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(3.0),
                bottomRight: Radius.circular(3.0),
                topLeft: Radius.circular(3.0),
                topRight: Radius.circular(3.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 1.0,
                ),
              ],
            ),
            margin: EdgeInsets.all(3.0),
          );
        },
        staggeredTileBuilder: (int index) => new StaggeredTile.count(2, index.isEven ? 2 : 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}