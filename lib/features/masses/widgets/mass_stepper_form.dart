import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/network_error_content.dart';
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
  bool _withChoir = false;

  // Demandeur
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();

  // Bénéficiaire / Intention
  final _benefNomCtrl = TextEditingController();
  final _benefPrenomCtrl = TextEditingController();
  DateTime? _benefDateDeces;

  // --- LOGIQUE INTENTIONS ---
  final List<String> _intentionsList = [
    "Action de grâce",
    "Demande de guérison / Santé",
    "Repos de l'âme d'un défunt",
    "Réussite aux examens / Concours",
    "Paix et protection de la famille",
    "Recherche d'emploi / Travail",
    "Bénédiction pour un voyage",
    "Conversion d'un proche",
    "Anniversaire de naissance",
    "Anniversaire de mariage / Jubilé",
    "Naissance / Baptême d'un enfant",
    "Fin d'une épreuve / Grâce obtenue",
    "Anniversaire de décès",
    "Pour les âmes du Purgatoire",
    "Difficultés financières / Logement",
    "Discernement / Choix de vie",
    "Force dans l'épreuve / Consolation",
    "Pour la Paix dans le monde",
    //"Intention particulière (secrète)",
    //"Autre intention particulière",
  ];
  String? _selectedIntention;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
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
    final bool isIntention = widget.id.toLowerCase().contains("intention");
    if (isIntention && _selectedIntention == null) {
      _showErrorSnackBar("Veuillez sélectionner une intention.");
      return false;
    }
    /*if (isIntention && _selectedIntention == "Autre intention particulière" && _benefNomCtrl.text.trim().isEmpty) {
      _showErrorSnackBar("Veuillez préciser votre intention.");
      return false;
    }*/
    if (_selectedParoisse == null) {
      _showErrorSnackBar("Veuillez choisir une paroisse.");
      return false;
    }
    if (_dateTime == null) {
      _showErrorSnackBar("Veuillez choisir la date et l'heure.");
      return false;
    }
    return true;
  }

  bool _validateStep1() => _formKey.currentState!.validate();

  bool _validateStep2() {
    final bool isRequiem = widget.id.toLowerCase().contains("requiem");
    if (!widget.requiresBeneficiary) return true;

    if (_benefNomCtrl.text.trim().isEmpty) {
      _showErrorSnackBar(isRequiem ? "Nom du défunt obligatoire" : "Nom du bénéficiaire obligatoire");
      return false;
    }

    if (_benefDateDeces == null && isRequiem) {
      _showErrorSnackBar("Date du décès obligatoire");
      return false;
    }
    return true;
  }

  // ===========================================================================
  // PICKERS
  // ===========================================================================

  Future<void> _chooseParoisse() async {
    if (_paroisseCtrl.paroisses.isEmpty && !_paroisseCtrl.isLoading.value) {
      _paroisseCtrl.loadParoisses();
    }

    final p = await showModalBottomSheet<ParoisseModel>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Obx(() {
        if (_paroisseCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_paroisseCtrl.hasError.value) {
          return _bottomSheetError(
            title: "Connexion indisponible",
            message: "Impossible de charger la liste des paroisses.",
            onRetry: _paroisseCtrl.loadParoisses,
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            const Text("Liste des paroisses", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary2)),
            const SizedBox(height: 16),
            ..._paroisseCtrl.paroisses.map((paroisse) => ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xff8b8b89), foregroundColor: Colors.white, child: Icon(Icons.church_rounded)),
              title: Text(paroisse.nom),
              onTap: () => Get.back(result: paroisse),
            )),
          ],
        );
      }),
    );
    if (p != null) setState(() => _selectedParoisse = p);
  }

  Future<void> _choosePastor() async {
    if (_pastorCtrl.pastors.isEmpty && !_pastorCtrl.isLoading.value) {
      _pastorCtrl.loadPastors();
    }
    final p = await showModalBottomSheet<PastorModel>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Obx(() {
        if (_pastorCtrl.isLoading.value) return const Center(child: CircularProgressIndicator());
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            const Text("Liste des pasteurs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary2)),
            const SizedBox(height: 16),
            ..._pastorCtrl.pastors.map((pastor) => ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xff8b8b89), foregroundColor: Colors.white, child: Icon(FontAwesomeIcons.userTie)),
              title: Text(pastor.nom),
              onTap: () => Get.back(result: pastor),
            )),
          ],
        );
      }),
    );
    if (p != null) setState(() => _selectedPastor = p);
  }

  Future<void> _pickDateTime() async {
    final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (d == null) return;
    final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
    if (t == null) return;
    setState(() => _dateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  Future<void> _pickDateDeces() async {
    final d = await showDatePicker(context: context, initialDate: DateTime.now().subtract(const Duration(days: 1)), firstDate: DateTime(1900), lastDate: DateTime.now());
    if (d != null) setState(() => _benefDateDeces = d);
  }

  // ===========================================================================
  // SUBMIT
  // ===========================================================================

  Future<void> _submit() async {
    String? formattedDateDeces;
    if (widget.requiresBeneficiary && _benefDateDeces != null) {
      formattedDateDeces = "${_benefDateDeces!.year}-${_benefDateDeces!.month.toString().padLeft(2, '0')}-${_benefDateDeces!.day.toString().padLeft(2, '0')}";
    }

    final bool isRequiem = widget.id.toLowerCase().contains("requiem");
    final bool isIntention = widget.id.toLowerCase().contains("intention");
    
    String finalIntention = _selectedIntention ?? "";
    if (finalIntention == "Autre intention particulière") {
      finalIntention = _benefNomCtrl.text.trim();
    }

    final req = ReservationRequest(
      massServiceId: widget.apiId,
      scheduledDate: "${_dateTime!.year}-${_dateTime!.month.toString().padLeft(2, '0')}-${_dateTime!.day.toString().padLeft(2, '0')}",
      scheduledTime: "${_dateTime!.hour}:${_dateTime!.minute.toString().padLeft(2, '0')}",
      paroisseId: _selectedParoisse!.id,
      pastorId: _selectedPastor?.id,
      requesterNom: _nomCtrl.text.trim(),
      requesterPrenom: _prenomCtrl.text.trim(),
      requesterTelephone: _telephoneCtrl.text.trim(),
      beneficiaryNom: isIntention ? finalIntention : (widget.requiresBeneficiary ? _benefNomCtrl.text.trim() : null),
      beneficiaryPrenom: isIntention ? null : (widget.requiresBeneficiary ? _benefPrenomCtrl.text.trim() : null),
      beneficiaryDateDeces: formattedDateDeces,
      withChoir: _withChoir,
    );

    Get.to(() => ReservationLoadingPage());
    await _reservationCtrl.submitReservation(req, widget.massTitle);
  }

  // ===========================================================================
  // STEPS UI
  // ===========================================================================

  Widget _buildStep0() {
    final bool isIntention = widget.id.toLowerCase().contains("intention");
    String _formatDateTime(DateTime? dt) {
      if (dt == null) return "Choisir date & heure";
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    }

    return Column(
      children: [
        if (isIntention) ...[
          _fieldContainer(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: _selectedIntention,
                decoration: _input("Sélectionnez votre intention"),
                dropdownColor: AppColors.primaryDark,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                items: _intentionsList.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                onChanged: (newValue) => setState(() => _selectedIntention = newValue),
              ),
            ),
          ),
          if (_selectedIntention == "Autre intention particulière")
            _fieldContainer(
              child: TextFormField(
                controller: _benefNomCtrl, // On utilise ce champ pour "Autre"
                decoration: _input("Précisez votre intention...").copyWith(counterText: ""),
                style: const TextStyle(color: Colors.white),
                maxLength: 200,
              ),
            ),
        ],
        _fieldContainer(
          child: InkWell(
            onTap: _chooseParoisse,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              child: Row(children: [
                const Icon(Icons.church_outlined, color: Colors.white70, size: 22),
                const SizedBox(width: 15),
                Expanded(child: Text(_selectedParoisse?.nom ?? "Choisir une paroisse", style: const TextStyle(color: Colors.white, fontSize: 16), overflow: TextOverflow.ellipsis)),
              ]),
            ),
          ),
        ),
        _fieldContainer(
          child: InkWell(
            onTap: _choosePastor,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              child: Row(children: [
                const FaIcon(FontAwesomeIcons.userTie, color: Colors.white70, size: 20),
                const SizedBox(width: 15),
                Expanded(child: Text(_selectedPastor?.nom ?? "Choisir un pasteur (optionnel)", style: const TextStyle(color: Colors.white, fontSize: 16), overflow: TextOverflow.ellipsis)),
              ]),
            ),
          ),
        ),
        _fieldContainer(
          child: InkWell(
            onTap: _pickDateTime,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              child: Row(children: [
                const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 20),
                const SizedBox(width: 15),
                Expanded(child: Text(_formatDateTime(_dateTime), style: const TextStyle(color: Colors.white, fontSize: 16))),
                const Icon(Icons.access_time_rounded, color: Colors.white70, size: 18),
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(children: [
            const Text("Chorale :", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(width: 25),
            _buildChoirOption("Avec", true),
            const SizedBox(width: 20),
            _buildChoirOption("Sans", false),
          ]),
        ),
      ],
    );
  }

  Widget _buildStep1() => Column(children: [
    _fieldContainer(child: TextFormField(controller: _nomCtrl, decoration: _input("Nom"), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s\-]"))], validator: _validateName, style: const TextStyle(color: Colors.white))),
    _fieldContainer(child: TextFormField(controller: _prenomCtrl, decoration: _input("Prénom"), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s\-]"))], validator: _validateName, style: const TextStyle(color: Colors.white))),
    _fieldContainer(child: TextFormField(controller: _telephoneCtrl, keyboardType: TextInputType.phone, decoration: _input("Téléphone"), inputFormatters: [FilteringTextInputFormatter.digitsOnly], style: const TextStyle(color: Colors.white))),
  ]);

  Widget _buildStep2() {
    final bool isRequiem = widget.id.toLowerCase().contains("requiem");
    if (!widget.requiresBeneficiary) return const Center(child: Text("Pas d'informations supplémentaires requises", style: TextStyle(color: Colors.white)));
    
    return Column(
      children: [
        _fieldContainer(child: TextFormField(controller: _benefNomCtrl, decoration: _input(isRequiem ? "Nom du défunt" : "Nom du bénéficiaire"), style: const TextStyle(color: Colors.white))),
        _fieldContainer(child: TextFormField(controller: _benefPrenomCtrl, decoration: _input(isRequiem ? "Prénom du défunt" : "Prénom du bénéficiaire"), style: const TextStyle(color: Colors.white))),
        if (isRequiem)
          _fieldContainer(child: InkWell(onTap: _pickDateDeces, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15), child: Text(_benefDateDeces == null ? "Date du décès" : "${_benefDateDeces!.day}/${_benefDateDeces!.month}/${_benefDateDeces!.year}", style: const TextStyle(color: Colors.white))))),
      ],
    );
  }

  Widget _buildStep3() {
    final bool isIntention = widget.id.toLowerCase().contains("intention");
    String formatDate(DateTime? d) => d == null ? "—" : "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
    String formatTime(DateTime? d) => d == null ? "—" : "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _summaryRow("Type de messe", widget.massTitle),
        _summaryRow("Paroisse", _selectedParoisse?.nom ?? "—"),
        _summaryRow("Date", formatDate(_dateTime)),
        _summaryRow("Heure", formatTime(_dateTime)),
        _summaryRow("Chorale", _withChoir ? "Avec" : "Sans", icon: Icons.music_note),
        if (isIntention) _summaryRow("Intention", (_selectedIntention == "Autre intention particulière" ? _benefNomCtrl.text : _selectedIntention) ?? "—", icon: Icons.auto_awesome),
        const Divider(color: Colors.white24, height: 24),
        _summaryRow("Demandeur", "${_nomCtrl.text} ${_prenomCtrl.text}"),
        _summaryRow("Téléphone", _telephoneCtrl.text),
        if (!isIntention && widget.requiresBeneficiary) ...[
           const Divider(color: Colors.white24, height: 24),
           _summaryRow("Bénéficiaire", "${_benefNomCtrl.text} ${_benefPrenomCtrl.text}"),
        ]
      ],
    );
  }

  // ... (Reste des widgets helpers comme _buildHeader, _buildButtons, _buildTargetOption, _summaryRow, _buildChoirOption, _showErrorSnackBar, etc.)
  Widget _buildHeader() {
    const labels = ["Infos", "Demandeur", "Bénéficiaire", "Résumé"];
    return Row(children: List.generate(4, (i) => Expanded(child: Column(children: [
      AnimatedContainer(duration: const Duration(milliseconds: 300), padding: const EdgeInsets.all(8), decoration: BoxDecoration(shape: BoxShape.circle, color: _currentStep >= i ? widget.accentColor : Colors.white24), child: Text("${i + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      const SizedBox(height: 4),
      Text(labels[i], style: TextStyle(fontSize: 10, color: _currentStep == i ? Colors.white : Colors.white54)),
    ]))));
  }

  Widget _summaryRow(String label, String value, {IconData? icon}) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
    if (icon != null) Icon(icon, size: 14, color: Colors.white54),
    const SizedBox(width: 8),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
    const Spacer(),
    Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
  ]));

  Widget _buildChoirOption(String label, bool value) {
    final isSelected = _withChoir == value;
    return InkWell(onTap: () => setState(() => _withChoir = value), child: Row(children: [Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: Colors.white, size: 20), const SizedBox(width: 8), Text(label, style: const TextStyle(color: Colors.white))]));
  }

  Widget _buildButtons() => Padding(padding: const EdgeInsets.only(top: 20), child: Row(children: [
    if (_currentStep > 0) Expanded(child: OutlinedButton(onPressed: () => setState(() => _currentStep--), child: const Text("Précédent", style: TextStyle(color: Colors.white)))),
    if (_currentStep > 0) const SizedBox(width: 12),
    Expanded(child: ElevatedButton(onPressed: _handleNavigation, child: Text(_currentStep < 3 ? "Suivant" : "Envoyer"))),
  ]));

  void _handleNavigation() {
    if (_currentStep == 0 && _validateStep0()) setState(() => _currentStep++);
    else if (_currentStep == 1 && _validateStep1()) setState(() => _currentStep++);
    else if (_currentStep == 2 && _validateStep2()) setState(() => _currentStep++);
    else if (_currentStep == 3) _submit();
  }

  void _showErrorSnackBar(String message) { Get.snackbar("Erreur", message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white); }
  
  Widget _bottomSheetError({required String title, required String message, required VoidCallback onRetry}) => Container(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(message), ElevatedButton(onPressed: onRetry, child: const Text("Réessayer"))]));

  String? _validateName(String? v) => (v == null || v.trim().length < 2) ? "Minimum 2 caractères" : null;

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: Column(children: [_buildHeader(), const SizedBox(height: 20), if (_currentStep == 0) _buildStep0() else if (_currentStep == 1) _buildStep1() else if (_currentStep == 2) _buildStep2() else _buildStep3(), _buildButtons()]));
  }
}
