// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Darwin Camera App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final openDarwinCamerButton = find.byValueKey("OpenDarwinCameraButton");
    final cameraStream = find.byValueKey("CameraStream");
    final headerCancelButton = find.byValueKey("HeaderCancelButton");
    final captureButton = find.byValueKey("CaptureButton");
    final cameraTogglebutton = find.byValueKey("CameraToggleButton");

    final capturedImageWidget = find.byValueKey("RenderCapturedImageWidget");
    final capturedImageCancelButton =
        find.byValueKey("CapturedImageCancelButton");

    ///
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    testOpenCameraStream() async {
      /// Tap on open camera button
      await driver.tap(openDarwinCamerButton);

      /// Open camera Stream;
      await driver.waitFor(cameraStream);
    }

    testCloseCameraStream() async {
      /// Close camera Stream;
      await driver.tap(headerCancelButton);

      /// Wait for Camera Stream to be gone from the screen.
      await driver.waitForAbsent(cameraStream);
    }

    testCaptureImage() async {
      /// Capture Image;
      await driver.tap(captureButton);

      /// Wait for new widget.
      await driver.waitFor(capturedImageWidget);
      await driver.waitFor(capturedImageCancelButton);
    }

    testDiscardImage() async {
      /// Discard Image.
      await driver.tap(capturedImageCancelButton);
      print("IMAGE DISCARDED");

      /// Wait if CaptureImage widget disappers
      await driver.waitForAbsent(capturedImageWidget);
    }

    ///
    ///
    ///
    ///
    test('Camera Stream is rendered and Cancel button is working', () async {
      await testOpenCameraStream();

      await testCloseCameraStream();
    });

    test('Camera Stream is rendered and Toggle button is working', () async {
      await testOpenCameraStream();

      /// Switch Camera
      await driver.tap(cameraTogglebutton);

      /// Close Camera
      await testCloseCameraStream();
    });

    test('Image is captured using second camera and discarded', () async {
      await testOpenCameraStream();

      /// Switch Camera
      await driver.tap(cameraTogglebutton);

      ///
      await testCaptureImage();

      await testDiscardImage();

      ///
      /// Close Camera stream
      await testCloseCameraStream();
    });

    test('Image is captured using primary camera and discarded', () async {
      await testOpenCameraStream();
      print("CAMERA OPENED");

      ///
      ///
      await testCaptureImage();
      print("IMAGE CAPTURED");

      ///
      ///
      await testDiscardImage();

      ///
      ///
      await testCloseCameraStream();
    });
  });
}
