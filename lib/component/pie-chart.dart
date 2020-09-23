/// Simple pie chart with outside labels example.
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final Function legendLabelFn;
  PieChart(this.seriesList, {this.legendLabelFn, this.animate = true});

  getBehaviors() {
    return [
      new charts.DatumLegend(
        // Positions for "start" and "end" will be left and right respectively
        // for widgets with a build context that has directionality ltr.
        // For rtl, "start" and "end" will be right and left respectively.
        // Since this example has directionality of ltr, the legend is
        // positioned on the right side of the chart.
        position: charts.BehaviorPosition.bottom,
        // By default, if the position of the chart is on the left or right of
        // the chart, [horizontalFirst] is set to false. This means that the
        // legend entries will grow as new rows first instead of a new column.
        horizontalFirst: false,
        // This defines the padding around each legend entry.
        cellPadding: new EdgeInsets.only(right: 4.0, bottom: 5.0),
        // Set [showMeasures] to true to display measures in series legend.
        showMeasures: true,
        // Configure the measure value to be shown by default in the legend.
        legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
        // Optionally provide a measure formatter to format the measure value.
        // If none is specified the value is formatted as a decimal.
        measureFormatter: (num value) {
          if (legendLabelFn != null) {
            return legendLabelFn(value);
          }
          return value == null ? '-' : '${value}';
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      // Add an [ArcLabelDecorator] configured to render labels outside of the
      // arc with a leader line.
      //
      // Text style for inside / outside can be controlled independently by
      // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
      //
      // Example configuring different styles for inside/outside:
      //       new charts.ArcLabelDecorator(
      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 500,
        arcRendererDecorators: [new charts.ArcLabelDecorator()],
      ),
      behaviors: getBehaviors(),
      // defaultRenderer: new charts.ArcRendererConfig(
      //   arcRendererDecorators: [
      //     new charts.ArcLabelDecorator(
      //         labelPosition: charts.ArcLabelPosition.outside)
      //   ],
      // ),
    );
  }
}
