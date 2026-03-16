import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:student_app/admin_app/admin_header.dart';
import 'package:student_app/staff_app/controllers/pro_dashboard_controller.dart';
import 'package:student_app/staff_app/utils/iconify_icons.dart';
import 'package:student_app/staff_app/widgets/skeleton.dart';

class AdminProAdmissionPage extends GetView<ProDashboardController> {
  const AdminProAdmissionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.dashboardData.value == null) {
          return Column(
            children: [
              const AdminHeader(title: "Pro Admission"),
              Expanded(
                child: Center(
                  child: SkeletonLoader(),
                ),
              ),
            ],
          );
        }

        if (controller.dashboardData.value == null) {
          return Column(
            children: [
              const AdminHeader(title: "Pro Admission"),
              Expanded(
                child: Center(
                  child: Text(
                    controller.errorMessage.value.isNotEmpty
                        ? controller.errorMessage.value
                        : "No data available",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          );
        }

        final data = controller.dashboardData.value!;

        return Column(
          children: [
            const AdminHeader(title: "Pro Admission"),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Grid
                    _buildStatsGrid(data),
                    const SizedBox(height: 30),

                    // Pro Admissions Analysis
                    _buildSectionTitle("Pro Admissions Analysis"),
                    const SizedBox(height: 10),
                    _buildLegend([
                      {
                        "label": "Total Admissions",
                        "color": const Color(0xFF26A69A),
                      },
                      {
                        "label": "Remaining Targets",
                        "color": const Color(0xFF5C6BC0),
                      },
                    ]),
                    const SizedBox(height: 20),
                    _buildStackedBarChart(),
                    const SizedBox(height: 40),

                    // Pro Year on Year Analytics
                    _buildSectionTitle("Pro Year on Year Analytics"),
                    const SizedBox(height: 10),
                    if (controller.yoyData.value != null &&
                        controller.yoyData.value!.sessions.length >= 2)
                      _buildLegend([
                        {
                          "label":
                              "${controller.yoyData.value!.sessions[0]} Admissions",
                          "color": const Color(0xFF2196F3),
                        },
                        {
                          "label":
                              "${controller.yoyData.value!.sessions[1]} Admissions",
                          "color": const Color(0xFF26A69A),
                        },
                      ]),
                    const SizedBox(height: 20),
                    _buildYearlyBarChart(),
                    const SizedBox(height: 40),

                    // Admissions Month on Month
                    _buildSectionTitle(
                      "Admissions Month on Month\n(Session Wise)",
                    ),
                    const SizedBox(height: 10),
                    if (controller.momData.value != null)
                      _buildLegend([
                        {
                          "label": controller.momData.value!.data.isNotEmpty
                              ? controller.momData.value!.data[0].sessionName
                              : "Session 1",
                          "color": const Color(0xFF4FC3F7),
                        },
                        {
                          "label": controller.momData.value!.data.length > 1
                              ? controller.momData.value!.data[1].sessionName
                              : "Session 2",
                          "color": const Color(0xFF78909C),
                        },
                      ]),
                    const SizedBox(height: 20),
                    _buildMonthlyStackedBarChart(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFFB71C1C),
      ),
    );
  }

  Widget _buildLegend(List<Map<String, dynamic>> items) {
    return Wrap(
      spacing: 20,
      runSpacing: 8,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item['label'] as String,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatsGrid(dynamic data) {
    return Column(
      children: [
        _buildStatRow(
          "Total",
          data.totalAdmissions.toString(),
          IconifyIcons.humbleIconsUsers,
          [const Color(0xFF3949AB), const Color(0xFF1A237E)],
          "Today",
          data.today.toString(),
          Icons.calendar_today_outlined,
          [const Color(0xFFFB8C00), const Color(0xFFEF6C00)],
        ),
        const SizedBox(height: 15),
        _buildStatRow(
          "Yesterday",
          data.yesterday.toString(),
          Icons.calendar_today_outlined,
          [const Color(0xFF26A69A), const Color(0xFF00695C)],
          "This Week",
          data.thisWeek.toString(),
          Icons.calendar_month_outlined,
          [const Color(0xFF7CB342), const Color(0xFF558B2F)],
        ),
        const SizedBox(height: 15),
        _buildStatRow(
          "This Month",
          data.thisMonth.toString(),
          Icons.calendar_view_month_outlined,
          [const Color(0xFFE53935), const Color(0xFFB71C1C)],
          "Last Month",
          data.lastMonth.toString(),
          Icons.calendar_today_outlined,
          [const Color(0xFFEC407A), const Color(0xFFAD1457)],
        ),
        const SizedBox(height: 15),
        _buildStatRow(
          "Boys",
          data.boys.toString(),
          Icons.face,
          [const Color(0xFFFFA726), const Color(0xFFF57C00)],
          "Girls",
          data.girls.toString(),
          Icons.face_retouching_natural,
          [const Color(0xFF26A69A), const Color(0xFF00796B)],
        ),
        const SizedBox(height: 15),
        _buildStatRow(
          "Hostel",
          data.hostel.toString(),
          IconifyIcons.clarityBuildingLine,
          [const Color(0xFFF06292), const Color(0xFFD81B60)],
          "Day",
          data.day.toString(),
          IconifyIcons.hugeIconsBus03,
          [const Color(0xFF29B6F6), const Color(0xFF039BE5)],
        ),
        const SizedBox(height: 15),
        _buildStatRow(
          "Target",
          data.target.toString(),
          Icons.track_changes,
          [const Color(0xFF5C6BC0), const Color(0xFF3949AB)],
          "Paid",
          data.paid.toString(),
          Icons.monetization_on_outlined,
          [const Color(0xFFFFB300), const Color(0xFFF57C00)],
        ),
        const SizedBox(height: 15),
        _buildStatRow(
          "Not Paid",
          data.notPaid.toString(),
          Icons.account_balance_wallet_outlined,
          [const Color(0xFF26A69A), const Color(0xFF00897B)],
          "Local",
          data.local.toString(),
          Icons.location_on_outlined,
          [const Color(0xFF29B6F6), const Color(0xFF0288D1)],
        ),
        const SizedBox(height: 15),
        _buildStatRow(
          "Non-Local",
          data.nonLocal.toString(),
          Icons.directions_bus_outlined,
          [const Color(0xFFEC407A), const Color(0xFFC2185B)],
          null,
          null,
          null,
          null,
        ),
      ],
    );
  }

  Widget _buildStatRow(
    String t1,
    String v1,
    dynamic i1,
    List<Color> c1,
    String? t2,
    String? v2,
    dynamic i2,
    List<Color>? c2,
  ) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(t1, v1, i1, c1)),
        const SizedBox(width: 15),
        Expanded(
          child: t2 != null
              ? _buildStatCard(t2, v2!, i2, c2!)
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    dynamic icon,
    List<Color> colors,
  ) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: icon is String
                      ? Iconify(icon, color: Colors.white, size: 28)
                      : Icon(icon as IconData, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedBarChart() {
    final chartData = controller.proAdmissionsChartData.value?.data ?? [];
    if (chartData.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text("No data available")),
      );
    }

    double maxTarget = 0;
    for (var item in chartData) {
      if (item.target > maxTarget) maxTarget = item.target.toDouble();
      if (item.totalAdmissions > maxTarget) {
        maxTarget = item.totalAdmissions.toDouble();
      }
    }
    double maxY = (maxTarget * 1.2).ceilToDouble();
    if (maxY == 0) maxY = 100;

    return SizedBox(
      height: 350,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width:
              chartData.length * 80.0 < MediaQuery.of(Get.context!).size.width
              ? MediaQuery.of(Get.context!).size.width - 32
              : chartData.length * 80.0,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.blueGrey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${chartData[groupIndex].proName}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text:
                              'Admissions: ${chartData[groupIndex].totalAdmissions}\n',
                          style: const TextStyle(
                            color: Color(0xFF26A69A),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: 'Target: ${chartData[groupIndex].target}',
                          style: const TextStyle(
                            color: Color(0xFF5C6BC0),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 80,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < chartData.length) {
                        return SideTitleWidget(
                          meta: meta,
                          space: 10,
                          child: Transform.rotate(
                            angle: -0.6,
                            child: SizedBox(
                              width: 80,
                              child: Text(
                                chartData[value.toInt()].proName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1,
                  ),
                  left: const BorderSide(color: Colors.transparent),
                  right: const BorderSide(color: Colors.transparent),
                  top: const BorderSide(color: Colors.transparent),
                ),
              ),
              barGroups: List.generate(chartData.length, (index) {
                final item = chartData[index];
                final total = item.totalAdmissions.toDouble();
                final target = item.target.toDouble();

                final remainingTarget = (target > total)
                    ? (target - total)
                    : 0.0;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: total + remainingTarget,
                      width: 20,
                      color: Colors.transparent,
                      rodStackItems: [
                        BarChartRodStackItem(0, total, const Color(0xFF26A69A)),
                        if (remainingTarget > 0)
                          BarChartRodStackItem(
                            total,
                            total + remainingTarget,
                            const Color(0xFF5C6BC0),
                          ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYearlyBarChart() {
    final yoyData = controller.yoyData.value;
    if (yoyData == null || yoyData.data.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text("No data available")),
      );
    }

    final chartData = yoyData.data;

    double maxAdmissions = 0;
    for (var pro in chartData) {
      for (var history in pro.history) {
        if (history.admissions > maxAdmissions) {
          maxAdmissions = history.admissions.toDouble();
        }
      }
    }
    double maxY = (maxAdmissions * 1.2).ceilToDouble();
    if (maxY == 0) maxY = 100;

    return SizedBox(
      height: 350,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width:
              chartData.length * 100.0 < MediaQuery.of(Get.context!).size.width
              ? MediaQuery.of(Get.context!).size.width - 32
              : chartData.length * 100.0,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.blueGrey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final history = chartData[groupIndex].history;
                    final session = history.length > rodIndex
                        ? history[rodIndex].sessionName
                        : "";
                    final count = history.length > rodIndex
                        ? history[rodIndex].admissions
                        : 0;
                    return BarTooltipItem(
                      '${chartData[groupIndex].proName}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '$session: $count',
                          style: TextStyle(
                            color: rodIndex == 0
                                ? const Color(0xFF2196F3)
                                : const Color(0xFF26A69A),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 80,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < chartData.length) {
                        return SideTitleWidget(
                          meta: meta,
                          space: 10,
                          child: Transform.rotate(
                            angle: -0.6,
                            child: SizedBox(
                              width: 80,
                              child: Text(
                                chartData[value.toInt()].proName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1,
                  ),
                  left: const BorderSide(color: Colors.transparent),
                  right: const BorderSide(color: Colors.transparent),
                  top: const BorderSide(color: Colors.transparent),
                ),
              ),
              barGroups: List.generate(chartData.length, (index) {
                final item = chartData[index];
                final historyData = item.history;

                double val1 = historyData.isNotEmpty
                    ? historyData[0].admissions.toDouble()
                    : 0.0;
                double val2 = historyData.length > 1
                    ? historyData[1].admissions.toDouble()
                    : 0.0;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: val1 + val2,
                      width: 20,
                      color: Colors.transparent,
                      rodStackItems: [
                        BarChartRodStackItem(0, val1, const Color(0xFF2196F3)),
                        if (val2 > 0)
                          BarChartRodStackItem(
                            val1,
                            val1 + val2,
                            const Color(0xFF26A69A),
                          ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyStackedBarChart() {
    final momData = controller.momData.value;
    if (momData == null || momData.data.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text("No data available")),
      );
    }

    final months = momData.months;
    final sessions = momData.data;

    double maxCount = 0;
    for (int m = 0; m < months.length; m++) {
      double columnTotal = 0;
      for (var session in sessions) {
        if (m < session.months.length) {
          columnTotal += session.months[m].count.toDouble();
        }
      }
      if (columnTotal > maxCount) maxCount = columnTotal;
    }
    double maxY = (maxCount * 1.2).ceilToDouble();
    if (maxY == 0) maxY = 10;

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String month = months[groupIndex];
                List<TextSpan> lines = [];
                double total = 0;
                for (int s = 0; s < sessions.length; s++) {
                  if (groupIndex < sessions[s].months.length) {
                    double val = sessions[s].months[groupIndex].count
                        .toDouble();
                    if (val > 0) {
                      lines.add(
                        TextSpan(
                          text: '${sessions[s].sessionName}: ${val.toInt()}\n',
                          style: TextStyle(
                            color: s == 0
                                ? const Color(0xFF4FC3F7)
                                : const Color(0xFF78909C),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      );
                      total += val;
                    }
                  }
                }
                return BarTooltipItem(
                  '$month\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    ...lines,
                    TextSpan(
                      text: 'Total: ${total.toInt()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < months.length) {
                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Text(
                        months[value.toInt()],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
              left: const BorderSide(color: Colors.transparent),
              right: const BorderSide(color: Colors.transparent),
              top: const BorderSide(color: Colors.transparent),
            ),
          ),
          barGroups: List.generate(months.length, (index) {
            double currentY = 0;
            List<BarChartRodStackItem> stackItems = [];
            final colors = [const Color(0xFF4FC3F7), const Color(0xFF78909C)];

            for (int s = 0; s < sessions.length; s++) {
              if (index < sessions[s].months.length) {
                double val = sessions[s].months[index].count.toDouble();
                if (val > 0) {
                  stackItems.add(
                    BarChartRodStackItem(
                      currentY,
                      currentY + val,
                      colors[s % colors.length],
                    ),
                  );
                  currentY += val;
                }
              }
            }

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: currentY,
                  width: 15,
                  color: Colors.transparent,
                  rodStackItems: stackItems,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
