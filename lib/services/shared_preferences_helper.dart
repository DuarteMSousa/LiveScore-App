import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  Future<List<int>> getFavTeams() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stringList = prefs.getStringList('favTeams');
    if (stringList == null) return [];
    return stringList.map((e) => int.parse(e)).toList();
  }

  Future<List<int>> getfavLeagues() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stringList = prefs.getStringList('favLeagues');
    if (stringList == null) return [];
    return stringList.map((e) => int.parse(e)).toList();
  }

  Future<void> addFavTeam(int favTeam) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? stringList = prefs.getStringList('favTeams');
    List<int> intArray = stringList?.map((e) => int.parse(e)).toList() ?? [];
    intArray.add(favTeam);

    List<String> updatedStringList = intArray.map((e) => e.toString()).toList();
    await prefs.setStringList('favTeams', updatedStringList);
  }

  Future<void> addFavLeague(int favLeague) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? stringList = prefs.getStringList('favLeagues');
    List<int> intArray = stringList?.map((e) => int.parse(e)).toList() ?? [];
    intArray.add(favLeague);

    List<String> updatedStringList = intArray.map((e) => e.toString()).toList();
    await prefs.setStringList('favLeagues', updatedStringList);
  }

  Future<void> deleteFavTeam(int favTeam) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? stringList = prefs.getStringList('favTeams');
    List<int> intArray = stringList?.map((e) => int.parse(e)).toList() ?? [];
    intArray.remove(favTeam);

    List<String> updatedStringList = intArray.map((e) => e.toString()).toList();
    await prefs.setStringList('favTeams', updatedStringList);
  }

  Future<void> deleteFavLeague(int favLeague) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? stringList = prefs.getStringList('favLeagues');
    List<int> intArray = stringList?.map((e) => int.parse(e)).toList() ?? [];
    intArray.remove(favLeague);

    List<String> updatedStringList = intArray.map((e) => e.toString()).toList();
    await prefs.setStringList('favLeagues', updatedStringList);
  }
}
