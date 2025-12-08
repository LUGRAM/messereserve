import 'package:flutter/material.dart';
import '../models/paroisse_model.dart';

class ParoisseSelectorForm extends StatelessWidget {
  final ParoisseModel? selected;
  final List<ParoisseModel> paroisses;
  final Function(ParoisseModel) onSelect;

  const ParoisseSelectorForm({
    super.key,
    required this.selected,
    required this.paroisses,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ParoisseModel>(
      initialValue: selected,
      decoration: InputDecoration(
        labelText: "Choisir une paroisse",
        prefixIcon: const Icon(Icons.church_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: paroisses.map((p) {
        return DropdownMenuItem(
          value: p,
          child: Text(p.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onSelect(value);
      },
      validator: (value) {
        if (value == null) return "Veuillez sélectionner une paroisse";
        return null;
      },
    );
  }
}
