import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flyingwolf/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variable used for Loaders
  bool _isLoading = false;

//variable used for handling Cursor Value & Parameters
  int cursor = 0;
  String cursorParameter = '';

  //API URL
  String baseurl =
      "http://tournaments-dot-game-tv-prod.uc.r.appspot.com/tournament/api/tournaments_list_v2?limit=10&status=all";
  final String playerDetailsURL =
      "https://42fe24c6-2150-497b-8570-ecb8543a850d.mock.pstmn.io";
  //Final URL to call API
  var url;

  //Variable used to store API Data
  List<dynamic> data = [];
  var playerData;

//Controller ussed for Pagination concept
  ScrollController scrollController = ScrollController();

// Dispose St.
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

//Initial State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchGameDetails(isFirstTime: false);
      }
    });
  }

//Build Method for Home Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Flyingwolf',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              tooltip: "Logout",
              onPressed: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.remove('username');
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              )),
        ),
        body: FutureBuilder<List<dynamic>>(
            future: Future.wait(
                [fetchGameDetails(isFirstTime: true), playerDetails()]),
            builder: (context, AsyncSnapshot<List<dynamic>> user) {
              if (user.hasData == false) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (data.isEmpty) {
                  return Center(
                    child: Text('Network Error!'),
                  );
                } else {
                  return SafeArea(
                      child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              playerProfile(),
                              const SizedBox(
                                height: 10.0,
                              ),
                              rcmText(),
                              const SizedBox(
                                height: 10.0,
                              ),
                              gameList(),
                            ],
                          )));
                }
              }
            }));
  }

//Widget UI for the game list below recommended for you
  Widget gameList() {
    return Center(
        child: _isLoading == true
            ? CircularProgressIndicator()
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: index == data.length - 1
                        ? CircularProgressIndicator()
                        : Material(
                            elevation: 1.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Card(
                                elevation: 1.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                child: Container(
                                  height: 170.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        new Expanded(
                                          flex: 5,
                                          child: Image(
                                            width: double.infinity,
                                            image: NetworkImage(
                                              data[index]['cover_url'],
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        new Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  data[index]['name'],
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                Text(data[index]['game_name'],
                                                    style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 18.0,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  );
                }));
  }

//Widget UI for player Information
  Widget playerProfile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 250.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 130.0,
                    width: 120.0,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/profile.jpg',
                            ),
                            fit: BoxFit.fill),
                        shape: BoxShape.circle,
                      ),
                      child: Container(),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Text(
                            playerData['name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 200.0,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(playerData['rating'].toString(),
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    )),
                                Text(" Elo Rating",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.0,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Expanded(
                    flex: 3,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                bottomLeft: Radius.circular(16.0)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.orange, Colors.yellow],
                                stops: [0.8, 1.0])),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  playerData["play"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Tournaments \nplayed",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Expanded(
                    flex: 3,
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.purple, Colors.purpleAccent],
                                stops: [0.6, 1.0])),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                playerData["won"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                              Text(
                                "Tournaments \nwon",
                                textAlign: TextAlign.center,
                                softWrap: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        )),
                  ),
                  new Expanded(
                    flex: 3,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.deepOrange,
                                  Colors.orangeAccent
                                ],
                                stops: [
                                  0.6,
                                  1.0
                                ])),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                playerData['percent'] + "%",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                              Text(
                                "Winning \npercentage",
                                textAlign: TextAlign.center,
                                softWrap: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

//API call to fetch Game Lists
  Future fetchGameDetails({bool isFirstTime = true}) async {
    cursorParameter == ''
        ? url = baseurl
        : url = baseurl + '&cursor=' + cursorParameter + '${cursor}';

    final response = await Dio().get(url);
    cursorParameter = (response.data['data']['cursor']).toString();

    cursor++;
    data == null
        ? data = (response.data['data']['tournaments'])
        : data.addAll(response.data['data']['tournaments']);

    if (isFirstTime == false) {
      setState(() {
        data == null
            ? data = (response.data['data']['tournaments'])
            : data.addAll(response.data['data']['tournaments']);

        _isLoading = false;
      });
    }
  }

//API call to fetch player details
  Future playerDetails() async {
    var response = await http.get(Uri.parse(playerDetailsURL));
    playerData = json.decode(response.body);
    _isLoading = false;
  }
}

//Recommended for you Text UI
class rcmText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Recommended for you",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
