import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reservation_controller.dart';
import '../../parish/controllers/paroisse_controller.dart';
import '../../parish/controllers/pastor_controller.dart';

import '../../parish/models/paroisse_model.dart';
import '../../parish/models/pastor_model.dart';

import '../requests/reservation_request.dart';
import '../pages/reservations/reservation_loading_page.dart';
import '../widgets/pastor_selector.dart';

class MassStepperForm extends StatefulWidget {
  final Color accentColor;
  final String massTitle;
  final bool requiresBeneficiary;

  const MassStepperForm({
    super.key,
    required this.accentColor,
    required this.massTitle,
    required this.requiresBeneficiary,
  });

  @override
  State<MassStepperForm> createState() => _MassStepperFormState();
}

class _MassStepperFormState extends State<MassStepperForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers GetX
  final ParoisseController _paroisseCtrl = Get.find();
  final PastorController _pastorCtrl = Get.find();
  final ReservationController _reservationCtrl = Get.find();

  // Sélections
  ParoisseModel? _selectedParoisse;
  PastorModel? _selectedPastor;
  DateTime? _dateTime;

  // Demandeur
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _nationaliteCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();

  // Bénéficiaire (Requiem)
  final _benefNomCtrl = TextEditingController();
  final _benefPrenomCtrl = TextEditingController();
  DateTime? _benefDateDeces;

  @override
  void initState() {
    super.initState();
    _paroisseCtrl.loadParoisses();
    _pastorCtrl.loadPastors();
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _nationaliteCtrl.dispose();
    _telephoneCtrl.dispose();
    _benefNomCtrl.dispose();
    _benefPrenomCtrl.dispose();
    super.dispose();
  }

  // ===========================================================================
  // UI HELPERS
  // ===========================================================================

  Widget _fieldContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      constraints: const BoxConstraints(minHeight: 56),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.35),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  InputDecoration _input(String hint) => InputDecoration(
    border: InputBorder.none,
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white70),
    errorStyle: const TextStyle(height: 0),
  );


  // ===========================================================================
  // VALIDATIONS
  // ===========================================================================

  bool _validateStep0() {
    if (_selectedParoisse == null) {
      Get.snackbar("Paroisse requise", "Veuillez choisir une paroisse");
      return false;
    }
    if (_dateTime == null) {
      Get.snackbar("Date requise", "Veuillez choisir la date et l'heure");
      return false;
    }
    return true;
  }

  bool _validateStep1() => _formKey.currentState!.validate();

  bool _validateStep2() {
    if (!widget.requiresBeneficiary) return true;

    if (_benefNomCtrl.text.trim().isEmpty) {
      Get.snackbar("Bénéficiaire requis", "Nom du défunt obligatoire");
      return false;
    }
    if (_benefDateDeces == null) {
      Get.snackbar("Date manquante", "Date du décès obligatoire");
      return false;
    }
    return true;
  }

  // ===========================================================================
  // PICKERS
  // ===========================================================================

  Future<void> _chooseParoisse() async {
    final p = await showModalBottomSheet<ParoisseModel>(
      context: context,
      builder: (_) => Obx(() {
        if (_paroisseCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: _paroisseCtrl.paroisses.map((paroisse) {
            return ListTile(
              title: Text(paroisse.nom),
              subtitle: Text(paroisse.address),
              trailing: const Icon(Icons.church),
              onTap: () => Get.back(result: paroisse),
            );
          }).toList(),
        );
      }),
    );
    if (p != null) setState(() => _selectedParoisse = p);
  }

  Future<void> _choosePastor() async {
    final p = await showModalBottomSheet<PastorModel>(
      context: context,
      builder: (_) => const PastorSelector(),
    );
    if (p != null) setState(() => _selectedPastor = p);
  }

  Future<void> _pickDateTime() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d == null) return;

    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (t == null) return;

    setState(() {
      _dateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  Future<void> _pickDateDeces() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 1)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _benefDateDeces = d);
  }

  // ===========================================================================
  // SUBMIT
  // ===========================================================================

  Future<void> _submit() async {
    final req = ReservationRequest(
      massServiceId: 1,
      scheduledDate:
      "${_dateTime!.year}-${_dateTime!.month}-${_dateTime!.day}",
      scheduledTime:
      "${_dateTime!.hour}:${_dateTime!.minute.toString().padLeft(2, '0')}",
      paroisseId: _selectedParoisse!.id,
      pastorId: _selectedPastor?.id,
      requesterNom: _nomCtrl.text.trim(),
      requesterPrenom: _prenomCtrl.text.trim(),
      requesterNationalite: _nationaliteCtrl.text.trim(),
      requesterTelephone: _telephoneCtrl.text.trim(),
      beneficiaryNom:
      widget.requiresBeneficiary ? _benefNomCtrl.text.trim() : null,
      beneficiaryPrenom:
      widget.requiresBeneficiary ? _benefPrenomCtrl.text.trim() : null,
      beneficiaryDateDeces: widget.requiresBeneficiary
          ? "${_benefDateDeces!.year}-${_benefDateDeces!.month}-${_benefDateDeces!.day}"
          : null,
    );

    _reservationCtrl.submitReservation(req);
    Get.to(() => ReservationLoadingPage());
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          if (_currentStep == 0) _buildStep0(),
          if (_currentStep == 1) _buildStep1(),
          if (_currentStep == 2) _buildStep2(),
          if (_currentStep == 3) _buildStep3(),
          const SizedBox(height: 16),
          _buildButtons(),
        ],
      ),
    );
  }

  // ===========================================================================
  // STEPS UI
  // ===========================================================================

  Widget _buildHeader() {
    const labels = ["Infos", "Demandeur", "Bénéficiaire", "Résumé"];
    return Row(
      children: List.generate(4, (i) {
        final active = _currentStep == i;
        final done = _currentStep > i;
        return Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor:
                done ? Colors.white : active ? widget.accentColor : Colors.white24,
                child: Text("${i + 1}",
                    style: TextStyle(
                        color: done ? widget.accentColor : Colors.white)),
              ),
              const SizedBox(height: 4),
              Text(labels[i],
                  style: const TextStyle(fontSize: 10, color: Colors.white70)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStep0() => Column(children: [
    _fieldContainer(
      child: InkWell(
        onTap: _chooseParoisse,
        child: Text(
          _selectedParoisse?.nom ?? "Choisir une paroisse",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
    _fieldContainer(
      child: InkWell(
        onTap: _choosePastor,
        child: Text(
          _selectedPastor?.nom ?? "Choisir un pasteur (optionnel)",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
    _fieldContainer(
      child: InkWell(
        onTap: _pickDateTime,
        child: Text(
          _dateTime == null
              ? "Choisir date & heure"
              : "${_dateTime!.day}/${_dateTime!.month}/${_dateTime!.year}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  ]);

  Widget _buildStep1() => Column(children: [
    _fieldContainer(
      child: TextFormField(
        controller: _nomCtrl,
        decoration: _input("Nom"),
        validator: (v) => v!.isEmpty ? "Obligatoire" : null,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    _fieldContainer(
      child: TextFormField(
        controller: _prenomCtrl,
        decoration: _input("Prénom"),
        validator: (v) => v!.isEmpty ? "Obligatoire" : null,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    _fieldContainer(
      child: TextFormField(
        controller: _nationaliteCtrl,
        decoration: _input("Nationalité"),
        validator: (v) => v!.isEmpty ? "Obligatoire" : null,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    _fieldContainer(
      child: TextFormField(
        controller: _telephoneCtrl,
        decoration: _input("Téléphone"),
        validator: (v) => v!.isEmpty ? "Obligatoire" : null,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  ]);

  Widget _buildStep2() {
    if (!widget.requiresBeneficiary) {
      return const Text("Aucun bénéficiaire requis",
          style: TextStyle(color: Colors.white70));
    }
    return Column(children: [
      _fieldContainer(
        child: TextFormField(
          controller: _benefNomCtrl,
          decoration: _input("Nom du défunt"),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      _fieldContainer(
        child: TextFormField(
          controller: _benefPrenomCtrl,
          decoration: _input("Prénom du défunt"),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      _fieldContainer(
        child: InkWell(
          onTap: _pickDateDeces,
          child: Text(
            _benefDateDeces == null
                ? "Date du décès"
                : "${_benefDateDeces!.day}/${_benefDateDeces!.month}/${_benefDateDeces!.year}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ]);
  }

  Widget _buildStep3() => Column(children: [
    _summaryRow("Type", widget.massTitle),
    _summaryRow("Paroisse", _selectedParoisse?.nom ?? "—"),
    _summaryRow("Date", _dateTime.toString()),
    _summaryRow("Demandeur", "${_nomCtrl.text} ${_prenomCtrl.text}"),
  ]);

  Widget _summaryRow(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
            child: Text(l,
                style:
                const TextStyle(color: Colors.white70, fontSize: 13))),
        Expanded(
            child: Text(v,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600))),
      ],
    ),
  );

  Widget _buildButtons() {
    return Row(children: [
      if (_currentStep > 0)
        Expanded(
          child: OutlinedButton(
            onPressed: () => setState(() => _currentStep--),
            child: const Text("Précédent",
                style: TextStyle(color: Colors.white)),
          ),
        ),
      if (_currentStep > 0) const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            if (_currentStep == 0 && _validateStep0()) {
              setState(() => _currentStep++);
            } else if (_currentStep == 1 && _validateStep1()) {
              setState(() => _currentStep++);
            } else if (_currentStep == 2 && _validateStep2()) {
              setState(() => _currentStep++);
            } else if (_currentStep == 3) {
              _submit();
            }
          },
          child: Text(_currentStep < 3 ? "Suivant" : "Envoyer"),
        ),
      ),
    ]);
  }
}
