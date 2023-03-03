import 'package:flutter/material.dart';
import 'package:time_money/src/presentation/control_hours/times/create_time/widgets/widgets.dart';

class CreateTimeCard extends StatelessWidget {
  const CreateTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: .24,
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                'Create Time:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Expanded(flex: 3, child: CreateHourField()),
                  Spacer(),
                  Expanded(
                    flex: 4,
                    child: CreateMinutesField(),
                  ),
                  Spacer(),
                  CreateTimeButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
