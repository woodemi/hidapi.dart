import 'dart:ffi';
import 'dart:io';

import 'package:hidapi/hidapi.dart';
import 'package:hidapi/utils.dart';

final DynamicLibrary Function() loadLibrary = () {
  if (Platform.isMacOS) {
    return DynamicLibrary.open('${Directory.current.path}/hidapi/libhidapi-0.10.1.dylib');
  }
  return null;
};

final hidApi = HidApi(loadLibrary());

void main(List<String> arguments) {
  if (hidApi.hid_init() != 0) {
    print('hid_init error');
    return;
  }
  print('hid_init success');

  var deviceListPtr = hidApi.hid_enumerate(0, 0);
  try {
    interateHidDevice(deviceListPtr).forEach(print);
  } finally {
    hidApi.hid_free_enumeration(deviceListPtr);
  }

  if (hidApi.hid_exit() != 0) {
    print('hid_exit error');
    return;
  }
  print('hid_exit success');
}

Iterable<Map<String, dynamic>> interateHidDevice(Pointer<hid_device_info> deviceListPtr) sync* {
  for (var devicePtr = deviceListPtr; devicePtr != nullptr; devicePtr = devicePtr.ref.next) {
    var dev = devicePtr.ref;
    yield {
      'vendorId': dev.vendor_id,
      'productId':dev.product_id,
      'path': fromChar(dev.path),
      'serialNumber': fromWChar(dev.serial_number),
      'usagePage': dev.usage_page,
      'usage': dev.usage,
      'Manufacturer': fromWChar(dev.manufacturer_string),
      'Product': fromWChar(dev.product_string),
    };
  }
}
