part of 'led_cubit.dart';

//@immutable
abstract class LedState {}

class LedInitial extends LedState {}

class DataGetting extends LedState {}

class DataGot extends LedState {}

class LedPressed extends LedState {}

class LedChanged extends LedState {}

class MotorPressed extends LedState {}

class MotorChanged extends LedState {}

class NavBarChanged extends LedState {}

class ContainerColorChanged extends LedState {}

class RGBColorChanging extends LedState {}

class RGBColorChanged extends LedState {}

class PhotoTaking extends LedState {}

class PhotoToked extends LedState {}

class JsonGet extends LedState {}

class JsonGot extends LedState {}
