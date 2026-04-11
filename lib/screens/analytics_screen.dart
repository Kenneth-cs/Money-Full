import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/app_colors.dart';
import '../widgets/shared/app_header.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _trendTab = 1; // 0=日 1=月 2=年

  // 模拟图表数据（与React原型一致）
  final List<_PieItem> _pieData = const [
    _PieItem('软件开发', 42, AppColors.primaryGreen),
    _PieItem('市场营销', 42, AppColors.peach),
    _PieItem('办公租赁', 10, Color(0xFFD4DB86)),
    _PieItem('其他杂项', 6, Color(0xFFF2F2F2)),
  ];

  final List<double> _lineValues = const [30, 35, 45, 55, 65, 70];
  final List<String> _lineLabels = const ['5月', '6月', '7月', '8月', '9月', '10月'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
        child: Column(
          children: [
            const AppHeader(title: '财务统计', showBell: true, showUser: false),

            // 日期选择器
            Column(
              children: [
                const Text('本月财务概览与分析报告', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: AppColors.surfaceGray, borderRadius: BorderRadius.circular(30)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('2023年10月', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      SizedBox(width: 6),
                      Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 环形图卡片
            _DonutChartCard(pieData: _pieData),
            const SizedBox(height: 16),

            // 折线图卡片
            _LineChartCard(values: _lineValues, labels: _lineLabels, trendTab: _trendTab, onTabChange: (i) => setState(() => _trendTab = i)),
            const SizedBox(height: 16),

            // 预算健康度
            const _BudgetHealthCard(),
            const SizedBox(height: 16),

            // 智能洞察
            const _InsightsSection(),
          ],
        ),
      ),
    );
  }
}

// ===== 环形图卡片 =====
class _DonutChartCard extends StatelessWidget {
  final List<_PieItem> pieData;

  const _DonutChartCard({required this.pieData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16)],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('项目占比', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: pieData.map((item) => PieChartSectionData(
                      color: item.color,
                      value: item.value.toDouble(),
                      title: '',
                      radius: 35, // 增加圆环厚度
                    )).toList(),
                    centerSpaceRadius: 65, // 减小内圆半径以匹配图4
                    sectionsSpace: 3,
                  ),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('¥12,840', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: -0.5)),
                    SizedBox(height: 2),
                    Text('总支出', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...pieData.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: item.color, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Expanded(child: Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                Text('${item.value}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ===== 折线图卡片 =====
class _LineChartCard extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final int trendTab;
  final void Function(int) onTabChange;

  const _LineChartCard({required this.values, required this.labels, required this.trendTab, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16)],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('项目趋势', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: ['日', '月', '年'].asMap().entries.map((e) => GestureDetector(
                    onTap: () => onTabChange(e.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: trendTab == e.key ? AppColors.cardWhite : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(e.value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: trendTab == e.key ? AppColors.darkGreen : AppColors.textSecondary)),
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: values.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                    isCurved: true,
                    color: AppColors.darkGreen,
                    barWidth: 3,
                    dotData: FlDotData(
                      getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.darkGreen,
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primaryGreen.withOpacity(0.3), AppColors.primaryGreen.withOpacity(0)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels.map((l) => Text(l, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textHint))).toList(),
          ),
        ],
      ),
    );
  }
}

// ===== 预算健康度 =====
class _BudgetHealthCard extends StatelessWidget {
  const _BudgetHealthCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(36),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('预算健康度', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Text('总预算: ¥25,000', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
            ],
          ),
          const SizedBox(height: 20),
          const _BudgetBar(title: '办公租赁', amount: '¥4,500 / ¥5,000', progress: 0.9, color: AppColors.primaryGreen),
          const SizedBox(height: 16),
          const _BudgetBar(title: '市场营销', amount: '¥6,200 / ¥5,500 超支!', progress: 1.0, color: AppColors.dangerRed, amountColor: AppColors.dangerRed),
          const SizedBox(height: 16),
          const _BudgetBar(title: '员工薪酬', amount: '¥8,000 / ¥10,000', progress: 0.8, color: AppColors.yellowGreen),
        ],
      ),
    );
  }
}

class _BudgetBar extends StatelessWidget {
  final String title;
  final String amount;
  final double progress;
  final Color color;
  final Color amountColor;

  const _BudgetBar({required this.title, required this.amount, required this.progress, required this.color, this.amountColor = AppColors.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(amount, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: amountColor)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            backgroundColor: const Color(0xFFE2E2E2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 14,
          ),
        ),
      ],
    );
  }
}

// ===== 智能洞察 =====
class _InsightsSection extends StatelessWidget {
  const _InsightsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('豚言豚语 🦫', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        // 节省方案卡片
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFFB1EFD8), borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 12),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.lightbulb_outline_rounded, size: 18, color: Color(0xFF002118)),
                SizedBox(width: 6),
                Text('节省方案', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF002118))),
              ]),
              SizedBox(height: 8),
              Text('"市场营销"已连续三个月超预算。没关系，深呼吸，下个月我们再慢慢调整回来就好啦~', style: TextStyle(fontSize: 13, color: Color(0xFF002118), height: 1.5)),
            ],
          ),
        ),
        // 健康提醒卡片
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFFFFDCC5), borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 12),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.trending_up_rounded, size: 18, color: Color(0xFF2C1605)),
                SizedBox(width: 6),
                Text('健康提醒', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF2C1605))),
              ]),
              SizedBox(height: 8),
              Text('干得漂亮，现在的财务状态就像泡在温泉里一样舒服 ♨️。本月结余相比上月增长了12%！', style: TextStyle(fontSize: 13, color: Color(0xFF2C1605), height: 1.5)),
            ],
          ),
        ),
        // 深度报告卡片
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.darkGreen, borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('优化财务结构，\n让增长更自然。', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, height: 1.3)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(30)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('立即生成深度报告', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.darkGreen)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.darkGreen),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PieItem {
  final String name;
  final int value;
  final Color color;

  const _PieItem(this.name, this.value, this.color);
}
