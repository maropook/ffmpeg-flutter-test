class YahooApi {
  late ResultInfo resultInfo;
  late List<Feature> feature;

  YahooApi({required this.resultInfo, required this.feature});

  YahooApi.fromJson(Map<String, dynamic> json) {
    resultInfo = (json['ResultInfo'] != null
        ? new ResultInfo.fromJson(json['ResultInfo'])
        : null)!;
    if (json['Feature'] != null) {
      feature = <Feature>[];
      json['Feature'].forEach((v) {
        feature.add(new Feature.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ResultInfo'] = this.resultInfo.toJson();
    data['Feature'] = this.feature.map((v) => v.toJson()).toList();
    return data;
  }
}

class ResultInfo {
  late int count;
  late int total;
  late int start;
  late int status;
  late String description;
  late String copyright;
  late double latency;

  ResultInfo(
      {required this.count,
      required this.total,
      required this.start,
      required this.status,
      required this.description,
      required this.copyright,
      required this.latency});

  ResultInfo.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    total = json['Total'];
    start = json['Start'];
    status = json['Status'];
    description = json['Description'];
    copyright = json['Copyright'];
    latency = json['Latency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['Total'] = this.total;
    data['Start'] = this.start;
    data['Status'] = this.status;
    data['Description'] = this.description;
    data['Copyright'] = this.copyright;
    data['Latency'] = this.latency;
    return data;
  }
}

class Feature {
  late String id;
  late String gid;
  late String name;
  late Geometry geometry;
  late List<String> category;
  late String description;
  late List<Style> style;
  late Property property;

  Feature(
      {required this.id,
      required this.gid,
      required this.name,
      required this.geometry,
      required this.category,
      required this.description,
      required this.style,
      required this.property});

  Feature.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    gid = json['Gid'];
    name = json['Name'];
    geometry = (json['Geometry'] != null
        ? new Geometry.fromJson(json['Geometry'])
        : null)!;
    category = json['Category'].cast<String>();
    description = json['Description'];
    if (json['Style'] != null) {
      style = new List<Style>.empty();
      json['Style'].forEach((v) {
        style.add(new Style.fromJson(v));
      });
    }
    property = (json['Property'] != null
        ? new Property.fromJson(json['Property'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Gid'] = this.gid;
    data['Name'] = this.name;
    data['Geometry'] = this.geometry.toJson();
    data['Category'] = this.category;
    data['Description'] = this.description;
    data['Style'] = this.style.map((v) => v.toJson()).toList();
    data['Property'] = this.property.toJson();
    return data;
  }
}

class Style {
  late String type;

  Style({required this.type});

  Style.fromJson(Map<String, dynamic> json) {
    type = json['Count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    return data;
  }
}

class Geometry {
  late String type;
  late String coordinates;

  Geometry({required this.type, required this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    coordinates = json['Coordinates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = this.type;
    data['Coordinates'] = this.coordinates;
    return data;
  }
}

class Property {
  late String uid;
  late String cassetteId;
  late String yomi;
  late Country country;
  late String address;
  late String governmentCode;
  late String addressMatchingLevel;
  late String tel1;
  late List<Genre> genre;
  late List<Station> station;
  late String leadImage;
  late String parkingFlag;
  late String couponFlag;
  late String smartPhoneCouponFlag;
  late List<Coupon> coupon;
  late String keepCount;
  late List<Area> area;

  Property(
      {required this.uid,
      required this.cassetteId,
      required this.yomi,
      required this.country,
      required this.address,
      required this.governmentCode,
      required this.addressMatchingLevel,
      required this.tel1,
      required this.genre,
      required this.station,
      required this.leadImage,
      required this.parkingFlag,
      required this.couponFlag,
      required this.smartPhoneCouponFlag,
      required this.coupon,
      required this.keepCount,
      required this.area});

  Property.fromJson(Map<String, dynamic> json) {
    uid = json['Uid'];
    cassetteId = json['CassetteId'];
    yomi = json['Yomi'];
    country = (json['Country'] != null
        ? new Country.fromJson(json['Country'])
        : null)!;
    address = json['Address'];
    governmentCode = json['GovernmentCode'];
    addressMatchingLevel = json['AddressMatchingLevel'];
    tel1 = json['Tel1'];
    if (json['Genre'] != null) {
      genre = <Genre>[];
      json['Genre'].forEach((v) {
        genre.add(new Genre.fromJson(v));
      });
    }
    if (json['Station'] != null) {
      station = <Station>[];
      json['Station'].forEach((v) {
        station.add(new Station.fromJson(v));
      });
    }
    if (json['LeadImage'] != null) {
      leadImage = json['LeadImage'];
    }
    if (json['ParkingFlag'] != null) {
      parkingFlag = json['ParkingFlag'];
    }
    if (json['CouponFlag'] != null) {
      couponFlag = json['CouponFlag'];
    }
    smartPhoneCouponFlag = json['SmartPhoneCouponFlag'];
    if (json['Coupon'] != null) {
      coupon = <Coupon>[];
      json['Coupon'].forEach((v) {
        coupon.add(new Coupon.fromJson(v));
      });
    }
    keepCount = json['KeepCount'];
    if (json['Area'] != null) {
      area = <Area>[];
      json['Area'].forEach((v) {
        area.add(new Area.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Uid'] = this.uid;
    data['CassetteId'] = this.cassetteId;
    data['Yomi'] = this.yomi;
    data['Country'] = this.country.toJson();
    data['Address'] = this.address;
    data['GovernmentCode'] = this.governmentCode;
    data['AddressMatchingLevel'] = this.addressMatchingLevel;
    data['Tel1'] = this.tel1;
    data['Genre'] = this.genre.map((v) => v.toJson()).toList();
    data['Station'] = this.station.map((v) => v.toJson()).toList();
    data['LeadImage'] = this.leadImage;
    data['ParkingFlag'] = this.parkingFlag;
    data['CouponFlag'] = this.couponFlag;
    data['SmartPhoneCouponFlag'] = this.smartPhoneCouponFlag;
    data['Coupon'] = this.coupon.map((v) => v.toJson()).toList();
    data['KeepCount'] = this.keepCount;
    data['Area'] = this.area.map((v) => v.toJson()).toList();
    return data;
  }
}

class Area {
  late String code;
  late String name;

  Area({required this.code, required this.name});

  Area.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    return data;
  }
}

class Genre {
  late String code;
  late String name;

  Genre({required this.code, required this.name});

  Genre.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    return data;
  }
}

class Country {
  late String code;
  late String name;

  Country({required this.code, required this.name});

  Country.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    return data;
  }
}

class Station {
  late String id;
  late String subId;
  late String name;
  late String railway;
  late String exit;
  late String exitId;
  late String distance;
  late String time;
  late Geometry geometry;

  Station(
      {required this.id,
      required this.subId,
      required this.name,
      required this.railway,
      required this.exit,
      required this.exitId,
      required this.distance,
      required this.time,
      required this.geometry});

  Station.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    subId = json['SubId'];
    name = json['Name'];
    railway = json['Railway'];
    exit = json['Exit'];
    exitId = json['ExitId'];
    distance = json['Distance'];
    time = json['Time'];
    geometry = (json['Geometry'] != null
        ? new Geometry.fromJson(json['Geometry'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['SubId'] = this.subId;
    data['Name'] = this.name;
    data['Railway'] = this.railway;
    data['Exit'] = this.exit;
    data['ExitId'] = this.exitId;
    data['Distance'] = this.distance;
    data['Time'] = this.time;
    data['Geometry'] = this.geometry.toJson();
    return data;
  }
}

class Coupon {
  late String name;
  late String pcUrl;
  late String mobileFlag;
  late String smartPhoneUrl;

  Coupon(
      {required this.name,
      required this.pcUrl,
      required this.mobileFlag,
      required this.smartPhoneUrl});

  Coupon.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    pcUrl = json['PcUrl'];
    mobileFlag = json['MobileFlag'];
    if (json['SmartPhoneUrl'] != null) {
      smartPhoneUrl = json['SmartPhoneUrl'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['PcUrl'] = this.pcUrl;
    data['MobileFlag'] = this.mobileFlag;
    data['SmartPhoneUrl'] = this.smartPhoneUrl;
    return data;
  }
}
