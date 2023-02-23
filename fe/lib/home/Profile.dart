import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/home/reservation_details.dart';
import 'package:frontend/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_service/book_service.dart';
import 'favorite.dart';
import 'home.dart';

class Profile extends StatefulWidget {
   Profile({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  BookService bookService = BookService();

   int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          const Padding(padding: EdgeInsets.all(12.0)),
          IconButton(icon: Icon(Icons.login,size: 40,),
            onPressed: ()  {

              Navigator.push(context, MaterialPageRoute(
                  builder:(context) =>  LoginPage())
              );
            },
            // ),
            // ],
          ),
        ],
      ),
      body:  FutureBuilder<List>(
          future: bookService.getUser(this.widget.id),
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
                              SizedBox(height: 30),
                              CircleAvatar(
                                radius: 50,
                                backgroundImage
                                    : AssetImage('images/three.png'),
                              ),
                              SizedBox(height: 30),
                                  //mages
                                  Container(
                                    width: MediaQuery.of(context).size.width /1.2,
                                    height: MediaQuery.of(context).size.height/ 1.5,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(style: BorderStyle.solid)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MyRow(title: 'Usernane :', content: snapshot.data![i]['username']),
                                        Divider(),
                                        MyRow(title: 'First Name :', content: snapshot.data![i]['first_name']),
                                        Divider(),

                                        MyRow(title: 'Last Name :', content: snapshot.data![i]['last_name']),
                                        Divider(),

                                        // MyRow(title: 'Last Login :', content: snapshot.data![i]['last_login']),
                                        MyRow(title: 'Email :', content: snapshot.data![i]['email'])

                                      ],
                                    ),
                                  )
                                ],
                              ),
                      ),
                    );
                  });
            }else{return CircularProgressIndicator();
            }
          }),
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

// class MyRow extends StatelessWidget {
//   const MyRow({Key? key, required this.title, required this.content}) : super(key: key);
//   final String title;
//   final String content;
//
//   @override
//   Widget build(BuildContext context) {
//     return  Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Text(title,style: TextStyle(fontSize: 20),),
//         Text(content,style: TextStyle(fontSize: 20),),
//       ],);
//   }
// }
class MyRow extends StatelessWidget {
  const MyRow({Key? key, required this.title, required this.content})
      : super(key: key);
  final String title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              content ?? '-',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}






