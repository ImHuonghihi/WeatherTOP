import 'package:flutter/material.dart';
import 'package:weather/utils/chart/lib/chart/common/popup_spec.dart';
import 'package:weather/utils/chart/lib/chart/model/chart_data_bar.dart';
import 'package:weather/utils/chart/lib/chart/model/chart_data_model.dart';

import 'package:weather/utils/chart/lib/chart/common/axis_delegate.dart';

const CommonLineAxisDelegate = AxisDelegate<ChartDataModel>(
  showXAxisLine: true,
  showYAxisLine: true,
  showVerticalHintAxisLine: true,
  showHorizontalHintAxisLine: true,
  labelStyle: LabelStyle(
    style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
  ),
  axisLineStyle: LineStyle(color: Color(0xFFE5E5E5), dashPattern: [4]),
  hintLineStyle: LineStyle(color: Color(0xFFE5E5E5), dashPattern: [4]),
  lineStyle: LineStyle(
    strokeWidth: 2,
    color: Colors.deepOrangeAccent,
  ),
);

/// 悬浮框基本样式
const CommonPopupSpec = PopupSpec<ChartDataModel>(
  lineStyle: LineStyle(
    color: Color(0xFFEE2828),
    strokeWidth: 1,
    dashPattern: [3],
  ),
  radius: 8,
  fill: Colors.white,
  stroke: Color(0x5CD2BFBF),
  strokeWidthPx: 2,
  bubbleSpec: BubbleSpec(
    fill: Color(0xFFEE2828),
    strokeWidthPx: 4,
    stroke: Color(0xFFFFD4D4),
  ),
);

/// bar 坐标轴基本样式
const CommonBarAxisDelegate = AxisDelegate<ChartDataBar>(
  showXAxisLine: true,
  showYAxisLine: true,
  showVerticalHintAxisLine: true,
  showHorizontalHintAxisLine: true,
  labelStyle: LabelStyle(
    style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
  ),
  axisLineStyle: LineStyle(color: Color(0xFFE5E5E5), dashPattern: [4]),
  hintLineStyle: LineStyle(color: Color(0xFFE5E5E5), dashPattern: [4]),
  domainPointSpacing: 56,
  hintLineNum: 5,
  lineStyle: LineStyle(
    strokeWidth: 2,
    color: Colors.deepOrangeAccent,
  ),
  barStyle: BarStyle(),
);

/// 悬浮框基本样式
const CommonBarPopupSpec = PopupSpec<ChartDataBar>(
  lineStyle: LineStyle(
    color: Color(0xFFEE2828),
    strokeWidth: 1,
    dashPattern: [3],
  ),
  radius: 8,
  fill: Colors.white,
  stroke: Color(0x5CD2BFBF),
  strokeWidthPx: 2,
  bubbleSpec: BubbleSpec(
    fill: Color(0xFFEE2828),
    strokeWidthPx: 4,
    stroke: Color(0xFFFFD4D4),
  ),
);
