import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartGenerator {
  Widget generatePieChart(Map<String, int> statusCounts) {
    List<PieChartSectionData> sections = statusCounts.entries.map((entry) {
      Color sectionColor = Colors.grey; // Default color for other statuses

      // Assign color based on status
      if (entry.key == 'Active') {
        sectionColor = Colors.green;
      } else if (entry.key == 'Inactive') {
        sectionColor = Colors.yellow;
      } 

      return PieChartSectionData(
        value: entry.value.toDouble(),
        color: sectionColor,
        title: '${entry.key}: ${entry.value}',
        radius: 50,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        // Other configurations for the pie chart
      ),
    );
  }


Widget generatePieChart2(Map<String, int> statusCounts) {
    List<PieChartSectionData> sections = statusCounts.entries.map((entry) {
      Color sectionColor = Colors.grey; // Default color for other statuses

      // Assign color based on status
      if (entry.key == 'Approved') {
        sectionColor = Colors.green;
      } else if (entry.key == 'Pending') {
        sectionColor = Colors.yellow;
      } else if (entry.key == 'Rejected') {
        sectionColor = Colors.red;}

      return PieChartSectionData(
        value: entry.value.toDouble(),
        color: sectionColor,
        title: '${entry.key}: ${entry.value}',
        radius: 50,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        // Other configurations for the pie chart
      ),
    );
  }



}
