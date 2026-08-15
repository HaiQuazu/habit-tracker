import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/habit_model.dart';
import '../providers/habit_provider.dart';
import '../themes/app_colors.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String selectedCategory = 'Health';
  String selectedIcon = 'check';

  final List<int> selectedDays = [];

  final List<String> categories = [
    'Health',
    'Fitness',
    'Study',
    'Work',
    'Personal',
  ];

  final List<Map<String, dynamic>> icons = [
    {
      'name': 'check',
      'icon': Icons.check_circle_outline_rounded,
    },
    {
      'name': 'water',
      'icon': Icons.water_drop_rounded,
    },
    {
      'name': 'book',
      'icon': Icons.menu_book_rounded,
    },
    {
      'name': 'fitness',
      'icon': Icons.fitness_center_rounded,
    },
    {
      'name': 'sleep',
      'icon': Icons.bedtime_rounded,
    },
    {
      'name': 'work',
      'icon': Icons.work_outline_rounded,
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void saveHabit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day.'),
        ),
      );
      return;
    }

    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: selectedCategory,
      icon: selectedIcon,
      color: AppColors.purple.value,
      repeatDays: selectedDays,
      createdAt: DateTime.now(),
    );

    ref.read(habitProvider.notifier).addHabit(habit);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Add Habit',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Habit name
              _label('Habit name'),

              const SizedBox(height: 8),

              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  hint: 'e.g. Drink Water',
                  icon: Icons.edit_rounded,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a habit name.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Description
              _label('Description'),

              const SizedBox(height: 8),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: _inputDecoration(
                  hint: 'What do you want to achieve?',
                  icon: Icons.notes_rounded,
                ),
              ),

              const SizedBox(height: 20),

              // Category
              _label('Category'),

              const SizedBox(height: 10),

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
                    selectedColor: AppColors.purple,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: selected
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: selected
                            ? AppColors.purple
                            : AppColors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Icon
              _label('Choose icon'),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: icons.map((item) {
                  final selected = selectedIcon == item['name'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = item['name'];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.purple
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? AppColors.purple
                              : AppColors.border,
                        ),
                      ),
                      child: Icon(
                        item['icon'],
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Repeat days
              _label('Repeat on'),

              const SizedBox(height: 10),

              _buildDays(),

              const SizedBox(height: 30),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: saveHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Create Habit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: AppColors.textSecondary,
      ),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.purple,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildDays() {
    const days = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        final dayNumber = index + 1;
        final selected = selectedDays.contains(dayNumber);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (selected) {
                selectedDays.remove(dayNumber);
              } else {
                selectedDays.add(dayNumber);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.purple
                  : AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? AppColors.purple
                    : AppColors.border,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              days[index],
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }),
    );
  }
}
