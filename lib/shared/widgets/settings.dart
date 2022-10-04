import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<bool> allowSwitches = [false, false];

  // index 0 darkmode
  // index 1 notifications
  // 2 for icon (out of the list)
  Container addEndWidget(int switchIndex) {
    if (switchIndex == 2) {
      return Container(child: Icon(Icons.navigate_next));
    } else {
      return Container(
        child: Switch(
          value: allowSwitches[switchIndex],
          onChanged: (value) {
            setState(() {
              allowSwitches[switchIndex] = value;
            });
          },
          activeColor: Colors.green,
        ),
      );
    }
  }

  Padding settingsOption(String optionText, IconData optionIcon,
      [int switchIndex = 2]) {
    return Padding(
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
                      optionIcon,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(207,138,61, 1),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  optionText,
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                addEndWidget(switchIndex),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding settingsOptionCategory(String categoryText) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryText,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(children: [
          InkWell(
            onTap: () {
              //print("name");
            },
            child: Row(
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
                    Text(
                      'Mariam',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      'mariam@gmail.com',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.navigate_next),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          settingsOption("Dark Mode", Icons.dark_mode, 0),
          settingsOptionCategory("Profile"),
          settingsOption("Edit Profile", Icons.account_circle),
          settingsOption("Change Email", Icons.email),
          settingsOption("Change Password", Icons.key),
          settingsOptionCategory("Notifications"),
          settingsOption("Notifications", Icons.notifications, 1),
          settingsOptionCategory("App Settings"),
          settingsOption("My Favorites", Icons.favorite),
          settingsOption("My Orders", Icons.shopping_bag),
          settingsOption("About Us", Icons.error),
          settingsOption("Logout", Icons.logout),
        ]),
      ),
    );
  }
}
