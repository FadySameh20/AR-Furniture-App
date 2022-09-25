import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 50,
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mariam'),
                Text('mariam@gmail.com'),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  print("hii");
                },
                child: Row(
                  children: [
                    Material(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.edit,
                          size: 30,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 26),
                    ),
                    Spacer(),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                height: 1,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  print("hii");
                },
                child: Row(
                  children: [
                    Material(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.edit,
                          size: 30,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 26),
                    ),
                    Spacer(),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                height: 1,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  print("hii");
                },
                child: Row(
                  children: [
                    Material(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.edit,
                          size: 30,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 26),
                    ),
                    Spacer(),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                height: 1,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
