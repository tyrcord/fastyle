// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppPermissionsBlocState extends BlocState {
  final FastAppPermission trackingPermission;

  final FastAppPermission locationPermission;

  final FastAppPermission notificationPermission;

  final FastAppPermission cameraPermission;

  final FastAppPermission microphonePermission;

  final FastAppPermission photoLibraryPermission;

  final FastAppPermission contactsPermission;

  final FastAppPermission bluetoothPermission;

  FastAppPermissionsBlocState({
    super.isInitializing,
    super.isInitialized,
    FastAppPermission? trackingPermission,
    FastAppPermission? locationPermission,
    FastAppPermission? notificationPermission,
    FastAppPermission? cameraPermission,
    FastAppPermission? microphonePermission,
    FastAppPermission? photoLibraryPermission,
    FastAppPermission? contactsPermission,
    FastAppPermission? bluetoothPermission,
  })  : trackingPermission = trackingPermission ?? FastAppPermission.unknown,
        locationPermission = locationPermission ?? FastAppPermission.unknown,
        notificationPermission =
            notificationPermission ?? FastAppPermission.unknown,
        cameraPermission = cameraPermission ?? FastAppPermission.unknown,
        microphonePermission =
            microphonePermission ?? FastAppPermission.unknown,
        photoLibraryPermission =
            photoLibraryPermission ?? FastAppPermission.unknown,
        contactsPermission = contactsPermission ?? FastAppPermission.unknown,
        bluetoothPermission = bluetoothPermission ?? FastAppPermission.unknown;

  @override
  FastAppPermissionsBlocState copyWith({
    bool? isInitializing,
    bool? isInitialized,
    FastAppPermission? trackingPermission,
    FastAppPermission? locationPermission,
    FastAppPermission? notificationPermission,
    FastAppPermission? cameraPermission,
    FastAppPermission? microphonePermission,
    FastAppPermission? photoLibraryPermission,
    FastAppPermission? contactsPermission,
    FastAppPermission? bluetoothPermission,
  }) {
    return FastAppPermissionsBlocState(
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      trackingPermission: trackingPermission ?? this.trackingPermission,
      locationPermission: locationPermission ?? this.locationPermission,
      notificationPermission:
          notificationPermission ?? this.notificationPermission,
      cameraPermission: cameraPermission ?? this.cameraPermission,
      microphonePermission: microphonePermission ?? this.microphonePermission,
      photoLibraryPermission:
          photoLibraryPermission ?? this.photoLibraryPermission,
      contactsPermission: contactsPermission ?? this.contactsPermission,
      bluetoothPermission: bluetoothPermission ?? this.bluetoothPermission,
    );
  }

  @override
  FastAppPermissionsBlocState clone() => copyWith();

  @override
  FastAppPermissionsBlocState merge(covariant FastAppPermissionsBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      trackingPermission: model.trackingPermission,
      locationPermission: model.locationPermission,
      notificationPermission: model.notificationPermission,
      cameraPermission: model.cameraPermission,
      microphonePermission: model.microphonePermission,
      photoLibraryPermission: model.photoLibraryPermission,
      contactsPermission: model.contactsPermission,
      bluetoothPermission: model.bluetoothPermission,
    );
  }

  @override
  List<Object?> get props => [
        trackingPermission,
        locationPermission,
        notificationPermission,
        cameraPermission,
        microphonePermission,
        photoLibraryPermission,
        contactsPermission,
        bluetoothPermission,
      ];
}
