import 'mass_model.dart';

final List<MassModel> mockMasses = [
  MassModel(
    id: "requiem",
    title: "Messe de Requiem",
    subtitle: "Pour les défunts",
    image: "assets/images/masses/requiem.jpg",
    heroTag: "messe_requiem",
    accentColor: 0xFF42A5F5, // bleu
    route: "/mass/requiem",
  ),
  MassModel(
    id: "action_grace",
    title: "Messe d’Action de Grâce",
    subtitle: "Remerciement à Dieu",
    image: "assets/images/masses/action_grace.jpg",
    heroTag: "messe_action_grace",
    accentColor: 0xFFEF5350, // rouge
    route: "/mass/action-grace",
  ),
  MassModel(
    id: "guerison",
    title: "Messe pour la Santé",
    subtitle: "Guérison & réconfort",
    image: "assets/images/masses/guerison.jpg",
    heroTag: "messe_guerison",
    accentColor: 0xFF66BB6A, // vert
    route: "/mass/guerison",
  ),
  MassModel(
    id: "nuptiale",
    title: "Messe Nuptiale",
    subtitle: "Union sacrée",
    image: "assets/images/masses/nuptial.jpg",
    heroTag: "messe_nuptiale",
    accentColor: 0xFF5C6BC0, // violet
    route: "/mass/nuptiale",
  ),
  MassModel(
    id: "bapteme",
    title: "Messe Bapteme",
    subtitle: "Se Conacrer",
    image: "assets/images/masses/healing.jpg",
    heroTag: "messe_bapteme",
    accentColor: 0xFF5C6BCA, // couleur??
    route: "/mass/bapteme",
  ),
];
