class Validacion {
  static String validaMail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese una direccion de correo electronico.';
    else
      return null;
  }

  static String validaPass(String value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'La contraseña debe terer al menos 6 caracteres';
    else
      return null;
  }
}