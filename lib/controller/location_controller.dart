import 'dart:async';

import 'package:amanuel_glass/model/address_model.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController implements GetxService {
  final latitude = 'Getting Latitude..'.obs;
  final longitude = 'Getting Longitude..'.obs;
  final address = 'Unkown Location...'.obs;
  late StreamSubscription<Position> streamSubscription;

  AddressModel _addressModel = AddressModel(
    street: '',
    administrativeArea: '',
    name: '',
    isoCountryCode: '',
    country: '',
    postalCode: '',
    subAdministrativeArea: '',
    locality: '',
    subLocality: '',
    thoroughfare: '',
    subThoroughfare: '',
  );

  AddressModel get addressModel => _addressModel;

  @override
  void onInit() async {
    super.onInit();
    getLocation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    streamSubscription.cancel();
  }

  Future<void> getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } catch (e) {
        print('Error checking location service: $e');
        showCustomSnackBar(
            'Error checking location services. Please check app permissions.');
        return;
      }

      if (!serviceEnabled) {
        showCustomSnackBar(
            'Location services are disabled. Please enable location');
        await Geolocator.openLocationSettings();
        return;
      }

      // Check permissions
      try {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            showCustomSnackBar('Location permissions are denied');
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          showCustomSnackBar('Location permissions are permanently denied.');
          return;
        }

        // Get current position
        Position position = await Geolocator.getCurrentPosition();

        latitude.value = 'Latitude : ${position.latitude}';
        longitude.value = 'Longitude : ${position.longitude}';
        getAddressFromLatLang(position);
      } catch (e) {
        print('Error getting location: $e');
        showCustomSnackBar('Error getting location. Please try again.');
      }
    } catch (e) {
      print('General error in getLocation: $e');
      showCustomSnackBar('An error occurred while getting location');
    }
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    address.value =
        '${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.isoCountryCode ?? ''}';

    _addressModel = AddressModel(
      street: place.street ?? '',
      administrativeArea: place.administrativeArea ?? '',
      name: place.name ?? '',
      isoCountryCode: place.isoCountryCode ?? '',
      country: place.country ?? '',
      postalCode: place.postalCode ?? '',
      subAdministrativeArea: place.subAdministrativeArea ?? '',
      locality: place.locality ?? '',
      subLocality: place.subLocality ?? '',
      thoroughfare: place.thoroughfare ?? '',
      subThoroughfare: place.subThoroughfare ?? '',
    );

    update();
  }
}
