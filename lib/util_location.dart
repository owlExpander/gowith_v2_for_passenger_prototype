import 'package:location/location.dart';

Location location = Location();
late double? lat;
late double? lng;
int nCheckCnt = 0;

checkCurrentLocation() async {
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  LocationData locationData = await location.getLocation();
  lat = locationData.latitude;
  lng = locationData.longitude;

  if (lat != null) {
    nCheckCnt++;
  }
}