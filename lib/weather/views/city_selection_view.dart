import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CitySelection extends StatefulWidget {
  @override
  _CitySelectionState createState() => _CitySelectionState();
}

class _CitySelectionState extends State<CitySelection> {
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).selectCityFormCity),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: TextFormField(
            textInputAction: TextInputAction.search,
            controller: _textController,
            onFieldSubmitted: (name) => Navigator.pop(context, name.trim()),
            autofillHints: [AutofillHints.addressCity],
            autofocus: true,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).selectCityFormCity,
              hintText: 'São Paulo',
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () =>
                      Navigator.pop(context, _textController.text.trim())),
            ),
          ),
        ),
      ),
    );
  }
}
