import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/features/mix/domain/model/candy_box.dart';
import 'package:m_and_m/src/features/mix/presentation/provider/mix_provider.dart';

class MixPage extends ConsumerWidget {
  const MixPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candyBox = ref.watch(candyMixerProvider);
    final isBoxFull = ref.watch(candyBoxIsFullProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mix Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(candyMixerProvider.notifier).addCandy(
                          CandyColor.blue,
                        );
                  },
                  child: const Text('Blue'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(candyMixerProvider.notifier).addCandy(
                          CandyColor.red,
                        );
                  },
                  child: const Text('Red'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(candyMixerProvider.notifier).addCandy(
                          CandyColor.yellow,
                        );
                  },
                  child: const Text('Yellow'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(candyMixerProvider.notifier).addCandy(
                          CandyColor.green,
                        );
                  },
                  child: const Text('Green'),
                ),
              ],
            ),
            Text(
              'Candy Box: ${isBoxFull ? 'Full' : 'Not Full'}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final portion in candyBox.portions.entries)
                  Container(
                    width: 50,
                    height: 50,
                    color: portion.value.color,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
