import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_colors.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../providers/app_state.dart';
import '../core/utils.dart';

class AddRecordScreen extends ConsumerStatefulWidget {
  const AddRecordScreen({super.key});

  @override
  ConsumerState<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends ConsumerState<AddRecordScreen> {
  TransactionType _type = TransactionType.expense;
  String _amountStr = '0';
  String? _selectedCategoryId;
  String? _selectedProjectId;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleKey(String key) {
    HapticFeedback.lightImpact();
    setState(() {
      if (key == 'del') {
        _amountStr = _amountStr.length > 1 ? _amountStr.substring(0, _amountStr.length - 1) : '0';
      } else if (key == '.') {
        if (!_amountStr.contains('.')) _amountStr += '.';
      } else {
        _amountStr = _amountStr == '0' ? key : _amountStr + key;
      }
    });
  }

  void _handleDone() {
    final amount = double.tryParse(_amountStr) ?? 0;
    if (amount <= 0 || _selectedCategoryId == null || _selectedProjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请完善记账信息')),
      );
      return;
    }
    ref.read(transactionsProvider.notifier).addTransaction(
      Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        projectId: _selectedProjectId!,
        categoryId: _selectedCategoryId!,
        amount: amount,
        type: _type,
        note: _noteController.text.isEmpty ? '无备注' : _noteController.text,
        date: DateTime.now(),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final categories = ref.watch(categoriesProvider);
    final activeProjects = projects.where((p) => !p.isArchived).toList();
    if (_selectedProjectId == null && activeProjects.isNotEmpty) {
      _selectedProjectId = activeProjects.first.id;
    }

    final amount = double.tryParse(_amountStr) ?? 0;
    final isLargeAmount = amount >= 3000;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 顶部操作栏
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 26, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('记一笔', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  TextButton(
                    onPressed: _handleDone,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF546073),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('完成', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 支出/收入切换
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        _TypeToggleBtn(
                          label: '支出',
                          isActive: _type == TransactionType.expense,
                          onTap: () => setState(() => _type = TransactionType.expense),
                        ),
                        _TypeToggleBtn(
                          label: '收入',
                          isActive: _type == TransactionType.income,
                          onTap: () => setState(() => _type = TransactionType.income),
                        ),
                      ],
                    ),
                  ),

                  // 金额输入区（柠檬黄卡片）
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                    decoration: BoxDecoration(
                      color: AppColors.sunnyYellow,
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Column(
                      children: [
                        const Text('输入金额', style: TextStyle(color: Color(0x99484A07), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text('¥', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF1C1D00))),
                            const SizedBox(width: 4),
                            Text(
                              _amountStr,
                              style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Color(0xFF1C1D00), letterSpacing: -2),
                            ),
                            // 光标
                            const _Cursor(),
                          ],
                        ),
                        if (isLargeAmount) ...[
                          const SizedBox(height: 8),
                          const Text('哇哦，今天是个大动作呢 🍊💦', style: TextStyle(fontSize: 12, color: Color(0xFF795841), fontWeight: FontWeight.w600)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 分类选择
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('分类', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        TextButton(onPressed: () {}, child: const Text('更多', style: TextStyle(fontSize: 12, color: AppColors.textHint))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, i) {
                      final cat = categories[i];
                      final isSelected = _selectedCategoryId == cat.id;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedCategoryId = cat.id);
                        },
                        child: _CategoryItem(category: cat, isSelected: isSelected),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // 归属项目选择
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.home_outlined, size: 20, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedProjectId,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint),
                              hint: const Text('选择归属项目'),
                              selectedItemBuilder: (context) {
                                return activeProjects.map((p) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('归属项目', style: TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text('${p.name} ${p.emoji}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                  ],
                                )).toList();
                              },
                              items: activeProjects.map((p) => DropdownMenuItem(
                                value: p.id,
                                child: Row(
                                  children: [
                                    Text(p.emoji, style: const TextStyle(fontSize: 20)),
                                    const SizedBox(width: 10),
                                    Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                  ],
                                ),
                              )).toList(),
                              onChanged: (v) => setState(() => _selectedProjectId = v),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 备注输入
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText: '添加备注...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
                        prefixIcon: Icon(Icons.edit_note_rounded, color: AppColors.textHint),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 自定义数字键盘
          _CustomNumpad(onKey: _handleKey, onDone: _handleDone),
        ],
      ),
    );
  }
}

// ===== 类型切换按钮 =====
class _TypeToggleBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TypeToggleBtn({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.cardWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)] : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== 分类选项 =====
class _CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;

  const _CategoryItem({required this.category, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: category.color,
            shape: BoxShape.circle,
            border: isSelected ? Border.all(color: AppColors.textPrimary, width: 2) : null,
          ),
          child: Icon(category.icon, size: 26, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Text(category.name, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, color: isSelected ? AppColors.textPrimary : AppColors.textSecondary)),
      ],
    );
  }
}

// ===== 光标动画 =====
class _Cursor extends StatefulWidget {
  const _Cursor();

  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 600), vsync: this)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _ctrl.value,
        child: Container(
          width: 3,
          height: 44,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1D00),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

// ===== 自定义数字键盘 =====
class _CustomNumpad extends StatelessWidget {
  final void Function(String) onKey;
  final VoidCallback onDone;

  const _CustomNumpad({required this.onKey, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: [BoxShadow(color: Color(0x10000000), blurRadius: 30, offset: Offset(0, -10))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _NumRow(keys: ['1', '2', '3'], special: _NumpadKey(label: '📅', onTap: () {}), onKey: onKey),
            const SizedBox(height: 12),
            _NumRow(keys: ['4', '5', '6'], special: _NumpadKey(label: '+', onTap: () => onKey('+')), onKey: onKey),
            const SizedBox(height: 12),
            _NumRow(keys: ['7', '8', '9'], special: _NumpadKey(label: '-', onTap: () => onKey('-')), onKey: onKey),
            const SizedBox(height: 12),
            Row(
              children: [
                _NumpadKey(label: '.', onTap: () => onKey('.')),
                const SizedBox(width: 12),
                _NumpadKey(label: '0', onTap: () => onKey('0')),
                const SizedBox(width: 12),
                _NumpadKey(icon: Icons.backspace_outlined, onTap: () => onKey('del')),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onDone,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Text('完成', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.darkGreen)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NumRow extends StatelessWidget {
  final List<String> keys;
  final Widget special;
  final void Function(String) onKey;

  const _NumRow({required this.keys, required this.special, required this.onKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...keys.map((k) => Expanded(child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _NumpadKey(label: k, onTap: () => onKey(k)),
        ))),
        special,
      ],
    );
  }
}

class _NumpadKey extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  const _NumpadKey({this.label, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surfaceGray,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, size: 22, color: AppColors.textPrimary)
                : Text(label!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ),
        ),
      ),
    );
  }
}
