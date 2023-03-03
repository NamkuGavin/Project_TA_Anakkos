final String tableKost = 'kost_fav';

class KostFields {
  static final List<String> values = [
    id,
    idKost,
    name,
    coverImg,
    location,
    type,
    price,
  ];

  static final String id = '_id';
  static final String idKost = 'idKost';
  static final String name = 'name';
  static final String coverImg = 'coverImg';
  static final String location = 'location';
  static final String type = 'type';
  static final String price = 'price';
}

class KostFav {
  final int? id;
  final int idKost;
  final String name;
  final String coverImg;
  final String location;
  final String type;
  final String price;

  KostFav({
    this.id,
    required this.idKost,
    required this.name,
    required this.coverImg,
    required this.location,
    required this.type,
    required this.price,
  });

  Map<String, Object?> toJson() => {
        KostFields.id: id,
        KostFields.idKost: idKost,
        KostFields.name: name,
        KostFields.coverImg: coverImg,
        KostFields.location: location,
        KostFields.type: type,
        KostFields.price: price,
      };

  static KostFav fromJson(Map<String, Object?> json) => KostFav(
        id: json[KostFields.id] as int?,
        idKost: json[KostFields.idKost] as int,
        name: json[KostFields.name] as String,
        coverImg: json[KostFields.coverImg] as String,
        location: json[KostFields.location] as String,
        type: json[KostFields.type] as String,
        price: json[KostFields.price] as String,
      );

  KostFav copy({
    int? id,
    int? idKost,
    String? name,
    String? coverImg,
    String? location,
    String? type,
    String? price,
  }) =>
      KostFav(
        id: id ?? this.id,
        idKost: idKost ?? this.idKost,
        name: name ?? this.name,
        coverImg: coverImg ?? this.coverImg,
        location: location ?? this.location,
        type: type ?? this.type,
        price: price ?? this.price,
      );
}
