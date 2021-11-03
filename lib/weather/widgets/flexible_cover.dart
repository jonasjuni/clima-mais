import 'package:clima_mais/theme.dart';
import 'package:flutter/material.dart';

//Todo: Create a flexible cover style based on One Ui 4 weather app https://www.youtube.com/watch?v=9klkinRjoDs

class FlexibleSpaceCover extends StatelessWidget {
  const FlexibleSpaceCover({
    Key? key,
    required this.viewPortheight,
  }) : super(key: key);

  final double viewPortheight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final FlexibleSpaceBarSettings settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
        assert(
          settings != null,
          'A FlexibleSpaceBar must be wrapped in the widget returned by FlexibleSpaceBar.createSettings().',
        );
        return Stack(
          children: [
            SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: kToolbarHeight),
                padding:
                    const EdgeInsets.symmetric(horizontal: kLateralPadding),
                // color: Colors.teal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
