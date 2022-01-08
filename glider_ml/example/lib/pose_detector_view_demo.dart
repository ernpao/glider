import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glider/glider.dart';
import 'package:glider_ml/glider_ml.dart';
import 'package:hover/hover.dart';

class PoseDetectorViewDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      theme: HoverThemeData.dark.data,
      child: Builder(builder: (context) {
        return Scaffold(
          body: PoseDetectorView(overlayBuilder: _processPose),
        );
      }),
    );
  }

  Widget _processPose(
    BuildContext context,
    Pose pose,
    Size imageSize,
    Size containerSize,
  ) {
    final skeleton = Skeleton.fromPoseDetector(pose, imageSize, containerSize);
    return CustomPaint(
      painter: SkeletonPainter(skeleton),
      size: containerSize,
    );
  }
}

class SkeletonPainter extends CustomPainter {
  final Skeleton skeleton;

  SkeletonPainter(this.skeleton);

  @override
  void paint(Canvas canvas, Size size) {
    print("Canvas W: ${size.width} H: ${size.height}");
    final points = skeleton.joints.map((j) => Offset(j.x, j.y)).toList();
    final lines = skeleton.segments;
    final paint = Paint();
    paint.color = Colors.green;

    paint.strokeWidth = 10;
    canvas.drawPoints(PointMode.points, points, paint);

    paint.strokeWidth = 2;
    for (final line in lines) {
      canvas.drawLine(
        Offset(
          line.jointA.asOffset.dx,
          line.jointA.asOffset.dy,
        ),
        Offset(
          line.jointB.asOffset.dx,
          line.jointB.asOffset.dy,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SkeletonJoint {
  final double x;
  final double y;
  final double z;
  final String name;

  SkeletonJoint(this.name, this.x, this.y, this.z);

  static const String kNose = "nose";
  static const String kLeftShoulder = "leftShoulder";
  static const String kRightShoulder = "rightShoulder";
  static const String kLeftElbow = "leftElbow";
  static const String kRightElbow = "rightElbow";
  static const String kLeftWrist = "leftWrist";
  static const String kRightWrist = "rightWrist";
  static const String kLeftHip = "leftHip";
  static const String kRightHip = "rightHip";
  static const String kLeftKnee = "leftKnee";
  static const String kRightKnee = "rightKnee";
  static const String kLeftAnkle = "leftAnkle";
  static const String kRightAnkle = "rightAnkle";

  /// The location of this joint on the source image.
  Point get asPoint => Point(x, y);
  Offset get asOffset => Offset(x, y);
}

class SkeletonSegment {
  final SkeletonJoint jointA;
  final SkeletonJoint jointB;
  SkeletonSegment(this.jointA, this.jointB);
}

class Skeleton {
  final SkeletonJoint nose;
  final SkeletonJoint leftShoulder;
  final SkeletonJoint rightShoulder;
  final SkeletonJoint leftElbow;
  final SkeletonJoint rightElbow;
  final SkeletonJoint leftWrist;
  final SkeletonJoint rightWrist;
  final SkeletonJoint leftHip;
  final SkeletonJoint rightHip;
  final SkeletonJoint leftKnee;
  final SkeletonJoint rightKnee;
  final SkeletonJoint leftAnkle;
  final SkeletonJoint rightAnkle;

  late SkeletonSegment leftUpperArm;
  late SkeletonSegment rightUpperArm;
  late SkeletonSegment leftForearm;
  late SkeletonSegment rightForearm;
  late SkeletonSegment leftUpperLeg;
  late SkeletonSegment rightUpperLeg;
  late SkeletonSegment clavicle;
  late SkeletonSegment leftSide;
  late SkeletonSegment rightSide;
  late SkeletonSegment hip;
  late SkeletonSegment leftLowerLeg;
  late SkeletonSegment rightLowerLeg;

  Skeleton(
    this.nose,
    this.leftShoulder,
    this.rightShoulder,
    this.leftElbow,
    this.rightElbow,
    this.leftWrist,
    this.rightWrist,
    this.leftHip,
    this.rightHip,
    this.leftKnee,
    this.rightKnee,
    this.leftAnkle,
    this.rightAnkle,
  ) {
    this.leftUpperArm = SkeletonSegment(leftShoulder, leftElbow);
    this.rightUpperArm = SkeletonSegment(rightShoulder, rightElbow);
    this.leftForearm = SkeletonSegment(leftElbow, leftWrist);
    this.rightForearm = SkeletonSegment(rightElbow, rightWrist);
    this.leftUpperLeg = SkeletonSegment(leftHip, leftKnee);
    this.rightUpperLeg = SkeletonSegment(rightHip, rightKnee);
    this.clavicle = SkeletonSegment(leftShoulder, rightShoulder);
    this.leftSide = SkeletonSegment(leftShoulder, leftHip);
    this.rightSide = SkeletonSegment(rightShoulder, rightHip);
    this.hip = SkeletonSegment(leftHip, rightHip);
    this.leftLowerLeg = SkeletonSegment(leftKnee, leftAnkle);
    this.rightLowerLeg = SkeletonSegment(rightKnee, rightAnkle);
  }

  List<SkeletonJoint> get joints => [
        this.nose,
        this.leftShoulder,
        this.rightShoulder,
        this.leftElbow,
        this.rightElbow,
        this.leftWrist,
        this.rightWrist,
        this.leftHip,
        this.rightHip,
        this.leftKnee,
        this.rightKnee,
        this.leftAnkle,
        this.rightAnkle,
      ];

  List<SkeletonSegment> get segments => [
        leftUpperArm,
        rightUpperArm,
        leftForearm,
        rightForearm,
        leftUpperLeg,
        rightUpperLeg,
        clavicle,
        leftSide,
        rightSide,
        hip,
        leftLowerLeg,
        rightLowerLeg,
      ];

  static Skeleton fromPoseDetector(
      Pose pose, Size imageSize, Size containerSize) {
    print("Image W: ${imageSize.width} H: ${imageSize.height}");

    var nose = SkeletonJoint(SkeletonJoint.kNose, 0, 0, 0);
    var leftShoulder = SkeletonJoint(SkeletonJoint.kLeftShoulder, 0, 0, 0);
    var rightShoulder = SkeletonJoint(SkeletonJoint.kRightShoulder, 0, 0, 0);
    var leftElbow = SkeletonJoint(SkeletonJoint.kLeftElbow, 0, 0, 0);
    var rightElbow = SkeletonJoint(SkeletonJoint.kRightElbow, 0, 0, 0);
    var leftWrist = SkeletonJoint(SkeletonJoint.kLeftWrist, 0, 0, 0);
    var rightWrist = SkeletonJoint(SkeletonJoint.kRightWrist, 0, 0, 0);
    var leftHip = SkeletonJoint(SkeletonJoint.kLeftHip, 0, 0, 0);
    var rightHip = SkeletonJoint(SkeletonJoint.kRightHip, 0, 0, 0);
    var leftKnee = SkeletonJoint(SkeletonJoint.kLeftKnee, 0, 0, 0);
    var rightKnee = SkeletonJoint(SkeletonJoint.kRightKnee, 0, 0, 0);
    var leftAnkle = SkeletonJoint(SkeletonJoint.kLeftAnkle, 0, 0, 0);
    var rightAnkle = SkeletonJoint(SkeletonJoint.kRightAnkle, 0, 0, 0);

    final landmarks = pose.landmarks;

    for (var landmarkType in landmarks.keys) {
      final landmark = landmarks[landmarkType]!;
      // print(landmarkType.name);

      // Scale the coordinates
      final imageWidth = imageSize.width;
      final imageHeight = imageSize.height;
      final containerWidth = containerSize.width;
      final containerHeight = containerSize.height;

      final landmarkX = (landmark.x / imageWidth) * containerWidth;
      final landmarkY = (landmark.y / imageHeight) * containerHeight;

      switch (landmarkType.name) {
        case SkeletonJoint.kNose:
          nose = SkeletonJoint(
            SkeletonJoint.kNose,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kLeftShoulder:
          leftShoulder = SkeletonJoint(
            SkeletonJoint.kLeftShoulder,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kRightShoulder:
          rightShoulder = SkeletonJoint(
            SkeletonJoint.kRightShoulder,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kLeftElbow:
          leftElbow = SkeletonJoint(
            SkeletonJoint.kLeftElbow,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kRightElbow:
          rightElbow = SkeletonJoint(
            SkeletonJoint.kRightElbow,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kLeftWrist:
          leftWrist = SkeletonJoint(
            SkeletonJoint.kLeftWrist,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kRightWrist:
          rightWrist = SkeletonJoint(
            SkeletonJoint.kRightWrist,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kLeftHip:
          leftHip = SkeletonJoint(
            SkeletonJoint.kLeftHip,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kRightHip:
          rightHip = SkeletonJoint(
            SkeletonJoint.kRightHip,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kLeftKnee:
          leftKnee = SkeletonJoint(
            SkeletonJoint.kLeftKnee,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kRightKnee:
          rightKnee = SkeletonJoint(
            SkeletonJoint.kRightKnee,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kLeftAnkle:
          leftAnkle = SkeletonJoint(
            SkeletonJoint.kLeftAnkle,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        case SkeletonJoint.kRightAnkle:
          rightAnkle = SkeletonJoint(
            SkeletonJoint.kRightAnkle,
            landmarkX,
            landmarkY,
            landmark.z,
          );
          break;
        default:
          break;
      }
    }

    return Skeleton(
      nose,
      leftShoulder,
      rightShoulder,
      leftElbow,
      rightElbow,
      leftWrist,
      rightWrist,
      leftHip,
      rightHip,
      leftKnee,
      rightKnee,
      leftAnkle,
      rightAnkle,
    );
  }
}
