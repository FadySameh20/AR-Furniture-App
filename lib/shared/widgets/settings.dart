import 'package:ar_furniture_app/shared/widgets/order_screen.dart';
import 'package:ar_furniture_app/shared/widgets/profile_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/home_cubit.dart';
import '../../cubits/home_states.dart';
import '../../models/user_model.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<bool> allowSwitches = [false, false];
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var emailController = TextEditingController();
  List<Widget> NavbarPages = [ProfileEdit(),FavoriteScreen()];


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
            onTap: ()async {
              if(optionText == "Edit Profile"){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ProfileEdit()),
                );
              }
              else if(optionText == "My Orders"){
                if(BlocProvider.of<HomeCubit>(context).orders.isEmpty) {
                  await BlocProvider.of<HomeCubit>(context).getOrders();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  OrderScreen()),
                );
              }
              else if(optionText=="Logout"){
                context.read<HomeCubit>().logout(context);
              }
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ProfileEdit()),
              // );              }
              // print("hii");
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    var temp = BlocProvider
        .of<HomeCubit>(context)
        .cacheModel!
        .usersCachedModel
        .where((element) =>
    element.uid == FirebaseAuth.instance.currentUser!.uid);
    UserModel userModel = temp.first.cachedUser;
    fNameController.text = userModel.fName;
    lNameController.text = userModel.lName;
    emailController.text = userModel.email;
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          InkWell(
            onTap: () {
              // print("name");
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:  BlocProvider.of<HomeCubit>(context).cache.cachedUser.img!=""?NetworkImage(BlocProvider.of<HomeCubit>(context).cache.cachedUser.img):AssetImage("assets/profile.png") as ImageProvider,
                  radius: 50,
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fNameController.text+" "+lNameController.text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      emailController.text,
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
          // settingsOption("Change Email", Icons.email),
          // settingsOption("Change Password", Icons.key),
          settingsOptionCategory("Notifications"),
          settingsOption("Notifications", Icons.notifications, 1),
          settingsOptionCategory("App Settings"),
          // settingsOption("My Favorites", Icons.favorite),
          settingsOption("My Orders", Icons.shopping_bag),
          settingsOption("About Us", Icons.error),
          settingsOption("Logout", Icons.logout),
        ]),
      ),
    );
  }
}
