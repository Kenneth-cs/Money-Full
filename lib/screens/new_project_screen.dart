import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_colors.dart';
import '../models/project.dart';
import '../providers/app_state.dart';
import '../widgets/shared/app_header.dart';

class NewProjectScreen extends ConsumerStatefulWidget {
  const NewProjectScreen({super.key});

  @override
  ConsumerState<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends ConsumerState<NewProjectScreen> {
  final _nameCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedEmoji = '📁';
  final List<String> _emojiOptions = ['📁', '✈️', '🏠', '🎨', '🎒', '🏋️', '💼', '🎵', '📚', '🍜', '🌿', '💡'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _budgetCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _create() {
    if (_nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入项目名称')));
      return;
    }
    ref.read(projectsProvider.notifier).addProject(Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text,
      emoji: _selectedEmoji,
      description: _descCtrl.text,
      budget: double.tryParse(_budgetCtrl.text) ?? 0,
      spent: 0,
      createdAt: DateTime.now(),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: AppHeader(title: '新建项目', showBack: true, onBack: () => Navigator.pop(context)),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emoji 选择
                    const Text('选择图标', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _emojiOptions.map((e) => GestureDetector(
                        onTap: () => setState(() => _selectedEmoji = e),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _selectedEmoji == e ? AppColors.primaryGreen : AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(child: Text(e, style: const TextStyle(fontSize: 26))),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),

                    // 项目名称
                    _InputField(label: '项目名称', hint: '如：新疆之旅、海景房装修', controller: _nameCtrl),
                    const SizedBox(height: 16),

                    // 预算
                    _InputField(label: '预算金额 (¥)', hint: '0.00', controller: _budgetCtrl, keyboardType: TextInputType.number),
                    const SizedBox(height: 16),

                    // 描述
                    _InputField(label: '项目描述 (可选)', hint: '简单描述一下这个项目...', controller: _descCtrl, maxLines: 3),
                    const SizedBox(height: 32),

                    // 创建按钮
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _create,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: AppColors.darkGreen,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('🦫  创建项目', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textHint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
