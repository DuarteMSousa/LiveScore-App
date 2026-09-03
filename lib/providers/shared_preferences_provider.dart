import 'package:flutter/material.dart';
import 'package:livescore/services/shared_preferences_helper.dart';

class SharedPreferencesProvider with ChangeNotifier {
  /// Serviço responsável pelas requisições relacionadas ao utilizador.
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  /// Valor que controla o estado de carregamento de operações assíncronas.
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Mensagem de erro, via ValueNotifier, que pode ser exibida para o usuário.
  final ValueNotifier<String> errorMessage = ValueNotifier('');

  ValueNotifier<List<int>> favTeams = ValueNotifier([]);
  ValueNotifier<List<int>> favLeagues = ValueNotifier([]);

  /// Limpa a mensagem de erro.
  void changeErrorValue(String e) {
    errorMessage.value = '';
    notifyListeners();
  }

  Future<void> loadFavTeams() async {
    isLoading.value = true;
    notifyListeners();
    try {
      final teams = await helper.getFavTeams();
      favTeams.value = teams;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> addFavTeam(int id) async {
    isLoading.value = true;
    notifyListeners();
    try {
      await helper.addFavTeam(id);
      favTeams.value.add(id);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> deleteFavTeam(int id) async {
    isLoading.value = true;
    notifyListeners();
    try {
      await helper.deleteFavTeam(id);
      favTeams.value.remove(id);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> loadFavLeagues() async {
    isLoading.value = true;
    notifyListeners();
    try {
      final teams = await helper.getfavLeagues();
      favTeams.value = teams;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> addFavLeague(int id) async {
    isLoading.value = true;
    notifyListeners();
    try {
      await helper.addFavLeague(id);
      favLeagues.value.add(id);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> deleteFavLeague(int id) async {
    isLoading.value = true;
    notifyListeners();
    try {
      await helper.deleteFavLeague(id);
      favLeagues.value.remove(id);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }
}
