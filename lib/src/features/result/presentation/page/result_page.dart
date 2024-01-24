import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/features/mix/domain/model/candy_box.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key, required this.candyBox});

  final CandyBox candyBox;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You have ${candyBox.portions.length} candies',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(seasonControlProvider.notifier).reset();
                },
                child: const Text('Start Over'),
              ),
            ],
          ),
        ));
  }
}
