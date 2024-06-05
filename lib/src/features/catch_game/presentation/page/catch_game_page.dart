import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/core/presentation/routing/routes.dart';
import 'package:m_and_m/src/core/presentation/theme/color.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class CacheGamePage extends StatelessWidget {
  const CacheGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.green,
      body: Center(
        child: FilledButton(
          onPressed: () {
            ResultPageRoute(CandyBox(
              portions: {
                for (final color in CandyColor.values) color.index: color,
              },
            )).go(context);
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}
