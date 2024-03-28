// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:matchloves/core/extensions/extensions.dart';

import '../../../core/theme/colors.dart';

typedef OnCodeEnteredCompletion = void Function(String value);
typedef OnCodeChanged = void Function(String value);
typedef HandleControllers = void Function(
    List<TextEditingController?> controllers);

class OtpTextField extends StatefulWidget {
  final bool showCursor;
  final int numberOfFields;
  final double fieldWidth;
  final double borderWidth;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color disabledBorderColor;
  final Color borderColor;
  final Color? cursorColor;
  final EdgeInsetsGeometry margin;
  final TextInputType keyboardType;
  final TextStyle? textStyle;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final OnCodeEnteredCompletion? onSubmit;
  final OnCodeEnteredCompletion? onCodeChanged;
  final HandleControllers? handleControllers;
  final bool obscureText;
  final bool showFieldAsBox;
  final bool enabled;
  final bool filled;
  final bool autoFocus;
  final bool readOnly;
  late final bool clearText;
  final bool hasCustomInputDecoration;
  final Color fillColor;
  final BorderRadius borderRadius;
  final InputDecoration? decoration;
  final List<TextStyle?> styles;
  final List<TextInputFormatter>? inputFormatters;

  OtpTextField({
    super.key,
    this.showCursor = true,
    this.numberOfFields = 4,
    this.fieldWidth = 60.0,
    this.borderWidth = 2.0,
    this.enabledBorderColor = const Color(0xFFE7E7E7),
    this.focusedBorderColor = const Color(0xFF4F44FF),
    this.disabledBorderColor = const Color(0xFFE7E7E7),
    this.borderColor = const Color(0xFFE7E7E7),
    this.cursorColor,
    this.margin = const EdgeInsets.only(right: 8.0),
    this.keyboardType = TextInputType.number,
    this.textStyle,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.onSubmit,
    this.onCodeChanged,
    this.handleControllers,
    this.obscureText = false,
    this.showFieldAsBox = false,
    this.enabled = true,
    this.filled = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.clearText = false,
    this.hasCustomInputDecoration = false,
    this.fillColor = const Color(0xFFFFFFFF),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.decoration,
    this.styles = const [],
    this.inputFormatters,
  })  : assert(numberOfFields > 0),
        assert(styles.isNotEmpty
            ? styles.length == numberOfFields
            : styles.isEmpty);

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late List<String?> _verificationCode;
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  @override
  void initState() {
    super.initState();

    _verificationCode = List<String?>.filled(widget.numberOfFields, null);
    _focusNodes = List<FocusNode?>.filled(widget.numberOfFields, null);
    _textControllers = List<TextEditingController?>.filled(
      widget.numberOfFields,
      null,
    );
  }

  @override
  void didUpdateWidget(covariant OtpTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clearText != widget.clearText && widget.clearText == true) {
      for (var controller in _textControllers) {
        controller?.clear();
      }
      _verificationCode = List<String?>.filled(widget.numberOfFields, null);
      setState(() {
        widget.clearText = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _textControllers) {
      controller?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return generateTextFields(context);
  }

  Widget _buildTextField({
    required BuildContext context,
    required int index,
    TextStyle? style,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: (_textControllers[index]?.text.isNotEmpty ?? false) ||
                (_focusNodes[index]?.hasFocus ?? false)
            ? whiteColor
            : darkColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(context.width / 7),
      ),
      width: context.width / 7,
      height: context.width / 7,
      margin: widget.margin,
      alignment: Alignment.center,
      child: TextField(
        showCursor: widget.showCursor,
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.center,
        maxLength: 1,
        readOnly: widget.readOnly,
        style: style ??
            widget.textStyle ??
            context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        autofocus: widget.autoFocus,
        cursorColor: widget.cursorColor,
        controller: _textControllers[index],
        focusNode: _focusNodes[index],
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        decoration: widget.hasCustomInputDecoration
            ? widget.decoration
            : InputDecoration(
                counterText: "",
                filled: widget.filled,
                fillColor: widget.fillColor,
                focusedBorder: outlineBorder(widget.focusedBorderColor),
                enabledBorder: outlineBorder(widget.enabledBorderColor),
                disabledBorder: outlineBorder(widget.disabledBorderColor),
                border: outlineBorder(widget.borderColor),
              ),
        obscureText: widget.obscureText,
        onChanged: (String value) {
          //save entered value in a list
          _verificationCode[index] = value;
          onCodeChanged(verificationCode: value);
          changeFocusToNextNodeWhenValueIsEntered(
            value: value,
            indexOfTextField: index,
          );
          changeFocusToPreviousNodeWhenValueIsRemoved(
              value: value, indexOfTextField: index);
          onSubmit(verificationCode: _verificationCode);
          setState(() {});
        },
      ),
    );
  }

  OutlineInputBorder outlineBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: widget.borderWidth,
        color: color,
      ),
      borderRadius: widget.borderRadius,
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.numberOfFields, (int i) {
      addFocusNodeToEachTextField(index: i);
      addTextEditingControllerToEachTextField(index: i);

      if (widget.styles.isNotEmpty) {
        return _buildTextField(
          context: context,
          index: i,
          style: widget.styles[i],
        );
      }
      if (widget.handleControllers != null) {
        widget.handleControllers!(_textControllers);
      }
      return _buildTextField(context: context, index: i);
    });

    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: textFields,
    );
  }

  void addFocusNodeToEachTextField({required int index}) {
    if (_focusNodes[index] == null) {
      _focusNodes[index] = FocusNode();
    }
  }

  void addTextEditingControllerToEachTextField({required int index}) {
    if (_textControllers[index] == null) {
      _textControllers[index] = TextEditingController();
    }
  }

  void changeFocusToNextNodeWhenValueIsEntered({
    required String value,
    required int indexOfTextField,
  }) {
    //only change focus to the next textField if the value entered has a length greater than one
    if (value.isNotEmpty) {
      //if the textField in focus is not the last textField,
      // change focus to the next textField
      if (indexOfTextField + 1 != widget.numberOfFields) {
        //change focus to the next textField
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField + 1]);
      } else {
        //if the textField in focus is the last textField, unFocus after text changed
        _focusNodes[indexOfTextField]?.unfocus();
      }
    }
  }

  void changeFocusToPreviousNodeWhenValueIsRemoved({
    required String value,
    required int indexOfTextField,
  }) {
    //only change focus to the previous textField if the value entered has a length zero
    if (value.isEmpty) {
      //if the textField in focus is not the first textField,
      // change focus to the previous textField
      if (indexOfTextField != 0) {
        //change focus to the next textField
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField - 1]);
      }
    }
  }

  void onSubmit({required List<String?> verificationCode}) {
    if (verificationCode.every((String? code) => code != null && code != '')) {
      if (widget.onSubmit != null) {
        widget.onSubmit!(verificationCode.join());
      }
    }
  }

  void onCodeChanged({required String verificationCode}) {
    if (widget.onCodeChanged != null) {
      widget.onCodeChanged!(verificationCode);
    }
  }
}
