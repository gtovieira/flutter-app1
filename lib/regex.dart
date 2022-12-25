class RegexCodes {
  static final email = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

  static final cpf = RegExp(r'^[\d]{3}[\.]?[\d]{3}[\.]?[\d]{3}[-]?[\d]{2}$');
  static final cpf_group =
      RegExp(r'^(\d{3})[\.]?(\d{3})[\.]?(\d{3})[-]?(\d{2})$');

  static final cnpj =
      RegExp(r'^[\d]{2}[\.]?[\d]{3}[\.]?[\d]{3}[\/]?[\d]{4}[-]?[\d]{2}$');
  static final cnpj_group =
      RegExp(r'^(\d{2})[\.]?(\d{3})[\.]?(\d{3})[\/]?(\d{4})[-]?(\d{2})$');

  static final currency_group = RegExp(r'(\d*)[,](\d{2})');

  static final phone = RegExp(r'\(?[\d]{2}\)?[ ]?[\d]{5}[-| ]?[\d]{4}');
  static final phone_group = RegExp(r'\(?(\d{2})\)?[ ]?(\d{5})[-| ]?(\d{4})');

  static final nome = RegExp(r'.*');
  static final cod = RegExp(r'^[\d]*$');

  static final dob = RegExp(r'.*');
  static final cep = RegExp(r'.*');
  static final address = RegExp(r'.*');
  static final number = RegExp(r'.*');
  static final city = RegExp(r'.*');
  static final uf = RegExp(r'.*');
}
