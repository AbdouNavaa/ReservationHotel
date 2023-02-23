import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data_service/book_service.dart';
import 'Profile.dart';
import 'favorite.dart';
import 'home.dart';

class ReservationDetailsPage extends StatefulWidget {
  final int id;
  final String? username;

  ReservationDetailsPage({required this.id, required this.username});

  @override
  _ReservationDetailsPage createState() => _ReservationDetailsPage();
}

class _ReservationDetailsPage extends State<ReservationDetailsPage> {
  BookService bookService = BookService();
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    // var total = price * days;
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),

      ),
      body:     Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Mes Reservation",style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
            // CircleAvatar(radius: 50,
            //     child: IconButton(onPressed: (){}, icon: Icon(Icons.account_circle,size: 50,))),
            // Text(data)
            Expanded(
              child:
              FutureBuilder<List>(
                  future: bookService.getBookings(widget.id),
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

                                            //mages
                                          Container(
                                width: MediaQuery.of(context).size.width /1.2,
                                height: MediaQuery.of(context).size.height/ 3,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  border: Border.all(style: BorderStyle.solid)
                                ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            MyRow(title: 'ID de Reservation', content: (snapshot.data![i]['id']).toString()),
                                            MyRow(title: 'date de Reservation', content: (snapshot.data![i]['date'])),
                                            MyRow(title: 'ID de User', content: (snapshot.data![i]['user']).toString()),
                                            MyRow(title: 'ID de Room', content: (snapshot.data![i]['room']).toString()),

                                            ElevatedButton(onPressed:() {
                                              bookService.deleteReservation(snapshot.data![i]['id']);
                                              setState(() {
                                                bookService.getBookings(snapshot.data![i]['user']);
                                              });

                                            },
                                              child: Text("Delete"),
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(300, 50),
                                              ),
                                            ),
                                          ])
                                          )],
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
          ],
        ),
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            Username: widget.username,),
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
              builder: (context) => ReservationDetailsPage(id: userdata['id'], username: widget.username,)
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

class MyRow extends StatelessWidget {
  const MyRow({Key? key, required this.title, required this.content}) : super(key: key);
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(title,style: TextStyle(fontSize: 20),),
        Text(content,style: TextStyle(fontSize: 20),),
      ],
    );
  }
}
