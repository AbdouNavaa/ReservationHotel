// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/data_service/book_service.dart';
import 'package:frontend/home/reservation_details.dart';
import 'package:frontend/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/login_response_model.dart';
import 'HotelsByPlace.dart';
import 'Profile.dart';
import 'booking.dart';
import 'favorite.dart';

class Home extends StatefulWidget {
  Home({super.key, this.Username});
  final String? Username;
  @override
  State<Home> createState() => _HomeState();
}
//
class _HomeState extends State<Home> {

  BookService bookService = BookService();
  late final Data data;
  int currentIndex = 0;
  bool isLiked = false;
  late final int id;

  // late List<Book>? books;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    like = false;
    bookService.getBook();
  }
  int _selectedIndex = 0;


  void _onItemTapped(int index) async{
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            Username: widget.Username,),
        ),
      );
    }else if (_selectedIndex == 1)  {
      final prefs = await SharedPreferences.getInstance();
      final u = prefs.getString('userdata');
      var userdata = json.decode(u!);
      print(userdata['id']);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReservationDetailsPage(id: userdata['id'], username: widget.Username,)
          ));
    }else if (_selectedIndex == 2)  {
      final prefs = await SharedPreferences.getInstance();
      final u = prefs.getString('userdata');
      var userdata = json.decode(u!);
      print(userdata['id']);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FavoritePage(userId: userdata['id'])
          ));
    }
    else{
      final prefs = await SharedPreferences.getInstance();
      final u = prefs.getString('userdata');
      var userdata = json.decode(u!);
      print(userdata['id']);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(id: userdata['id'])
          ));
    }
  }



  TextEditingController _controller = TextEditingController();
  late String _searchTerm;
  late bool like = false;
  late List<Hotel> hotels;
  // Future<void> _likeHotel(int id) async {
  //   final response = await http.post(Uri.parse('http://192.168.43.73:8000/booking/hotels/$id/like/'));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isLiked = true;
  //       hotel.likes++;
  //     });
  //   } else {
  //     throw Exception('Failed to like hotel');
  //   }
  // }
  Future<void> adddfavorit(int hotel, int user) async {
    final response = await http.post(
        Uri.parse('http://192.168.43.73:8000/booking/create_favoris'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'hotel': hotel, 'user': user}));
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 201) {
      throw Exception('Impossible d\'ajouter le type');
    } if (response.statusCode ==200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bien Recu!'),
            content: Text('Cet hotel est  ajouter dans votre favoris!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );}
    else if (response.statusCode ==400) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Exist deja!'),
            content: Text('Cet hotel exist deja dans votre favoris!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
          print('=====Hmmmm=+++');

      print('favoris ajouter avec succes');
    }
  }
  // Future<void> addToFavorites(int hotelId, int user) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://192.168.43.73:8000/booking/create_favoris/'),
  //       body: {
  //         'hotel': hotelId,
  //         'user': user, // replace with actual user ID
  //       },
  //     );
  //     if (response.statusCode == 201) {
  //       final data = json.decode(response.body);
  //       final favoris = Favorite.fromJson(data);
  //       for (int i = 0; i < hotels.length; i++) {
  //         if (hotels[i].hotelId == hotelId) {
  //           final hotel = hotels[i];
  //           hotel.likes = favoris.hotel.likes;
  //           setState(() {
  //             hotel.likes +=1;
  //           });
  //           break;
  //         }
  //       }
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels', style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),),
        centerTitle: true,
        // actions: [
        //   const Padding(padding: EdgeInsets.all(12.0)),
        //
        // ],
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
              children: [
                TextField(
                  // maxLength: 20,
                  style: TextStyle(height: 0.5),
                  controller: _controller,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50),),
                      hintText: 'Enter search term',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      )
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value;
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(355, 40),
                  ),
                  onPressed: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  HotelListScreen( search: _searchTerm,Username: widget.Username,)),
                  );},
                  // bookService.getHotelsByPlace(_searchTerm),
                  child: Text('Search'),
                ),
                Expanded(child:
                FutureBuilder<List>(
                    future: bookService.getBook(),
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, i){
                              return SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:[
                                        Row(
                                          children: [
                                            HomeCard(
                                              // onPessed1:() => bookService.likeHotel(snapshot.data![i]["id"]),
                                              onPessed1:() async {
                                                final prefs = await SharedPreferences.getInstance();
                                                final u = prefs.getString('userdata');
                                                var userdata = json.decode(u!);
                                                // print(userdata['id']);
                                                adddfavorit(snapshot.data![i]["id"],userdata['id']);
                                                // setState(() {
                                                //   bookService.getBook();
                                                //   // hotels.likes +=1;
                                                // });
                                              },
                                              //mages
                                              icon: UserPicture( picAdderess: 'images/'+ snapshot.data![i]["image"].split('/').last,
                                                  onPressed: (){  }, hotelId:snapshot.data![i]["id"] ,Username: widget.Username),

                                              title:snapshot.data![i]["name"], place: snapshot.data![i]["place"], hotelId: (snapshot.data![i]["id"]),
                                              fav: like ?Icon(Icons.favorite_border): Icon(Icons.favorite), likes: snapshot.data![i]["likes"],),
                                            SizedBox(width: 15,),
                                          ],
                                        ),
                                      ]
                                  ),
                                ),
                              );
                            });
                      }else{return CircularProgressIndicator();
                      }
                    }),

                ),

              ])),

      bottomNavigationBar:BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items:  [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_added_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'favs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),



    );
  }

}

class UserPicture extends StatelessWidget {
  const UserPicture({Key? key, required this.picAdderess, required this.onPressed, required this.hotelId, this.Username}) : super(key: key);
  final String picAdderess;
  final VoidCallback onPressed;
  final int hotelId;
  final String? Username;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  BookingScreen(hotelId: hotelId,Username: Username,)),
        );
      },
      child: Container(
        color: Colors.grey,
        child: Image.asset(picAdderess, width: 290,height: 220,fit: BoxFit.cover,),
      ),
    )
    ;
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    Key? key, required this.onPessed1, required this.icon, required this.title, required this.place, required this.hotelId, required this.fav, required this.likes,
  }) : super(key: key);
  final VoidCallback onPessed1;
  final UserPicture icon;
  final String title;
  final int hotelId;
  final int likes;
  final String place;
  final Icon fav;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPessed1 ,
      child: Container(
        // margin: EdgeInsets.only(top: kDefaultPadding / 2),
        width: MediaQuery.of(context).size.width /1.2,
        height: MediaQuery.of(context).size.height/ 2.3,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold
                  ),),
                Text(likes.toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold
                  ),),
                IconButton(
                  icon: fav,
                  color: Colors.black,
                  onPressed: onPessed1,
                ),
                Text(place,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold
                  ),),
              ],
            )


          ],
        ),
      ),
    );
  }
}
