import 'package:flutter/material.dart';
import 'package:movie_night/widgets/colors.dart';

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  maximumSize: const Size(double.infinity, 56),
  minimumSize: const Size(double.infinity, 56),
  backgroundColor: primaryColor,
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
  ),
);

final ButtonStyle buttonPrimaryLight = ElevatedButton.styleFrom(
  maximumSize: const Size(double.infinity, 56),
  minimumSize: const Size(double.infinity, 56),
  backgroundColor: primaryLightColor,
  elevation: 0,
  foregroundColor: Colors.black,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
  ),
);
