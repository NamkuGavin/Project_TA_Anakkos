class UlasanDummyModel {
  String picture_ulasan;
  String nama_ulasan;
  double rating_ulasan;
  String tanggal_ulasan;
  String lamasewa_ulasan;
  String isi_ulasan;

  UlasanDummyModel(this.picture_ulasan, this.nama_ulasan, this.rating_ulasan,
      this.tanggal_ulasan, this.lamasewa_ulasan, this.isi_ulasan);

  String get getPicture {
    return picture_ulasan;
  }

  String get getName {
    return nama_ulasan;
  }

  double get getRate {
    return rating_ulasan;
  }

  String get getTanggal {
    return tanggal_ulasan;
  }

  String get getLama_sewa {
    return lamasewa_ulasan;
  }

  String get getUlasan {
    return isi_ulasan;
  }
}
