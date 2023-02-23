import 'package:flutter/material.dart';
import 'package:frontend/home/reservation_details.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../data_service/book_service.dart';
import 'Profile.dart';
import 'home.dart';

class FavoritePage extends StatefulWidget {
  final int userId;

  FavoritePage({required this.userId});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritePage> {
  late Future<List<Favorite>> _favoritesFuture;
  int _selectedIndex = 2;

  Future<List<Favorite>> _fetchFavorites() async {
    final response = await http.get(Uri.parse('http://192.168.43.73:8000/booking/api/favs/${widget.userId}/favorites/favorites/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Favorite> favorites = data.map((json) => Favorite.fromJson(json)).toList();
      return favorites;
    } else {
      throw Exception('Failed to fetch favorites');
    }
  }

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
      ),
      body: FutureBuilder<List<Favorite>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(backgroundImage: AssetImage(snapshot.data![index].hotel.image.split('/').last),
                  ),
                  title: Text(snapshot.data![index].hotel.name),
                  subtitle: Text(snapshot.data![index].hotel.place),
                  trailing: Text('${snapshot.data![index].hotel.likes} Likes'),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('Failed to fetch favorites'));
          }
        },
      ),

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
  void _onItemTapped(int index) async{
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      final prefs = await SharedPreferences.getInstance();
      final u = prefs.getString('userdata');
      var userdata = json.decode(u!);
      print(userdata['username']);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            Username: userdata['username'],),
        ),
      );
    }else if (_selectedIndex == 1)  {
      final prefs = await SharedPreferences.getInstance();
      final u = prefs.getString('userdata');
      var userdata = json.decode(u!);
      // print(userdata['id']);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReservationDetailsPage(id: userdata['id'], username: userdata['username'],)
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

}
