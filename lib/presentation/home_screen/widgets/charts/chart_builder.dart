import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/models/uv_index.dart';
import 'package:weather/utils/chart/lib/chart/chart/line_chart.dart';
import 'package:weather/utils/chart/lib/chart/common/base_layout_config.dart';
import 'package:weather/utils/chart/lib/chart/common/chart_gesture_view.dart';
import 'package:weather/utils/chart/lib/chart/impl/line/fixed_line_canvas_impl.dart';
import 'package:weather/utils/chart/lib/chart/impl/line/fixed_line_layout_impl.dart';
import 'package:weather/utils/chart/lib/chart/model/chart_data_model.dart';

import 'chart_style.dart';

class ChartBuilder extends StatefulWidget {
  final List<dynamic> chartData;

  const ChartBuilder({super.key, required this.chartData});

  @override
  _ChartBuilderState createState() => _ChartBuilderState();
}

class _ChartBuilderState extends State<ChartBuilder> {
  Size? size;
  final margin = const EdgeInsets.symmetric(horizontal: 10);

  /// x轴开始时间
  var startDate = DateTime.fromMillisecondsSinceEpoch(1656302400 * 1000);

  @override
  Widget build(BuildContext context) {
    var pixel = MediaQuery.of(context).size.width;
    var data;
    if (widget.chartData is List<UVIndex>) {
      data = widget.chartData
          .map((e) => ChartDataModel(
                xAxis: e.date,
                yAxis: e.uv,
              ))
          .toList();
    } else {
      data = widget.chartData
          .map((e) => ChartDataModel(
                xAxis: e.date,
                yAxis: e.temp,
              ))
          .toList();
    }
    size ??= Size(pixel, 264);
    return Container(
      width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ChartGestureView<ChartDataModel>(
        initConfig: FixedLayoutConfig(
          data: data,
          axisCount: 25,
          initializePosition: 0,
          startDateTime: startDate,
          size: Size(pixel - margin.horizontal, 264),
          delegate: CommonLineAxisDelegate.copyWith(
            yAxisFormatter: _yAxisFormatter,
            minSelectWidth: 4,
            // domainPointSpacing: 128,
          ),
          popupSpec: CommonPopupSpec.copyWith(
            textFormatter: _textFormatter,
            // popupShouldDraw: _popupShouldShow,
            bubbleShouldDraw: _popupBubbleShouldShow,
          ),
        ),
        builder: (_, newConfig) => CustomPaint(
          size: size!,
          painter: LineChart(
            data: data,
            contentCanvas: FixedLineCanvasImpl(),
            layoutConfig: newConfig as BaseLayoutConfig<ChartDataModel>,
          ),
        ),
      ),
    );
  }

  /// 悬浮框内容
  InlineSpan _textFormatter(ChartDataModel data) {
    var xAxis = DateFormat('MM-dd HH:mm').format(data.xAxis);

    /// 是否为异常数据
    var normalValue = 60;
    bool isException = data.hasBubble;
    Color color = isException ? Colors.red : Colors.black;
    return TextSpan(
      text: '$xAxis\n',
      style: const TextStyle(fontSize: 12, color: Colors.black),
      children: [
        TextSpan(
          text: isException ? '心率异常: 大于' : '心率: ',
          style: TextStyle(fontSize: 12, color: color),
        ),
        TextSpan(
          text: isException ? normalValue.toString() : '${data.yAxis.toInt()}',
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextSpan(
          text: ' 次/分钟',
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }

  /// y轴坐标数据格式化
  String _yAxisFormatter(num data, int index) {
    return data.toInt().toString();
  }

  /// 是否显示气泡
  bool _popupBubbleShouldShow(ChartDataModel data) => data.hasBubble;
}
