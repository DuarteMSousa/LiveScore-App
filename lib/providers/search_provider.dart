import 'dart:core';
import 'package:flutter/material.dart';
import 'package:livescore/models/fixture.dart';
import 'package:livescore/services/api_service.dart';

/// Controla o estado dos utilizadores e pacotes de utilizadores.
///
/// Responsável por buscar, criar, atualizar e excluir utilizadores, além de gerenciar pacotes de utilizadores.
class SearchProvider with ChangeNotifier {
  /// Serviço responsável pelas requisições relacionadas ao utilizador.
  final ApiService _apiService = ApiService();

  /// Valor que controla o estado de carregamento de operações assíncronas.
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Mensagem de erro, via ValueNotifier, que pode ser exibida para o usuário.
  final ValueNotifier<String> errorMessage = ValueNotifier('');

  List<Team> searchedTeams = [];

  /// Limpa a mensagem de erro.
  void changeErrorValue(String e) {
    errorMessage.value = '';
    notifyListeners();
  }

  /// Busca um utilizador específico pelo ID.
  Future<void> loadSearchedTeams(String name) async {
    isLoading.value = true;
    notifyListeners();
    try {
      final teams = await _apiService.searchTeams(name);
      searchedTeams = teams;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

}
