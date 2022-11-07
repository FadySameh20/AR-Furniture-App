class Validations {

  //check on empty input field and null
  String? validationEmptyNull(String? value){
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  //validate password
  String? validatePassword(String value){
    if(value.trim().length < 6){
      return 'Password must be at least 6 characters in length';
    }
    if(value.trim().length > 20){
      return 'Password must be at most 20 characters in length';
    }
    if(!RegExp(r"^(?=.*[0-9])").hasMatch(value)) {
      return 'Password must have at least one digit';
    }
    if(!RegExp(r"^(?=.*[a-z])").hasMatch(value)) {
      return 'Password must have at least a lower case alphabet';
    }
    if(!RegExp(r"^(?=.*[A-Z])").hasMatch(value)) {
      return 'Password must have at least a upper case alphabet';
    }
    if(!RegExp(r"^(?=.*[@#!$%^&-+=()])").hasMatch(value)) {
      return 'Password must have at least a special character';
    }
    if(value.length != value.trim().length) {
      return "Please enter a valid password";
    }
    return null;
  }

  String? checkPasswordCompatability(String password, String confirmPassword) {
    if (password != confirmPassword) {
      return "Password and Confirm Password must match !";
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

  //validate name
  String? validateName(String value){
    if (!RegExp(r"^([a-zA-Z']+)$").hasMatch(value)) {
      return 'Please enter a valid name';
    }
    if (value.length > 20){
      return 'Maximum length is 20 characters';
    }
    return null;
  }

  //validate no special character and numbers
  String? validateText(String value){
    print('textvalue');
    print(value);
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value) || value == null || value.trim().isEmpty) {
      return 'Please enter a valid text';
    }
    return null;
  }
  //validate  numbers
  String? validateNumber(String value){
    try{
      int.parse(value);
      return null;
    }
    catch(error){
      return 'Please enter a valid number';
    }

  }

  //validate address (no special characters)
  String? validateAddress(String value){
    if(RegExp(r"^(?=.*[@#!$%^&+=()])").hasMatch(value)) {
      return 'Please enter a valid address';
    }
    return null;
  }

  //validate phone number (10 digits with no comma, no spaces, no punctuation)
  String? validatePhoneNumber(String value){
    if(!RegExp(r"^\d{10}$").hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}