class KostDummyModel {
  String picture_kost;
  String type_kost;
  String name_kost;
  String location_kost;
  String price_kost;
  double rating_kost;
  int jumlahrating_kost;

  KostDummyModel(
      this.picture_kost,
      this.type_kost,
      this.name_kost,
      this.location_kost,
      this.price_kost,
      this.rating_kost,
      this.jumlahrating_kost);

  String get getPicture {
    return picture_kost;
  }

  String get getType {
    return type_kost;
  }

  String get getName {
    return name_kost;
  }

  String get getLocation {
    return location_kost;
  }

  String get getPrice {
    return price_kost;
  }

  double get getRate {
    return rating_kost;
  }

  int get getJumlahrate {
    return jumlahrating_kost;
  }
}
