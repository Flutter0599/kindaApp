import 'package:kindashop/core/xcontroller.dart';

class Service {
  final String? id;
  final String? name;
  final String? logo;
  final String? web;

  final int? createdAt; //yyyy-MM-dd HH:mm:ss
  final int? updatedAt; //yyyy-MM-dd HH:mm:ss
  final int? typee;
  final int? status;

  Service(
      {this.id,
      this.name,
      this.logo,
      this.web,
      this.createdAt,
      this.updatedAt,
      this.typee,
      this.status});

  Service.fromData(Map<String, dynamic> data)
      : id = "${data['id_service']}",
        name = data['nm_service'],
        logo = data['logo'],
        web = data['website'],
        createdAt = XController.getTimestampFromDate(data['date_created']),
        updatedAt = XController.getTimestampFromDate(data['date_updated']),
        typee = int.parse(data['typee']),
        status = int.parse(data['status']);

  Map<String, dynamic> toJson() {
    return {
      'id_service': id,
      'nm_service': name,
      'logo': logo,
      'website': web,
      'date_created': XController.convertStringDateFromTimestamp(createdAt)!,
      'date_updated': XController.convertStringDateFromTimestamp(updatedAt)!,
      'typee': typee,
      'status': status,
    };
  }
}
