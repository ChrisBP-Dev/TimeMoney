import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

class CreateTimeCard extends StatelessWidget {
  const CreateTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(
      heightFactor: .24,
      child: Card(
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Create Time:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
