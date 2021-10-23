import 'package:kindashop/core/xcontroller.dart';

class Category {
  final String? id;
  final String? name;
  final String? desc;
  final String? image;

  final int? createdAt; //yyyy-MM-dd HH:mm:ss
  final int? updatedAt; //yyyy-MM-dd HH:mm:ss
  final int? typee;
  final int? status;

  Category(
      {this.id,
      this.name,
      this.desc,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.typee,
      this.status});

  Category.fromData(Map<String, dynamic> data)
      : id = "${data['id_category']}",
        name = data['nm_category'],
        desc = data['desc_category'],
        image = data['image'],
        createdAt = XController.getTimestampFromDate(data['date_created']),
        updatedAt = XController.getTimestampFromDate(data['date_updated']),
        typee = int.parse(data['typee']),
        status = int.parse(data['status']);

  Map<String, dynamic> toJson() {
    return {
      'id_category': id,
      'nm_category': name,
      'desc_category': desc,
      'image': image,
      'date_created': XController.convertStringDateFromTimestamp(createdAt)!,
      'date_updated': XController.convertStringDateFromTimestamp(updatedAt)!,
      'typee': typee,
      'status': status,
    };
  }

  void newMethod() {
    final x = 2;
    final u = '234';
    final qioefhqeiogfqnhe = 'adsfdsfdsfdsgdsgds';
    final i = 'i';
    //empty
  }
}
