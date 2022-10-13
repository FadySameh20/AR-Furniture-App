class Validations {

  //check on empty input field and null
  String? validationEmptyNull(String value){
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  //validate password
  String? validatePassword(String value){
    if(!RegExp(r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&-+=()])(?=\\S+$).{6, 20}$").hasMatch(value)) {
      return 'Please enter a valid password';
    }
    return null;
  }

  //validate email
  String? validateEmail(String value){
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}