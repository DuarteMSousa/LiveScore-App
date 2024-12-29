import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livescore/providers/search_provider.dart';
import 'package:provider/provider.dart';

/// Um campo de texto customizado que permite controle de visibilidade da palavrapasse e validação.
/// Ele oferece suporte para um texto oculto, como no caso de palavraspasse, e permite personalizar
/// o comportamento e estilo do campo de entrada.
class SearchTextField extends StatefulWidget {
  /// O controlador que gerencia o texto inserido no campo de texto.
  final TextEditingController controller;

  /// O texto exibido como rótulo acima do campo de texto.
  final String labelText;

  /// A função de validação que será chamada para verificar a entrada do usuário.
  final String? Function(String?)? validator;

  /// O tipo de teclado que será exibido para o usuário, como texto, número, e-mail, etc.
  final TextInputType keyboardType;

  /// O número máximo de linhas que o campo de texto pode ocupar.
  /// Esse valor pode ser útil para campos de texto multilinha.
  final int maxLines;

  /// Cria uma instância do [CustomTextField] com os parâmetros fornecidos.
  SearchTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          labelText: widget.labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                context.read<SearchProvider>().loadSearchedTeams(widget.controller.text);
              },
              icon: Icon(CupertinoIcons.search),
              iconSize: 30,
            ),
          ),
        ));
  }
}
