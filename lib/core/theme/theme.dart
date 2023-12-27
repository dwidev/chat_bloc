import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: GoogleFonts.poppinsTextTheme().titleLarge?.copyWith(
            color: whiteColor,
          ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    iconTheme: const IconThemeData(
      color: blackColor,
      size: 15,
    ),
  );
}
