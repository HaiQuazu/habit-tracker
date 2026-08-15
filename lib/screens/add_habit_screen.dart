import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/habit_model.dart';
import '../providers/habit_provider.dart';
import '../themes/app_colors.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  final Habit? habit;

  const AddHabitScreen({super.key, this.habit});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String selectedCategory = 'Health';
  String selectedIcon = 'check';

  int selectedColor = 0xFF6C5CE7;

  final List<int> selectedDays = [1, 2, 3, 4, 5, 6, 7];

  final List<String> categories = [
    'Health',
    'Fitness',
    'Study',
    'Work',
    'Personal',
  ];

  final List<Map<String, dynamic>> icons = [
    {'name': 'check', 'icon': Icons.check_rounded},
    {'name': 'water', 'icon': Icons.water_drop_rounded},
    {'name': 'book', 'icon': Icons.menu_book_rounded},
    {'name': 'fitness', 'icon': Icons.fitness_center_rounded},
    {'name': 'sleep', 'icon': Icons.bedtime_rounded},
    {'name': 'music', 'icon': Icons.music_note_rounded},
  ];

  final List<int> colors = [
    0xFF6C5CE7,
    0xFFFF8A00,
    0xFF22C55E,
    0xFF3B82F6,
    0xFFEC4899,
    0xFF14B8A6,
  ];

  @override
  void initState() {
    super.initState();

    final habit = widget.habit;

    if (habit != null) {
      _nameController.text = habit.name;
      _descriptionController.text = habit.description;

      selectedCategory = habit.category;
      selectedIcon = habit.icon;
      selectedColor = habit.color;

      selectedDays
        ..clear()
        ..addAll(habit.repeatDays);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day.')),
      );

      return;
    }

    final oldHabit = widget.habit;

    final habit = Habit(
      id: oldHabit?.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: selectedCategory,
      icon: selectedIcon,
      color: selectedColor,
      repeatDays: List.from(selectedDays),
      isCompleted: oldHabit?.isCompleted ?? false,
      currentStreak: oldHabit?.currentStreak ?? 0,
      createdAt: oldHabit?.createdAt ?? DateTime.now(),
    );

    if (oldHabit == null) {
      await ref.read(habitProvider.notifier).addHabit(habit);
    } else {
      await ref.read(habitProvider.notifier).updateHabit(habit);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          widget.habit == null ? 'Add Habit' : 'Edit Habit',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Habit Information'),

              const SizedBox(height: 12),

              _buildTextField(
                controller: _nameController,
                label: 'Habit Name',
                hint: 'e.g. Drink Water',
                icon: Icons.edit_rounded,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a habit name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 14),

              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'What do you want to achieve?',
                icon: Icons.notes_rounded,
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              _sectionTitle('Category'),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final selected = selectedCategory == category;

                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.purple.withValues(alpha: 0.15),
                    labelStyle: TextStyle(
                      color: selected
                          ? AppColors.purple
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: selected ? AppColors.purple : AppColors.border,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              _sectionTitle('Icon'),

              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: icons.map((item) {
                  final selected = selectedIcon == item['name'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = item['name'];
                      });
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: selected
                            ? Color(selectedColor)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? Color(selectedColor)
                              : AppColors.border,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              _sectionTitle('Color'),

              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                children: colors.map((color) {
                  final selected = selectedColor == color;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(color: AppColors.textPrimary, width: 3)
                            : null,
                      ),
                      child: selected
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              _sectionTitle('Repeat'),

              const SizedBox(height: 12),

              _buildDaysSelector(),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saveHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Save Habit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.purple, width: 2),
        ),
      ),
    );
  }

  Widget _buildDaysSelector() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final day = index + 1;
        final selected = selectedDays.contains(day);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (selected) {
                selectedDays.remove(day);
              } else {
                selectedDays.add(day);
              }
            });
          },
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.purple : AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.purple : AppColors.border,
              ),
            ),
            child: Text(
              days[index],
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }),
    );
  }
}
