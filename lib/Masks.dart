import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Masks extends Object {
  static final cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  static List<MaskTextInputFormatter> contaMasks = List.generate(20, (index) {
    return MaskTextInputFormatter(
        mask: '###.###.###-###',
        filter: {'#': RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  });

  static final cnpjMask = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  static final dobMask = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  static final cepMask = MaskTextInputFormatter(
      mask: '##.###-###',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  static final phoneMask = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}
