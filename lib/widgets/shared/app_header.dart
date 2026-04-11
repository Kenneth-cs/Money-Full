import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

/// 顶部导航栏组件
class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final bool showBell;
  final bool showUser; // 遗留参数，保持兼容

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.showBell = false,
    this.showUser = true,
  });

  Widget _buildBubbles() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          // 大泡泡 (右上)
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryGreen, width: 2.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 中泡泡 (左下)
          Positioned(
            bottom: 3,
            left: 2,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryGreen, width: 2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 小泡泡 (中下)
          Positioned(
            bottom: 1,
            right: 7,
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: SizedBox(
        height: 44, // 固定高度方便居中
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 左侧：返回按钮
            if (showBack)
              Positioned(
                left: 0,
                child: GestureDetector(
                  onTap: onBack ?? () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
                  ),
                ),
              ),

            // 标题区域：始终居中，满足“字体加粗放中间”的要求
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBubbles(),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w900, // 加黑加粗
                      color: AppColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // 右侧：通知铃铛
            if (showBell)
              Positioned(
                right: 0,
                child: Container(
                  width: 44, // 稍微加大以匹配圆角矩形的比例
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(14), // 更圆滑的圆角矩形
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: const Center( // 确保图标居中
                    child: Icon(
                      Icons.notifications_none_outlined, // 更像图三中的线框铃铛
                      size: 22, // 适当大小
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
