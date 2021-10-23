import 'package:kindashop/core/xcontroller.dart';

class Product {
  final String? id;
  final String? code;
  final String? name;
  final String? desc;

  final String? image1;
  final String? image2;
  final String? image3;

  final String? brand;
  final String? idcategory;
  final String? colors;
  final String? sizes;
  final int? stock;
  final String? unit;

  final String? currency;
  final double? price;
  final int? isrecomend;

  final int? totalike;
  final int? totalsell;
  final int? totalrating;
  final int? typee;
  final int? status;
  final double? rating;

  final String? link;
  final int? createdAt;
  final int? updatedAt;

  // variables
  int? qty;
  int? selected;

  String? selectedColor;
  String? selectedSize;

  Product(
      {this.id,
      this.code,
      this.name,
      this.desc,
      this.idcategory,
      this.brand,
      this.link,
      this.colors,
      this.sizes,
      this.stock,
      this.unit,
      this.image1,
      this.image2,
      this.image3,
      this.createdAt,
      this.updatedAt,
      this.currency,
      this.price,
      this.isrecomend,
      this.totalike,
      this.totalsell,
      this.totalrating,
      this.rating,
      this.typee,
      this.status,
      this.qty,
      this.selected,
      this.selectedColor,
      this.selectedSize});

  Product.fromData(Map<String, dynamic> data)
      : id = data['id_product'],
        code = data['cd_product'],
        name = data['nm_product'],
        image1 = data['image1'],
        image2 = data['image2'],
        image3 = data['image3'],
        currency = data['currency'],
        desc = data['desc_product'],
        isrecomend = int.parse("${data['is_recomend']}"),
        price = double.parse("${data['price']}"),
        brand = data['brand'],
        link = data['link'],
        idcategory = data['id_category'],
        colors = data['colors'],
        sizes = data['sizes'],
        stock = int.parse("${data['stock']}"),
        unit = data['unit'],
        totalike = int.parse("${data['total_like']}"),
        totalsell = int.parse("${data['total_sell']}"),
        totalrating = int.parse("${data['total_rating']}"),
        rating = double.parse("${data['rating']}"),
        typee = int.parse("${data['typee']}"),
        status = int.parse("${data['status']}"),
        qty = int.parse("${data['qty'] ?? '0'}"),
        selected = int.parse("${data['selected'] ?? '0'}"),
        selectedColor = "${data['selected_color'] ?? ''}",
        selectedSize = "${data['selected_size'] ?? ''}",
        createdAt = XController.getTimestampFromDate(data['date_created']),
        updatedAt = XController.getTimestampFromDate(data['date_updated']);

  Map<String, dynamic> toJson() {
    return {
      'id_product': id,
      'cd_product': code,
      'nm_product': name,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'currency': currency,
      'desc_product': desc,
      'is_recomend': isrecomend,
      'id_category': idcategory,
      'colors': colors,
      'sizes': sizes,
      'stock': stock,
      'unit': unit,
      'price': price,
      'brand': brand,
      'link': link,
      'total_like': totalike,
      'total_sell': totalsell,
      'total_rating': totalrating,
      'rating': rating,
      'typee': typee,
      'status': status,
      'qty': qty,
      'selected': selected,
      'selected_color': selectedColor,
      'selected_size': selectedSize,
      'date_created': XController.convertStringDateFromTimestamp(createdAt)!,
      'date_updated': XController.convertStringDateFromTimestamp(updatedAt)!,
    };
  }
}

/*
"id_product": "6",
                    "cd_product": "MYN_LOC201",
                    "nm_product": "LOCOMOTIVE T-Shirt, Men Black & Grey Slim",
                    "desc_product": "LOCOMOTIVE\r\nMen Black & Grey Slim Fit Checked Casual Shirt Black and grey checked casual shirt, has a spread collar, long roll-up sleeves, button placket, curved hem, and 1 patch pocket\r\n\r\nSize & Fit\r\nSlim fit\r\nThe model (height 6') is wearing a size 40\r\n\r\nMaterial & Care\r\nCotton\r\nMachine-wash\r\n\r\nSpecifications\r\nSleeve Length\r\nLong Sleeves\r\nCollar\r\nSpread Collar\r\nFit\r\nSlim Fit\r\nPrint or Pattern Type\r\nOther Checks\r\nOccasion\r\nCasual\r\nLength\r\nRegular\r\nHemline\r\nCurved\r\nPlacket\r\nButton Placket",
                    "brand": "MYNTRA",
                    "id_category": "2",
                    "colors": "BLACK#WHITE",
                    "sizes": "39#40#41#42#43#44#45",
                    "stock": "10",
                    "unit": "PIECES",
                    "rating": "0",
                    "link_product": "https://www.myntra.com/shirts/locomotive/locomotive-men-black--grey-slim-fit-checked-casual-shirt/10341699/buy",
                    "image1": "https://assets.myntassets.com/h_1440,q_90,w_1080/v1/assets/images/productimage/2019/7/27/110eefa8-e43b-4c42-85f7-83592dc9c9701564175877424-1.jpg",
                    "image2": "https://assets.myntassets.com/h_1440,q_90,w_1080/v1/assets/images/productimage/2019/7/27/e30af43e-5219-494e-bdb1-60b1c983c8f11564175877519-3.jpg",
                    "image3": "https://assets.myntassets.com/h_1440,q_90,w_1080/v1/assets/images/productimage/2019/7/27/110eefa8-e43b-4c42-85f7-83592dc9c9701564175877424-1.jpg",
                    "currency": "USD",
                    "price": "12",
                    "is_recomend": "0",
                    "total_like": "0",
                    "total_sell": "0",
                    "total_rating": "0",
                    "date_created": "2021-04-26 15:17:33",
                    "date_updated": "2021-04-26 15:17:33",
                    "typee": "1",
                    "status": "1"
 */