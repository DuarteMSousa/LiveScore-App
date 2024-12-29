import 'package:flutter/material.dart';
import 'package:livescore/providers/search_provider.dart';
import 'package:livescore/providers/shared_preferences_provider.dart';
import 'package:livescore/widgets/bottombar.dart';
import 'package:livescore/widgets/search_text_field.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SharedPreferencesProvider>().loadFavTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SearchTextField(controller: controller, labelText: ''),
                SizedBox(height: 20),
                searchProvider.isLoading.value
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : searchProvider.errorMessage.value.isNotEmpty
                        ? Expanded(
                            child: Center(
                                child: Text(searchProvider.errorMessage.value)))
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var team in searchProvider.searchedTeams)
                                    SearchResult(
                                        image: team.logo,
                                        name: team.name,
                                        id: team.id),
                                ],
                              ),
                            ),
                          ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

class SearchResult extends StatelessWidget {
  final String image;
  final String name;
  final int id;
  const SearchResult(
      {super.key, required this.image, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Consumer<SharedPreferencesProvider>(
            builder: (context, provider, child) {
          var isFav = provider.favTeams.value.contains(id);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                alignment: Alignment.center,
                height: 70,
                width: 70,
                image: NetworkImage(image),
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () {
                  isFav
                      ? context
                          .read<SharedPreferencesProvider>()
                          .deleteFavTeam(id)
                      : context
                          .read<SharedPreferencesProvider>()
                          .addFavTeam(id);
                },
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  size: 28,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          );
        }));
  }
}
