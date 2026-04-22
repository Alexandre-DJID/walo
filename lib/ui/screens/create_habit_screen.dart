import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../providers/habit_provider.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();
  final _unitController = TextEditingController(text: "fois");
  List<int> selectedDays = [1, 2, 3, 4, 5, 6, 7];

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NOUVEAU PROTOCOLE", style: TextStyle(fontSize: 14, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("NOM DE L'HABITUDE"),
            _buildTextField(_nameController, "ex: LECTURE, CODE, SPORT..."),
            const SizedBox(height: 24),
            _buildLabel("OBJECTIF QUOTIDIEN"),
            Row(
              children: [
                Expanded(child: _buildTextField(_goalController, "20", isNumber: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(_unitController, "pages")),
              ],
            ),
            const SizedBox(height: 32),
            _buildLabel("FRÉQUENCE"),
            const SizedBox(height: 12),
            _buildDayPicker(),
            const SizedBox(height: 60),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: CyberColors.textSecondary, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: CyberColors.neonCyan, fontSize: 18),
      cursorColor: CyberColors.neonCyan,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: CyberColors.brutalGrey, fontSize: 16),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CyberColors.brutalGrey)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CyberColors.neonCyan, width: 2)),
      ),
    );
  }

  Widget _buildDayPicker() {
    final days = ["L", "M", "M", "J", "V", "S", "D"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final dayNum = index + 1;
        final isSelected = selectedDays.contains(dayNum);
        return GestureDetector(
          onTap: () {
            setState(() {
              isSelected ? selectedDays.remove(dayNum) : selectedDays.add(dayNum);
            });
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              border: Border.all(color: isSelected ? CyberColors.neonCyan : CyberColors.brutalGrey, width: 1.5),
              color: isSelected ? CyberColors.neonCyan.withValues(alpha: 0.1) : Colors.transparent,
            ),
            child: Center(
              child: Text(
                days[index],
                style: TextStyle(
                  color: isSelected ? CyberColors.neonCyan : CyberColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CyberColors.neonCyan,
          foregroundColor: Colors.black,
          elevation: 10,
          shadowColor: CyberColors.neonCyan.withValues(alpha: 0.3),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: () {
          if (_nameController.text.isNotEmpty && _goalController.text.isNotEmpty) {
            ref.read(habitsProvider.notifier).addHabit(
              name: _nameController.text,
              goalValue: double.tryParse(_goalController.text) ?? 1,
              unit: _unitController.text,
              frequency: selectedDays,
            );
            Navigator.pop(context);
          }
        },
        child: const Text(
          "INITIALISER LE PROTOCOLE",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 14),
        ),
      ),
    );
  }
}
