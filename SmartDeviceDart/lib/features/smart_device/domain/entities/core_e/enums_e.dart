


enum DeviceType {
  Light, //  Light ON/OFF
  DynamicLight, //  Light with brightness 0% to 100%
  Blinds,
  Thermostat,
  Fan,
  AirConditioner,
  Camera,
  Fridge,
  Toaster,
  CoffeeMachine,
  SmartTV,
  RCAirplane,
  RCCar,
  Speakers,
  Roomba, //  Cleaning robot
  Irrigation, //  Give water to plants
  SmartBed,
  AnimalTracker,
  SmartCar
}

///  List of all the wishes that can be made
enum WishEnum {
  SOn, //  Turn the device on
  SOff, //  Turn the device off
  SChangeState, //  Change device state to the opposite one
  SDynamic, //  Set Dynamic Value
  ODynamic, //  Open connection to change dynamic value
  SMovement, //  Open connection to change dynamic value
  GState, //  Get device state on/off
  SBlindsUp, //  Turn the blinds up
  SBlindsDown, //  Turn the blinds Down
  SBlindsStop //  Stop the blinds
}

/// List of all the sources
enum WishSourceEnum {
  ServerRequest,
  FireBase,
  ButtonPress,
  VoiceAssistant,
  ScheduleRequests,
}

///  List of all physical devices types
enum PhysicalDeviceType { NanoPiDuo2, NanoPiNeo, NanoPiNeo2, RaspberryPi }

enum RaspberryPiType {
  Raspberry_Pi_3_Model_B_Rev_1_2,
  Raspberry_Pi_4_Model_B_Rev_1_4
}

class EnumHelper {
  ///  Convert deviceType to string
  static String deviceTypeToString(DeviceType deviceType) {
    return deviceType.toString().replaceAll('DeviceType.', '');
  }

  static DeviceType stringToDeviceType(String deviceTypeString) {
    for (final DeviceType deviceType in DeviceType.values) {
      if (deviceTypeToString(deviceType) == deviceTypeString) {
        return deviceType;
      }
    }
    return null;
  }

  ///  Convert Raspberry Pi type to string
  static String RaspberryPiTypeToString(RaspberryPiType raspberryPiType) {
    return raspberryPiType.toString().replaceAll('RaspberryPiType.', '');
  }

  static RaspberryPiType stringToRaspberryPiType(String raspberryPiTypeString) {
    for (final RaspberryPiType raspberryPiType in RaspberryPiType.values) {
      if (RaspberryPiTypeToString(raspberryPiType) == raspberryPiTypeString) {
        return raspberryPiType;
      }
    }
    return null;
  }

  ///  Convert wishEnum to string
  static String wishEnumToString(WishEnum wishEnum) {
    return wishEnum.toString().replaceAll('WishEnum.', '');
  }

  ///  Convert string to wishEnum
  static WishEnum stringToWishEnum(String wishEnumString) {
    for (final WishEnum wishEnum in WishEnum.values) {
      if (wishEnumToString(wishEnum) == wishEnumString) {
        return wishEnum;
      }
    }
    return null;
  }

  ///  Convert physicalDeviceType to string
  static String physicalDeviceTypeToString(PhysicalDeviceType deviceType) {
    return deviceType.toString().replaceAll('PhysicalDeviceType.', '');
  }
}
