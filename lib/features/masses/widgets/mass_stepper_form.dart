import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final int apiId;
  final String id;
  final Color accentColor;
  final String massTitle;
  final String massAmount;
  final bool requiresBeneficiary;

  const MassStepperForm({
    super.key,
    required this.apiId,
    required this.id,
    required this.accentColor,
    required this.massTitle,
    required this.massAmount,
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

  Widget _fieldContainer({required Widget child, double marginBottom = 14}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      constraints: const BoxConstraints(minHeight: 56),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  InputDecoration _input(String hint) => InputDecoration(
    filled: false,
    fillColor: Colors.transparent,

    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,

    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white54),

    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

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

    if (_benefDateDeces == null && widget.id =='requiem') {
      Get.snackbar("Date manquante","Date du décès obligatoire");
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
    // 1. On prépare la date de décès de manière sécurisée
    String? formattedDateDeces;
    if (widget.requiresBeneficiary && _benefDateDeces != null) {
      formattedDateDeces = "${_benefDateDeces!.year}-${_benefDateDeces!.month.toString().padLeft(2, '0')}-${_benefDateDeces!.day.toString().padLeft(2, '0')}";
    }

    final req = ReservationRequest(
      massServiceId: widget.apiId,
      scheduledDate:
      "${_dateTime!.year}-${_dateTime!.month.toString().padLeft(2, '0')}-${_dateTime!.day.toString().padLeft(2, '0')}",
      scheduledTime:
      "${_dateTime!.hour}:${_dateTime!.minute.toString().padLeft(2, '0')}",

      paroisseId: _selectedParoisse!.id, // ignoré côté backend pour l’instant
      pastorId: _selectedPastor?.id,
      requesterNom: _nomCtrl.text.trim(),
      requesterPrenom: _prenomCtrl.text.trim(),
      requesterNationalite: _nationaliteCtrl.text.trim(),
      requesterTelephone: _telephoneCtrl.text.trim(),
      beneficiaryNom: widget.requiresBeneficiary ? _benefNomCtrl.text.trim() : null,
      beneficiaryPrenom: widget.requiresBeneficiary ? _benefPrenomCtrl.text.trim() : null,
      // Utilise la variable sécurisée ici
      beneficiaryDateDeces: formattedDateDeces,
    );

    Get.to(() => ReservationLoadingPage());
    await _reservationCtrl.submitReservation(req, widget.massTitle);
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
        final bool active = _currentStep == i;
        final bool done = _currentStep > i;
        return Expanded(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? Colors.white : active ? widget.accentColor : Colors.white24,
                ),
                child: done
                    ? const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white, // Ou widget.accentColor selon ton design
                )
                    : Text(
                  "${i + 1}",
                  style: TextStyle(
                    color: active ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(labels[i],
                  style: TextStyle(
                      fontSize: 10,
                      color: active ? Colors.white : Colors.white54,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal
                  )),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStep0() {

    String _formatDateTime(DateTime? dt) {
      if (dt == null) return "Choisir date & heure";

      // Utilisation de padLeft pour garantir le format 01/01 au lieu de 1/1
      String d = dt.day.toString().padLeft(2, '0');
      String m = dt.month.toString().padLeft(2, '0');
      String y = dt.year.toString();
      String h = dt.hour.toString().padLeft(2, '0');
      String min = dt.minute.toString().padLeft(2, '0');

      return "$d/$m/$y  -  $h:$min";
    }

    return Column(
      children: [
        // --- CHAMP PAROISSE ---
        _fieldContainer(
          child: InkWell(
            onTap: _chooseParoisse, // Corrigé : _chooseParoisse au lieu de _choosePastor
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              child: Row(
                children: [
                  const Icon(Icons.church_outlined, color: Colors.white70, size: 22),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      _selectedParoisse?.nom ?? "Choisir une paroisse",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        //const SizedBox(height: 12), // Espacement entre les champs

        // --- CHAMP PASTEUR ---
        _fieldContainer(
          child: InkWell(
            onTap: _choosePastor,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.userTie, color: Colors.white70, size: 20),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      _selectedPastor?.nom ?? "Choisir un pasteur (optionnel)",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        //const SizedBox(height: 12),

        // --- CHAMP DATE & HEURE ---
        _fieldContainer(
          child: InkWell(
            onTap: _pickDateTime,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 20),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      _formatDateTime(_dateTime),
                      style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 0.5),
                    ),
                  ),
                  const Icon(Icons.access_time_rounded, color: Colors.white70, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //==================================pour le data integry===============================
  // Validation Nom/Prénom : Uniquement lettres, espaces, tirets (2 min)
  final RegExp _nameRegExp = RegExp(r"^[a-zA-ZÀ-ÿ\s\-]{2,30}$");

  // Validation Téléphone : Chiffres uniquement (ex: 8 à 15 chiffres selon le pays)
  final RegExp _phoneRegExp = RegExp(r"^[0-9]{8,15}$");

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Ce champ est obligatoire";
    if (!_nameRegExp.hasMatch(value.trim())) return "Format invalide (Lettres uniquement)";
    return null;
  }
  //======================================================================================

  Widget _buildStep1() => Column(children: [
    _fieldContainer(
      child: TextFormField(
        controller: _nomCtrl,
        decoration: _input("Nom"),
        // Empêche de taper des chiffres/symboles en temps réel
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s\-]"))],
        validator: _validateName,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    _fieldContainer(
      child: TextFormField(
        controller: _prenomCtrl,
        decoration: _input("Prénom"),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s\-]"))],
        validator: _validateName,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    _fieldContainer(
      child: TextFormField(
        controller: _nationaliteCtrl,
        decoration: _input("Nationalité"),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s\-]"))],
        validator: _validateName,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    _fieldContainer(
      child: TextFormField(
        controller: _telephoneCtrl,
        keyboardType: TextInputType.phone, // Ouvre le clavier numérique
        decoration: _input("Téléphone (ex: 077000001)"),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Bloque tout sauf chiffres
        validator: (v) {
          if (v == null || v.isEmpty) return "Obligatoire";
          if (!_phoneRegExp.hasMatch(v)) return "Numéro invalide (8-15 chiffres)";
          return null;
        },
        style: const TextStyle(color: Colors.white),
      ),
    ),
  ]);

  Widget _buildStep2() {
    final bool isRequiem = widget.id.toLowerCase().contains("requiem");

    return Column(
      children: [
        _fieldContainer(
          child: TextFormField(
            controller: _benefNomCtrl,
            decoration: _input(isRequiem ? "Nom du défunt" : "Nom du bénéficiaire"),
            style: const TextStyle(color: Colors.white),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s\-]"))],
            validator: (v) => (v == null || v.trim().isEmpty) ? "Champ obligatoire" : null,
          ),
        ),
        _fieldContainer(
          child: TextFormField(
            controller: _benefPrenomCtrl,
            decoration: _input(isRequiem ? "Prénom du défunt" : "Prénom du bénéficiaire"),
            style: const TextStyle(color: Colors.white),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s\-]"))],
          ),
        ),
        if (isRequiem)
          _fieldContainer(
            // On harmonise le design avec une icône comme pour la Step 0
            child: InkWell(
              onTap: _pickDateDeces,
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                child: Row(
                  children: [
                    Text(
                      _benefDateDeces == null
                          ? "Date du décès"
                          : "${_benefDateDeces!.day.toString().padLeft(2,'0')}/${_benefDateDeces!.month.toString().padLeft(2,'0')}/${_benefDateDeces!.year}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStep3() {
    // Helper local pour formater proprement les dates
    String formatDate(DateTime? d) {
      if (d == null) return "—";
      return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
    }

    String formatTime(DateTime? d) {
      if (d == null) return "—";
      return "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _summaryRow("Type de messe", widget.massTitle),
        const SizedBox(height: 6),
        _summaryRow("Paroisse", _selectedParoisse?.nom ?? "—"),
        _summaryRow("Date", formatDate(_dateTime)),
        _summaryRow("Heure", formatTime(_dateTime)),
        _summaryRow("Pasteur", _selectedPastor?.nom ?? "Non spécifié"),

        const Divider(color: Colors.white24, height: 24),

        _summaryRow("Demandeur", "${_nomCtrl.text.trim()} ${_prenomCtrl.text.trim()}"),
        _summaryRow("Nationalité", _nationaliteCtrl.text.trim().isNotEmpty ? _nationaliteCtrl.text.trim() : "—"),
        _summaryRow("Téléphone", _telephoneCtrl.text.trim()),

        const Divider(color: Colors.white24, height: 24),

        // Affichage dynamique selon le type de messe
        if (widget.id.toLowerCase().contains("requiem")) ...[
          _summaryRow(
              "Défunt",
              "${_benefNomCtrl.text.trim()} ${_benefPrenomCtrl.text.trim()}",
              icon: FontAwesomeIcons.dove // Rappel visuel du deuil
          ),
          _summaryRow(
              "Date du décès",
              formatDate(_benefDateDeces),
              icon: Icons.calendar_today_outlined
          ),
        ] else if (_benefNomCtrl.text.trim().isNotEmpty) ...[
          _summaryRow(
              "Bénéficiaire",
              "${_benefNomCtrl.text.trim()} ${_benefPrenomCtrl.text.trim()}"
          ),
        ],
      ],
    );
  }

  Widget _summaryRow(String label, String value, {IconData? icon}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: Colors.white38),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () => setState(() => _currentStep--),
                child: const Text("Précédent", style: TextStyle(color: Colors.white)),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2), // Verre dépoli
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _handleNavigation,
              child: Text(_currentStep < 3 ? "Suivant" : "Envoyer"),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation() {
    // ÉTAPE 0 : Validation personnalisée (Sélecteurs)
    if (_currentStep == 0) {
      if (_validateStep0()) {
        setState(() => _currentStep++);
      }
      return;
    }

    // ÉTAPES 1 & 2 : Validation des TextFormFields
    if (_currentStep == 1 || _currentStep == 2) {
      if (_formKey.currentState!.validate()) {
        if (_currentStep == 2 && !_validateStep2()) return;

        setState(() => _currentStep++);
      } else {
        _showErrorSnackBar("Veuillez remplir correctement tous les champs.");
      }
      return;
    }

    // ÉTAPE 3 : Soumission finale
    if (_currentStep == 3) {
      _submit();
    }
  }

// Helper pour éviter la répétition de code GetX
  void _showErrorSnackBar(String message) {
    Get.snackbar(
      "Validation",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
    );
  }}
