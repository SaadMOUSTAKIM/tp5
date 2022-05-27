import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MOUSTAKIM Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(title: 'ListingUsers'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  Future<List<User>> _getUsers() async {

    var data = await http.get(Uri.parse('https://randomuser.me/api/?results=10'));

    final fetchUsers = ApiResponse.fromJson(json.decode(data.body) as Map<String, dynamic>);

    // var jsonData = json.decode(data.body);
    //
    // List<User> users = [];
    //
    // for(var u in jsonData){
    //
    //   User user = User(u["id"], u["name"], u["email"], u["phone"]);
    //
    //   users.add(user);
    //
    // }
    //
    // print(users.length);


    return fetchUsers.users;

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            print(snapshot.data);
            if(snapshot.data == null){
              return Container(
                  child: Center(
                      child: Text("Loading...")
                  )
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card (child:ListTile(
                    leading: CircleAvatar(backgroundImage:
                    NetworkImage(snapshot.data[index].picture)),
                    //snapshot.data[index].picture
                    //): ,),
                    //Colors.lightBlueAccent
                    //backgroundImage: NetworkImage(
                    //snapshot.data[index].picture
                    //),
                    //),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                    onTap: (){
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                      );
                    },
                  ));
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {

  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile ',
        ),
      ),
      body: Column(
        children: [
          Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Image(
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                  image: const NetworkImage(
                      'https://images.unsplash.com/photo-1485160497022-3e09382fb310?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vdW50YWluc3xlbnwwfHwwfHw%3D&w=1000&q=80'),
                ),
                Positioned(
                    bottom: -50.0,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: NetworkImage(
                            'https://scontent.ftun7-1.fna.fbcdn.net/v/t39.30808-6/s552x414/255729438_2061962933967301_6536194202848894171_n.jpg?_nc_cat=103&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=8WN5tCaKhNQAX8wbDdB&_nc_ht=scontent.ftun7-1.fna&oh=00_AT-vQcebr_3_dyt5y7xkSu5mO6tTdZSL7pr80y15zU8aOQ&oe=61CD0B9D'),
                      ),
                    ))
              ]),
          SizedBox(
            height: 45,
          ),
          ListTile(
            title: Center(child: Text('Iheb Meftah')),
            subtitle: Center(child: Text('Computer Science Student ')),
          ),
          ListTile(
            title: Text('About me '),
            subtitle: Text(
                'Iheb Meftah ,étudiant en Licence Science Inforamtiques specialite Anlayse De Donnees et Big Data  '),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text('Education'),
            subtitle: Text(
                'Higher Institute of Computer Science and Multimedia of Sfax '),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
  }
}


class User {
  final String genre;
  final String name;
  final String email;
  final String phone;
  final String picture;

  User(this.genre, this.name,this.email,this.phone,this.picture);

  factory User.fromJson(Map<String, dynamic> json) => User(
    json["gender"],
    json["name"]["last"],
    json["email"],
    json["phone"],
    json["picture"]["medium"],
  );

}

class ApiResponse {
  ApiResponse({
    required this.users,
  });

  List<User> users;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    users: List<User>.from(
      json["results"].map((x) => User.fromJson(x)),
    ),
  );
}



