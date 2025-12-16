class MassModel {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String heroTag;
  final int accentColor; // stocké en int (Color.value)
  final String route; // ex: /mass/requiem

  const MassModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.heroTag,
    required this.accentColor,
    required this.route,
  });
}
