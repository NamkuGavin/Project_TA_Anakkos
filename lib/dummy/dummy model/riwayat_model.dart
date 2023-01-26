class RiwayatDummyModel {
  String picture_riwayat;
  String jenis_kostRiwayat;
  String nama_riwayat;
  String lokasi_riwayat;
  String tanggal_riwayat;
  String waktu_riwayat;
  String status_riwayat;
  String kapan_sewa;

  RiwayatDummyModel(
      this.picture_riwayat,
      this.jenis_kostRiwayat,
      this.nama_riwayat,
      this.lokasi_riwayat,
      this.tanggal_riwayat,
      this.waktu_riwayat,
      this.status_riwayat,
      this.kapan_sewa);

  String get getPicture {
    return picture_riwayat;
  }

  String get getJenis {
    return jenis_kostRiwayat;
  }

  String get getNama {
    return nama_riwayat;
  }

  String get getLokasi {
    return lokasi_riwayat;
  }

  String get getTanggal {
    return tanggal_riwayat;
  }

  String get getWaktu {
    return waktu_riwayat;
  }

  String get getStatus {
    return status_riwayat;
  }

  String get getKapansewa {
    return kapan_sewa;
  }
}
