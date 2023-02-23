// import 'dart:convert';

// import 'package:frontend/auth_service/auth_service.dart';
// import 'package:http/http.dart' as http;

// main() async {
//   // ListOfBook listOfBook = await BookService().getBook();
//   // print(listOfBook.books[0].type);
// }


//   int id;
//   String type;
//   String description;
//   String image;

//   Book({
//     required this.id,
//     required this.type,
//     required this.description,
//     required this.image,
//   });

//   factory Book.fromJson(map) {
//     return Book(
//         id: map['id'],
//         type: map['type'],
//         description: map['description'],
//         image: map['image']);
//   }
// }

// previusmain() async {
//   AuthService authService = AuthService();
//   var response = await http
//       .get(Uri.parse("http://127.0.0.1:8000/accounts/user/"), headers: {
//     "Authorization": "Token 1cbc9c0e6763041f9825971f332cf4517dd7413d"
//   });
//   print(response.body);
// }

// // // var response = await http
//   // //     .get(Uri.parse("http://127.0.0.1:8000/accounts/logout/"), headers: {
//   // //   "Authorization": "Token 1cbc9c0e6763041f9825971f332cf4517dd7413d"
//   // // });
//   // print(response.body);
//   // // LogniResponse? logniResponse =
//   // //     await authService.login("babana9977@gmail.com", "Azerty2022");

//   // // if (logniResponse != null) {
//   // //   if (logniResponse.Key != null) print(logniResponse.Key);
//   // //   if (logniResponse.non_field_errors != null) {
//   // //     logniResponse.non_field_errors!.forEach((element) {
//   // //       print(element);
//   // //     });
//   // //   }
//   // // }