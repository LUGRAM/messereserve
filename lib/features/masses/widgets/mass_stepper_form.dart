import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:messeconnect/features/masses/models/pastor_model.dart';
import 'package:messeconnect/features/masses/models/paroisse_model.dart';
import 'package:messeconnect/features/masses/models/mock_paroisses.dart';

import 'package:messeconnect/features/masses/models/reservation_request.dart';
import 'package:messeconnect/features/masses/services/reservation_api.dart';
import 'package:messeconnect/features/masses/pages/reservations/reservation_sent_page.dart';
import 'package:messeconnect/features/masses/widgets/pastor_selector.dart';

import '../controllers/paroisse_controller.dart';
import '../controllers/pastor_controller.dart';

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

  // --- Paroisse
  ParoisseModel? _selectedParoisse;
  // final List<ParoisseModel> _paroissesList = mockParoisses;

  final ParoisseController _paroisseCtrl = Get.put(ParoisseController());
  final PastorController _pastorCtrl = Get.put(PastorController());



  @override
  void initState() {
    super.initState();
    _paroisseCtrl.loadParoisses();
    _pastorCtrl.loadPastors();
  }

  // --- Messe
  DateTime? _dateTime;
  PastorModel? _selectedPastor;

  // --- Demandeur
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _nationaliteCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();

  // --- Défunt (requiem)
  final _benefNomCtrl = TextEditingController();
  final _benefPrenomCtrl = TextEditingController();
  DateTime? _benefDateDeces;

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

  // ---------------------------------------------------------------------------
  // DECORATION & CONTAINERS
  // ---------------------------------------------------------------------------

  Widget _fieldContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: child,
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),

      errorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(14),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(14),
      ),
      errorStyle: const TextStyle(height: 0, color: Colors.transparent),
    );
  }

  // ---------------------------------------------------------------------------
  // PICKERS
  // ---------------------------------------------------------------------------

  Future<void> _chooseParoisse() async {
    final p = await showModalBottomSheet<ParoisseModel>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Obx(() {
          if (_paroisseCtrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_paroisseCtrl.paroisses.isEmpty) {
            return const Center(child: Text("Aucune paroisse trouvée"));
          }

          return ListView(
            children: _paroisseCtrl.paroisses.map((paroisse) {
              return ListTile(
                title: Text(paroisse.nom),
                subtitle: Text(paroisse.address),
                trailing: const Icon(Icons.church),
                onTap: () => Navigator.pop(context, paroisse),
              );
            }).toList(),
          );
        });
      },
    );

    if (mounted && p != null) {
      setState(() => _selectedParoisse = p);
    }
  }


  Future<void> _choosePastor() async {
    final p = await showModalBottomSheet<PastorModel>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => const PastorSelector(),
    );

    if (mounted && p != null) {
      setState(() => _selectedPastor = p);
    }
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (!mounted || selectedDate == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (!mounted || selectedTime == null) return;

    setState(() {
      _dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    });
  }

  Future<void> _pickBenefDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 50),
      lastDate: now,
    );

    if (mounted && picked != null) {
      setState(() => _benefDateDeces = picked);
    }
  }

  // ---------------------------------------------------------------------------
  // STEPPER HEADER
  // ---------------------------------------------------------------------------

  Widget _buildStepHeader() {
    Widget stepCircle(int index, String label) {
      final active = _currentStep == index;
      final done = _currentStep > index;

      final bg = done
          ? Colors.white
          : active
          ? widget.accentColor
          : Colors.white.withValues(alpha: 0.2);

      final fg = done ? widget.accentColor : Colors.white;

      const steps = ['①', '②', '③'];

      return Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: bg,
            child: Text(
              steps[index],
              style: TextStyle(color: fg, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70))
        ],
      );
    }

    Widget line(bool filled) {
      return Expanded(
        child: Container(
          height: 2,
          color: filled
              ? widget.accentColor
              : Colors.white.withValues(alpha: 0.3),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          stepCircle(0, 'Infos'),
          line(_currentStep >= 1),
          stepCircle(1, 'Identité'),
          line(_currentStep >= 2),
          stepCircle(2, 'Résumé'),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 0 : PAROISSE + PASTEUR + DATE/HEURE
  // ---------------------------------------------------------------------------

  Widget _buildStep0() {
    return Column(
      children: [
        // PAROISSE
        _fieldContainer(
          child: InkWell(
            onTap: _chooseParoisse,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedParoisse == null
                        ? "Choisir une paroisse (obligatoire)"
                        : "Paroisse : ${_selectedParoisse!.nom}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Icon(Icons.church, color: Colors.white70),
              ],
            ),
          ),
        ),

        // PASTEUR
        _fieldContainer(
          child: InkWell(
            onTap: _choosePastor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedPastor == null
                        ? "Choisir un pasteur (optionnel)"
                        : "Pasteur : ${_selectedPastor!.nom}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Icon(Icons.person, color: Colors.white70),
              ],
            ),
          ),
        ),

        // DATE & HEURE
        _fieldContainer(
          child: InkWell(
            onTap: _pickDateTime,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _dateTime == null
                        ? "Choisir la date & l'heure"
                        : "${_dateTime!.day}/${_dateTime!.month}/${_dateTime!.year}  -  "
                        "${_dateTime!.hour.toString().padLeft(2, '0')}:${_dateTime!.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Icon(Icons.calendar_month, color: Colors.white70),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 1 : DONNÉES DEMANDEUR / DEFUNT
  // ---------------------------------------------------------------------------

  Widget _buildStep1() {
    final isRequiem = widget.requiresBeneficiary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isRequiem) ...[
          _fieldContainer(
            child: TextFormField(
              controller: _nomCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _input("Votre nom"),
              validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
            ),
          ),
          _fieldContainer(
            child: TextFormField(
              controller: _prenomCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _input("Votre prénom"),
              validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
            ),
          ),
          _fieldContainer(
            child: TextFormField(
              controller: _nationaliteCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _input("Nationalité"),
              validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
            ),
          ),
          _fieldContainer(
            child: TextFormField(
              controller: _telephoneCtrl,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: _input("Numéro de téléphone"),
              validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
            ),
          ),
        ],

        if (isRequiem) ...[
          const SizedBox(height: 6),
          Text("Informations du défunt",
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          _fieldContainer(
            child: TextFormField(
              controller: _benefNomCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _input("Nom du défunt"),
            ),
          ),
          _fieldContainer(
            child: TextFormField(
              controller: _benefPrenomCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _input("Prénom du défunt"),
            ),
          ),
          _fieldContainer(
            child: InkWell(
              onTap: _pickBenefDate,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _benefDateDeces == null
                        ? "Date du décès (optionnel)"
                        : "${_benefDateDeces!.day}/${_benefDateDeces!.month}/${_benefDateDeces!.year}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(Icons.event, color: Colors.white70),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2 : RÉSUMÉ
  // ---------------------------------------------------------------------------

  Widget _buildStep2() {
    String fmtDT(DateTime? d) =>
        d == null
            ? "Non précisé"
            : "${d.day}/${d.month}/${d.year} - "
            "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

    Widget row(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        row("Type de messe", widget.massTitle),
        row("Paroisse", _selectedParoisse?.nom ?? "Non précisée"),
        row("Date & heure", fmtDT(_dateTime)),
        row("Pasteur choisi", _selectedPastor?.nom ?? "Non précisé"),
        const SizedBox(height: 8),

        if (!widget.requiresBeneficiary) ...[
          row("Nom du demandeur", _nomCtrl.text.trim()),
          row("Prénom du demandeur", _prenomCtrl.text.trim()),
          row("Nationalité", _nationaliteCtrl.text.trim()),
          row("Téléphone", _telephoneCtrl.text.trim()),
        ] else ...[
          row("Nom du défunt", _benefNomCtrl.text.trim()),
          row("Prénom du défunt", _benefPrenomCtrl.text.trim()),
          row(
            "Date du décès",
            _benefDateDeces == null
                ? "Non précisée"
                : "${_benefDateDeces!.day}/${_benefDateDeces!.month}/${_benefDateDeces!.year}",
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SUBMIT()
  // ---------------------------------------------------------------------------

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedParoisse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez choisir une paroisse.")),
      );
      setState(() => _currentStep = 0);
      return;
    }

    if (_dateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez choisir la date & l'heure.")),
      );
      setState(() => _currentStep = 0);
      return;
    }

    final req = ReservationRequest(
      massServiceId: 1,
      beneficiary: widget.requiresBeneficiary ? _benefNomCtrl.text.trim() : null,
      pastorId: _selectedPastor?.id,
      scheduledDate:
      "${_dateTime!.year}-${_dateTime!.month}-${_dateTime!.day}",
      scheduledTime:
      "${_dateTime!.hour}:${_dateTime!.minute.toString().padLeft(2, '0')}",
      paroisseId: _selectedParoisse!.id,
    );

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
      const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    final response = await ReservationApi.createReservation(req);

    if (!mounted) return;
    Navigator.pop(context);

    if (response["success"] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReservationSentPage(
            reference: response["reference"].toString(),
            massTitle: widget.massTitle,
            date:
            "${_dateTime!.day}/${_dateTime!.month}/${_dateTime!.year}",
            time:
            "${_dateTime!.hour.toString().padLeft(2, '0')}:${_dateTime!.minute.toString().padLeft(2, '0')}",
            pastorName: _selectedPastor?.nom ?? "",
          ),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // BUTTONS
  // ---------------------------------------------------------------------------

  Widget _buildButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
              ),
              child: const Text("Précédent",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_currentStep == 0) {
                if (_selectedParoisse == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Veuillez choisir une paroisse.")),
                  );
                  return;
                }
                setState(() => _currentStep = 1);
              } else if (_currentStep == 1) {
                if (_formKey.currentState!.validate()) {
                  setState(() => _currentStep = 2);
                }
              } else {
                _submit();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              backgroundColor: Colors.white.withValues(alpha: 0.85),
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              _currentStep < 2 ? "Suivant" : "Envoyer",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget stepContent = _currentStep == 0
        ? _buildStep0()
        : _currentStep == 1
        ? _buildStep1()
        : _buildStep2();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildStepHeader(),
          const SizedBox(height: 6),
          stepContent,
          const SizedBox(height: 14),
          _buildButtons(),
        ],
      ),
    );
  }
}
