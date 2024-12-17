class AddressModel {
  final String name;
  final String street;
  final String isoCountryCode;
  final String country;
  final String postalCode;
  final String administrativeArea;
  final String subAdministrativeArea;
  final String locality;
  final String subLocality;
  final String thoroughfare;
  final String subThoroughfare;

  AddressModel({
    this.name = '',
    this.street = 'Unkown Location',
    this.isoCountryCode = '',
    this.country = 'Ethiopia',
    this.postalCode = '',
    this.administrativeArea = '',
    this.subAdministrativeArea = '',
    this.locality = '',
    this.subLocality = '',
    this.thoroughfare = '',
    this.subThoroughfare = '',
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json['Name'] == null ? '' : json['Name'],
      street: json['Street'] == null ? '' : json['Street'],
      isoCountryCode:
          json['ISO Country Code'] == null ? '' : json['ISO Country Code'],
      country: json['Country'] == null ? '' : json['Country'],
      postalCode: json['Postal code'] == null ? '' : json['Postal code'],
      administrativeArea: json['Administrative area'] == null
          ? ''
          : json['Administrative area'],
      subAdministrativeArea: json['Subadministrative area'] == null
          ? ''
          : json['Subadministrative area'],
      locality: json['Locality'] == null ? '' : json['Locality'],
      subLocality: json['Sublocality'] == null ? '' : json['Sublocality'],
      thoroughfare: json['Thoroughfare'] == null ? '' : json['Thoroughfare'],
      subThoroughfare:
          json['Subthoroughfare'] == null ? '' : json['Subthoroughfare'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name == null ? '' : name,
      'Street': street == null ? '' : street,
      'ISO Country Code': isoCountryCode == null ? '' : isoCountryCode,
      'Country': country == null ? '' : country,
      'Postal code': postalCode == null ? '' : postalCode,
      'Administrative area':
          administrativeArea == null ? '' : administrativeArea,
      'Subadministrative area':
          subAdministrativeArea == null ? '' : subAdministrativeArea,
      'Locality': locality == null ? '' : locality,
      'Sublocality': subLocality == null ? '' : subLocality,
      'Thoroughfare': thoroughfare == null ? '' : thoroughfare,
      'Subthoroughfare': subThoroughfare == null ? '' : subThoroughfare,
    };
  }
}
