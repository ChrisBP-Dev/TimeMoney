import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    required this.button,
    super.key,
  });

  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Expanded(child: HourField()),
            const Expanded(child: MinutesField()),
            button,
          ],
        ),
      ),
    );
  }
}

class HourField extends StatelessWidget {
  const HourField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Hour:'),
        const SizedBox(width: 25),
        SizedBox(
          width: 45,
          child: TextField(
            onChanged: (value) {},
            decoration: const InputDecoration(
              hintText: '2',
              filled: true,
              border: OutlineInputBorder(),
            ),
          ),
        )
      ],
    );
  }
}

class MinutesField extends StatelessWidget {
  const MinutesField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Minutes:'),
        const SizedBox(width: 25),
        SizedBox(
          width: 55,
          child: TextField(
            onChanged: (value) {},
            decoration: const InputDecoration(
              hintText: '25',
              filled: true,
              border: OutlineInputBorder(),
            ),
          ),
        )
      ],
    );
  }
}
