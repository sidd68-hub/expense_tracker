import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/app/theme.dart';
import '../../domain/analytics_calculator.dart';

class ExpenseTrendChart extends StatelessWidget {
  const ExpenseTrendChart({super.key, required this.points, required this.isMonthlyBucketed});

  final List<DayTotal> points;
  final bool isMonthlyBucketed;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty || points.every((p) => p.amount.minorUnits == 0)) {
      return const SizedBox.shrink();
    }

    final maxValue = points.map((p) => p.amount.majorUnits).reduce((a, b) => a > b ? a : b);
    // Show at most ~8 labels regardless of how many bars there are.
    final labelStride = (points.length / 8).ceil().clamp(1, points.length);

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxValue * 1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length || index % labelStride != 0) {
                    return const SizedBox.shrink();
                  }
                  final day = points[index].day;
                  final label = isMonthlyBucketed ? DateFormat('MMM').format(day) : DateFormat('d').format(day);
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(label, style: Theme.of(context).textTheme.labelSmall),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (var i = 0; i < points.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: points[i].amount.majorUnits,
                    color: TransactionColors.expense,
                    width: points.length > 20 ? 4 : 10,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
