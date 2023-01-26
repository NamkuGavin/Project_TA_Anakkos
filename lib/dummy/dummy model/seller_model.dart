class SellerDummyModel {
  String picture_kost_seller;
  String nama_kost_seller;
  String status_kost_seller;
  String rating_kost_seller;
  String tenant_kost_seller;

  SellerDummyModel(
      this.picture_kost_seller,
      this.nama_kost_seller,
      this.status_kost_seller,
      this.rating_kost_seller,
      this.tenant_kost_seller);

  String get getPicture {
    return picture_kost_seller;
  }

  String get getNama {
    return nama_kost_seller;
  }

  String get getRating {
    return rating_kost_seller;
  }

  String get getTenant {
    return tenant_kost_seller;
  }

  String get getStatus {
    return status_kost_seller;
  }
}
