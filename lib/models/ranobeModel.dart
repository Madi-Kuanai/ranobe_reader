abstract class RanobeModel {
  final int _id;
  final String _name;
  final String _href;
  final _coverLink;

  RanobeModel(this._id, this._name, this._href, this._coverLink);

  @override
  String toString() {
    return 'RanobeModel{_id: $_id, _name: $_name, _href: $_href, $_coverLink}';
  }

  String get href => _href;

  String get name => _name;

  int get id => _id;

  get coverLink => _coverLink;
}

class DefaultRanobeModel extends RanobeModel {
  final Map<String, String>? genres;

  DefaultRanobeModel(
      {required int id,
      required String name,
      required String href,
      required String coverLink,
      required this.genres})
      : super(id, name, href, coverLink);

  factory DefaultRanobeModel.fromJson(Map<String, dynamic> json) {
    return DefaultRanobeModel(
        id: json["id"],
        name: json["name"],
        href: json["href"],
        coverLink: json["coverLink"],
        genres: json["genres"]);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        "name": name,
        "href": href,
        "coverLink": coverLink,
        "genres": genres
      };
}

class NewChaptersModel extends DefaultRanobeModel {
  final int howMany;
  final Map<String, String> newChapters;
  final updateAt;

  NewChaptersModel(
      {required int id,
      required String name,
      required String href,
      required String coverLink,
      required Map<String, String> genres,
      required this.updateAt,
      required this.howMany,
      required this.newChapters})
      : super(
            id: id,
            name: name,
            href: href,
            coverLink: coverLink,
            genres: genres);
}
