import 'dart:core';
import 'package:flutter/material.dart';
import 'package:livescore/models/fixture.dart';
import 'package:livescore/models/lineup.dart';
import 'package:livescore/services/api_service.dart';

/// Controla o estado dos utilizadores e pacotes de utilizadores.
///
/// Responsável por buscar, criar, atualizar e excluir utilizadores, além de gerenciar pacotes de utilizadores.
class MatchProvider with ChangeNotifier {
  /// Serviço responsável pelas requisições relacionadas ao utilizador.
  final ApiService _apiService = ApiService();

  /// Valor que controla o estado de carregamento de operações assíncronas.
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Mensagem de erro, via ValueNotifier, que pode ser exibida para o usuário.
  final ValueNotifier<String> errorMessage = ValueNotifier('');

  /// Utilizador atualmente selecionado.
  Fixture? selectedMatch;

  /// Lista de utilizadores selecionados.
  Map<int, List<Fixture>>? allSelectedMatchesHash = {};

  /// Lista de utilizadores selecionados.
  Map<int, List<Fixture>>? favSelectedMatchesHash = {};

  List<Lineup> lineups = [];

  /// Limpa a mensagem de erro.
  void changeErrorValue(String e) {
    errorMessage.value = '';
    notifyListeners();
  }

  /// Busca um utilizador específico pelo ID.
  Future<void> loadMatchById(String id) async {
    isLoading.value = true;
    notifyListeners();
    try {
      final match = await _apiService.getMatch(id);
      selectedMatch = match;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> loadAllTodayMatches() async {
    isLoading.value = true;
    notifyListeners();
    try {
      final matchList = await _apiService.getAllMatchesToday();
      var matchHash = <int, List<Fixture>>{};
      for (var match in matchList) {
        if (matchHash.containsKey(match.league!.id)) {
          matchHash[match.league!.id]!.add(match);
        } else {
          matchHash[match.league!.id] = [match];
        }
      }
      allSelectedMatchesHash = matchHash;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> loadAllFavTeamsMatches(List<int> teams) async {
    if (teams.isNotEmpty) {
      isLoading.value = true;
      notifyListeners();
      try {
        var matchHash = <int, List<Fixture>>{};
        for (var leagueId in allSelectedMatchesHash!.keys) {
          var leagueMatches = allSelectedMatchesHash![leagueId]!;
          for (var match in leagueMatches) {
            if (teams.contains(match.teams!.home!.id) ||
                teams.contains(match.teams!.away!.id)) {
              if (matchHash.containsKey(leagueId)) {
                matchHash[leagueId]!.add(match);
              } else {
                matchHash[leagueId] = [match];
              }
            }
          }
        }
        favSelectedMatchesHash = matchHash;
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadAllFavTeamsMatchesPaid(List<int> teams) async {
    isLoading.value = true;
    notifyListeners();
    try {
      var matchList = [];
      for (var team in teams) {
        matchList.add(await _apiService.getTeamMatchesToday(team));
      }
      var matchHash = <int, List<Fixture>>{};
      for (var match in matchList) {
        if (matchHash.containsKey(match.league!.id)) {
          matchHash[match.league!.id]!.add(match);
        } else {
          matchHash[match.league!.id] = [match];
        }
      }
      favSelectedMatchesHash = matchHash;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> loadMatchLineUps(String matchId) async {
    isLoading.value = true;
    notifyListeners();
    try {
      final lineups = await _apiService.getMatchLineups(matchId);
      this.lineups = lineups;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  // /// Busca todos os utilizadores com o perfil de administrador (ADM).
  // Future<void> loadAllADMs() async {
  //   isLoading.value = true;
  //   notifyListeners();
  //   try {
  //     final utilizadores = await _apiService.getAllADMs();
  //     selectedUtilizadorList = utilizadores;
  //     notifyListeners();
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = e.toString();
  //     notifyListeners();
  //   } finally {
  //     isLoading.value = false;
  //     notifyListeners();
  //   }
  // }

  // /// Busca todos os utilizadores com o perfil de nutricionista.
  // Future<void> loadAllNutricionistas() async {
  //   isLoading.value = true;
  //   notifyListeners();
  //   try {
  //     final utilizadores = await _apiService.getAllNutricionistas();
  //     selectedUtilizadorList = utilizadores;
  //     notifyListeners();
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = e.toString();
  //     notifyListeners();
  //   } finally {
  //     isLoading.value = false;
  //     notifyListeners();
  //   }
  // }

  // /// Busca todos os utilizadores com o perfil de personal trainer (PT).
  // Future<void> loadAllPTs() async {
  //   isLoading.value = true;
  //   notifyListeners();
  //   try {
  //     final utilizadores = await _apiService.getAllPTs();
  //     selectedUtilizadorList = utilizadores;
  //     notifyListeners();
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = e.toString();
  //     notifyListeners();
  //   } finally {
  //     isLoading.value = false;
  //     notifyListeners();
  //   }
  // }

  // /// Busca os pacotes de utilizador específicos pelo ID.
  // Future<void> loadPacotesUtilizadorById(int id) async {
  //   isLoading.value = true;
  //   notifyListeners();
  //   try {
  //     final pacotesUtilizador = await _apiService.getPacotesUtilizador(id);
  //     selectedPacotesUtilizador = pacotesUtilizador;
  //     notifyListeners();
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = e.toString();
  //     notifyListeners();
  //   } finally {
  //     isLoading.value = false;
  //     notifyListeners();
  //   }
  // }

  // /// Cria um novo utilizador.
  // Future<void> createUtilizador(Utilizador Utilizador) async {
  //   isLoading.value = true;
  //   notifyListeners();

  //   try {
  //     selectedUtilizador = await _apiService.createUtilizador(Utilizador);
  //     errorMessage.value = '';
  //     notifyListeners();
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = e.toString();
  //     notifyListeners();
  //   } finally {
  //     isLoading.value = false;
  //     notifyListeners();
  //   }
  // }

  // /// Atualiza um utilizador existente.
  // Future<void> putUtilizador(int id, Utilizador utilizador) async {
  //   isLoading.value = true;

  //   try {
  //     await _apiService.putUtilizador(id, utilizador);
  //     errorMessage.value = '';
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = e.toString();
  //     notifyListeners();
  //   } finally {
  //     isLoading.value = false;
  //     notifyListeners();
  //   }
  // }

  // /// Deleta um utilizador específico pelo ID.

  // Future<void> deleteUtilizador(int id) async {
  //   isLoading.value = true;

  //   try {
  //     await _apiService.deleteUtilizador(id);
  //     errorMessage.value = '';
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = e.toString();
  //   } finally {
  //     isLoading.value = false;
  //     notifyListeners();
  //   }
  // }

  // /// Busca os pacotes de utilizador com status "pendente".

  // Future<void> loadPedidosPendentes() async {
  //   isLoading.value = true;
  //   notifyListeners();
  //   try {
  //     final pacotesUtilizador = await _apiService.getPedidosPendentes();
  //     selectedPacotesUtilizador = pacotesUtilizador;
  //     notifyListeners();
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = e.toString();
  //     notifyListeners();
  //   } finally {
  //     isLoading.value = false;
  //     notifyListeners();
  //   }
  // }

  // /// Aceita um cliente específico.
  // Future<void> aceitarCliente(int idCliente) async {
  //   isLoading.value = true;
  //   notifyListeners();
  //   try {
  //     await _apiService.acceptCliente(idCliente);
  //     await loadPedidosPendentes();
  //     notifyListeners();
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = e.toString();
  //     notifyListeners();
  //   } finally {
  //     isLoading.value = false;
  //     notifyListeners();
  //   }
  // }

  // /// Carrega todos os clientes.
  // Future<void> loadAllClientes() async {
  //   isLoading.value = true;
  //   notifyListeners();
  //   try {
  //     final utilizadores = await _apiService.getClientes();
  //     selectedUtilizadorList = utilizadores;
  //     notifyListeners();
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = e.toString();
  //     notifyListeners();
  //   } finally {
  //     isLoading.value = false;
  //     notifyListeners();
  //   }
  // }
}
