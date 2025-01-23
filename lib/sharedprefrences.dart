import 'package:shared_preferences/shared_preferences.dart';

class Usersharedpreferences
{
  static SharedPreferences? mypre;

  static void init() async
  {
    mypre= await SharedPreferences.getInstance();
  }

  static void setLogin(bool status) async
  {
    await mypre!.setBool("login", status);

  }
  static bool? getLogin()
  {
    return mypre!.getBool("login");
  }

  static void setUserName(String userName)async
  {
    await mypre!.setString("userName", userName);
  }
  static String? getUserName()
  {
    return mypre!.getString("userName");
  }
  static void setUserEmail(String email)async
  {
    await mypre!.setString("email", email);
  }
  static String? getUserEmail()
  {
    return mypre!.getString("email");
  }
  static void setUserPic(String image)async
  {
    await mypre!.setString("image", image);
  }
  static String? getUserPic()
  {
    return mypre!.getString("image");
  }
//   user profile


}