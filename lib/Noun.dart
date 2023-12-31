class Noun {
  final String id;
  final String english;
  final String articleSingular;
  final String singular;
  final String articlePlural;
  final String plural;

  Noun({
    required this.id,
    required this.english,
    required this.articleSingular,
    required this.singular,
    required this.articlePlural,
    required this.plural,
  });

  factory Noun.fromJson(Map<String, dynamic> json) {
    return Noun(
      id: json['id'],
      english: json['english'],
      articleSingular: json['article_singular'],
      singular: json['singular'],
      articlePlural: json['article_plural'],
      plural: json['plural'],
    );
  }
}