import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/location_search/location_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

// class CitySelection extends StatefulWidget {
//   const CitySelection({Key? key}) : super(key: key);
//   @override
//   _CitySelectionState createState() => _CitySelectionState();
// }

// class _CitySelectionState extends State<CitySelection> {
//   final _textController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context).selectCityFormCity),
//       ),
//       body: Column(
//         children: [
//           Form(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
//               child: TextFormField(
//                 textInputAction: TextInputAction.search,
//                 controller: _textController,
//                 onFieldSubmitted: (name) => Navigator.pop(context, name.trim()),
//                 autofillHints: const [AutofillHints.addressCity],
//                 autofocus: true,
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context).selectCityFormCity,
//                   hintText: 'São Paulo', //TODO: l10n
//                   suffixIcon: IconButton(
//                       icon: const Icon(Icons.search),
//                       onPressed: () =>
//                           Navigator.pop(context, _textController.text.trim())),
//                 ),
//               ),
//             ),
//           ),
//           OutlinedButton(
//               onPressed: () =>
//                   context.read<WeatherBloc>().add(DeviceLocationRequested()),
//               child: const Text('Use my location')),
//         ],
//       ),
//     );
//   }
// }

class LocationSearchPage extends StatelessWidget {
  const LocationSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationSearchBloc(
          weatherRepository: context.read<WeatherRepository>()),
      child: const SearchBar(),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FloatingSearchBar(
        isScrollControlled: true,
        builder: (context, animation) => Container(
          height: 600,
          color: Colors.lightGreen,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () => context
                    .read<LocationSearchBloc>()
                    .add(const DeviceLocationRequested()),
                child: const Text('Use you location'))
          ],
        ),
        onSubmitted: (value) => context
            .read<LocationSearchBloc>()
            .add(SearchLocationByNameRequested(value)),
        onQueryChanged: (value) => context
            .read<LocationSearchBloc>()
            .add(LocationSearchQueryChanged(value)),
      ),
    );
  }
}
