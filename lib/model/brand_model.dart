import 'package:kindashop/core/xcontroller.dart';

class Brand {
  final String? id;
  final String? code;
  final String? title;
  final String? logo;

  final String? desc;
  final int? totalLike;
  final int? totalSale;
  final int? totalProduct;
  final int? totalRating;
  final double? rating;

  final int? createdAt; //yyyy-MM-dd HH:mm:ss
  final int? updatedAt; //yyyy-MM-dd HH:mm:ss
  final int? typee;
  final int? status;

  Brand(
      {this.id,
      this.code,
      this.title,
      this.logo,
      this.desc,
      this.totalLike,
      this.totalSale,
      this.totalProduct,
      this.totalRating,
      this.rating,
      this.createdAt,
      this.updatedAt,
      this.typee,
      this.status});

  Brand.fromData(Map<String, dynamic> data)
      : id = data['id_brand'],
        code = data['cd_brand'],
        title = data['title'],
        logo = data['logo'],
        desc = data['desc_brand'],
        totalLike = int.parse(data['total_like']),
        totalSale = int.parse(data['total_sale']),
        totalProduct = int.parse(data['total_product']),
        totalRating = int.parse(data['total_rating']),
        rating = double.parse("${data['rating']}"),
        createdAt = XController.getTimestampFromDate(data['date_created']),
        updatedAt = XController.getTimestampFromDate(data['date_updated']),
        typee = int.parse(data['typee']),
        status = int.parse(data['status']);

  Map<String, dynamic> toJson() {
    return {
      'id_brand': id,
      'cd_brand': code,
      'title': title,
      'logo': logo,
      'desc_brand': desc,
      'total_like': totalLike,
      'total_sale': totalSale,
      'total_product': totalProduct,
      'total_rating': totalRating,
      'rating': rating,
      'date_created': XController.convertStringDateFromTimestamp(createdAt)!,
      'date_updated': XController.convertStringDateFromTimestamp(updatedAt)!,
      'typee': typee,
      'status': status,
    };
  }
}
