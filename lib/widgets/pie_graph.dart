import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:band_names/widgets/widgets.dart';

class PieGraph extends StatefulWidget {
  final List<GraphValueData> data;

  const PieGraph({super.key, required this.data});

  @override
  State<PieGraph> createState() => _PieGraphState();
}

class _PieGraphState extends State<PieGraph> {
  int _touchedIndex = 0;
  final percentage = <String, int>{};

  @override
  Widget build(BuildContext context) {
    _calculatePorcentage();

    const textStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: [
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.data
                .map((e) => Indicator(
                      color: e.color,
                      text: e.title,
                      isSquare: true,
                      size: 16,
                      textColor: Colors.black,
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: PieChart(
                  swapAnimationDuration: const Duration(milliseconds: 1200),
                  swapAnimationCurve: Curves.elasticOut,
                  PieChartData(
                    centerSpaceRadius: 10,
                    centerSpaceColor: Colors.black12,
                    sectionsSpace: 6,
                    startDegreeOffset: 270,
                    pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent e, PieTouchResponse? r) {
                      if (r != null && r.touchedSection != null) {
                        setState(() {
                          _touchedIndex = r.touchedSection!.touchedSectionIndex;
                        });
                      }

                      if (e is FlTapUpEvent) {
                        print(
                            'tapped, index: ${r?.touchedSection?.touchedSectionIndex}');
                      }
                    }, mouseCursorResolver:
                            (FlTouchEvent e, PieTouchResponse? r) {
                      if (r != null &&
                          r.touchedSection != null &&
                          r.touchedSection!.touchedSectionIndex != -1) {
                        return SystemMouseCursors.click;
                      }
                      return SystemMouseCursors.basic;
                    }),
                    sections: widget.data.asMap().entries.map((mapEntry) {
                      final index = mapEntry.key;
                      final data = mapEntry.value;
                      final isTouched = _touchedIndex == index;

                      return PieChartSectionData(
                          value: data.value,
                          color: data.color,
                          radius: _touchedIndex == index ? 120 : 100,
                          showTitle: true,
                          titleStyle: isTouched
                              ? textStyle.copyWith(color: Colors.black)
                              : textStyle,
                          title: '${percentage[data.title].toString()}% ',
                          titlePositionPercentageOffset: 0.8,
                          borderSide: isTouched
                              ? const BorderSide(
                                  width: 4, color: Colors.black45)
                              : const BorderSide(
                                  width: 1, color: Colors.black12));
                    }).toList(),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  // Getting percentages
  Map<String, int> _calculatePorcentage() {
    final double percentageByRes;
    final double totalRespondents = widget.data.fold<double>(0, (previous, element) {
      return previous + element.value;
    });

    if (totalRespondents >= 1) {
      percentageByRes = 100 / totalRespondents;
      widget.data.forEach((e) {
        percentage[e.title] = (percentageByRes * e.value).toInt();
      });
    }

    return percentage;
  }
}

class GraphValueData {
  final double value;
  final Color color;
  final String title;

  GraphValueData({
    double? value,
    Color? color,
    String? title,
  })  : value = value ?? 10,
        color = color ?? Color(Random().nextInt(0xffffffff)),
        title = title ?? (value == null ? '' : value.toString());
}
