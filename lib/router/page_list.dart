import '../pages/home/favorite_page.dart';
import '../pages/home/map_page.dart';
import '../pages/home/setting_page.dart';
import '../pages/home/station_list_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

class Pages {
  static const list = [
    LoginPage(),
    RegisterPage(),
    MapPage(),
    FavoritePage(),
    StationListPage(),
    SettingPage(),
  ];
}
