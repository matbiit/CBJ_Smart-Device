import 'package:SmartDeviceDart/core/device_information.dart';
import 'package:SmartDeviceDart/core/helper_methods.dart';
import 'package:SmartDeviceDart/core/permissions/permissions_manager.dart';
import 'package:SmartDeviceDart/features/smart_device/application/usecases/button_object_u/button_object_local_u.dart';
import 'package:SmartDeviceDart/features/smart_device/application/usecases/cloud_value_change_u/cloud_value_change_u.dart';
import 'package:SmartDeviceDart/features/smart_device/application/usecases/devices_pin_configuration_u/pin_information.dart';
import 'package:SmartDeviceDart/features/smart_device/application/usecases/wish_classes_u/off_wish_u.dart';
import 'package:SmartDeviceDart/features/smart_device/application/usecases/wish_classes_u/on_wish_u.dart';
import 'package:SmartDeviceDart/features/smart_device/domain/entities/core_e/enums_e.dart';
import 'package:SmartDeviceDart/features/smart_device/infrastructure/datasources/core_d/manage_physical_components/device_pin_manager.dart';
import 'package:SmartDeviceDart/features/smart_device/infrastructure/repositories/smart_device_objects_r/smart_device_objects_r.dart';

///  The super base class of all the smart device class and smart device abstract classes
abstract class SmartDeviceBaseAbstract {
  SmartDeviceBaseAbstract(this.uuid, this.smartInstanceName, int onOffPinNumber,
      {int onOffButtonPinNumber}) {
    onOffPin =
        onOffPinNumber == null ? null : addPinToGpioPinList(onOffPinNumber);

    //  If pin number was inserted and it exists than listen to button press
    if (onOffButtonPinNumber != null) {
      onOffButtonPin = addPinToGpioPinList(onOffButtonPinNumber);

      if (onOffButtonPin != null) {
        listenToButtonPressed();
      }
    }
    _cloudValueChangeU = CloudValueChangeU.getCloudValueChangeU();
  }

  ///  Save data about the device, remote or local IP or pin number
  DeviceInformation deviceInformation =
      LocalDevice('This is the mac Address', 'This is the name of the device');

  ///  Default name of the device to show in the app
  String smartInstanceName;

  ///  Mac addresses of the physical device
  final String uuid;

  ///  Permissions of all the users to this device
  Map<String, PermissionsManager> devicePermissions;

  ///  Power consumption of the device
  double watts;

  ///  How much time the computer is on since last boot
  DateTime computerActiveTime;

  ///  How much time the smart device was active (Doing action) total
  DateTime activeTimeTotal;

  ///  Log of all the actions the device was and will do
  Map<DateTime, Function> activitiesLog;

  ///  Save the device state on = true, off = false of onOffPin
  bool onOff = false;

  ///  Number of on or off pin
  PinInformation onOffPin;

  ///  Pin for the button that control the onOffPin
  PinInformation onOffButtonPin;

  ///  Save all the gpio pins that this instance is using
  final List<PinInformation> _gpioPinList = <PinInformation>[];

  CloudValueChangeU _cloudValueChangeU;

  ///  The type of the smart device Light blinds etc
  DeviceType smartDeviceType;

  //  Getters

  ///  Get smart device type
  DeviceType getDeviceType() => smartDeviceType;

  Future<String> getIp() async {
    return await getIps();
  }

  ///  Get the list of gpio pin of the device
  List<PinInformation> getGpioPinList() {
    return _gpioPinList;
  }


  Future<String> getUuid() {
    return SmartDeviceObjectsR.getUuid();
  }


  bool getDeviceState() => onOff;


  //  Setters


  ///  Turn on the device basic action
  String _SetOn(PinInformation pinNumber) {
//    if (deviceInformation == null) {
//      return 'Device information is missing, can't turn on';
//    }
    OnWishU.setOn(deviceInformation, pinNumber);
    onOff = true;
    return 'Turn on successfully';
  }

  ///  Turn off the device basic action
  String _SetOff(PinInformation pinNumber) {
//    if (deviceInformation == null) {
//      return 'Device information is missing, can't turn off';
//    }
    OffWishU.setOff(deviceInformation, pinNumber);
    onOff = false;
    return 'Turn off successfully';
  }


  void setDeviceType(DeviceType deviceType) => smartDeviceType = deviceType;


  ///  Turn device pin to the opposite state
  String _SetChangeOppositeToState(PinInformation pinNumber) {
    return onOff ? _SetOff(onOffPin) : _SetOn(onOffPin);
  }


  //  More functions


  ///  Add gpio pin for this device
  PinInformation addPinToGpioPinList(int pinNumber) {
    //  Check if pin is free to be taken, if not return negative number with error number
    final PinInformation gpioPin =
        DevicePinListManager().getGpioPin(this, pinNumber);
    if (gpioPin == null) {
      return null;
    }
    _gpioPinList.add(gpioPin);
    return gpioPin;
  }

  ///  Return PossibleWishes object if string wish exist (in general) else return null
  WishEnum convertWishStringToWishesObject(String wish) {
    for (final WishEnum possibleWish in WishEnum.values) {
      print('Wish value ${EnumHelper.wishEnumToString(possibleWish)}');
      if (EnumHelper.wishEnumToString(possibleWish) == wish) {
        return possibleWish; //  If wish exist return the PossibleWish object
      }
    }
    return null;
  }

  ///  Check if wish exist at all if true than check if base abstract have this wish and if true than execute it
  Future<String> executeWishString(String wishString,
      WishSourceEnum wishSourceEnum) async {
    final WishEnum wish = convertWishStringToWishesObject(wishString);
    return executeWish(wish, wishSourceEnum);
  }

  Future<String> executeWish(WishEnum wishEnum,
      WishSourceEnum wishSourceEnum) async {
    return wishInBaseClass(wishEnum, wishSourceEnum);
  }

  ///  All the wishes that are legit to execute from the base class
  String wishInBaseClass(WishEnum wish, WishSourceEnum wishSourceEnum) {
    if (wish == null) return 'Your wish does not exist';

    final bool deviceStatus = getDeviceState();
    String resultOfTheWish;

    switch (wish) {
      case WishEnum.SOff:
        if (onOffPin == null) {
          return 'Cant turn off this pin: $onOffPin Number';
        }
        resultOfTheWish = _SetOff(onOffPin);
        break;
      case WishEnum.SOn:
        if (onOffPin == null) {
          return 'Cant turn on this pin: $onOffPin Number';
        }
        resultOfTheWish = _SetOn(onOffPin);
        break;
      case WishEnum.SChangeState:
        if (onOffPin == null) {
          return 'Cant chane pin to the opposite state: $onOffPin Number';
        }
        resultOfTheWish = _SetChangeOppositeToState(onOffPin);
        break;
      case WishEnum.GState:
        return deviceStatus.toString();
      default:
        return 'Your wish does not exist for this class';
    }

    if (deviceStatus != getDeviceState() &&
        wishSourceEnum != WishSourceEnum.FireBase) {
      updateCloudValue(getDeviceState().toString());
    }

    return resultOfTheWish;
  }

  void updateCloudValue(String value) {
    _cloudValueChangeU ??= CloudValueChangeU.getCloudValueChangeU();
    if (_cloudValueChangeU != null) {
      _cloudValueChangeU.updateDocument(smartInstanceName, value);
    }
  }

  ///  Listen to button press
  Future<void> listenToButtonPressed() async {
    ButtonObjectLocalU().buttonPressed(this, onOffButtonPin, onOffPin);
  }
}
