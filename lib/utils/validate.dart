class Validate {

  static bool isValidEmail(String email) {
    
    if(email == null || email.isEmpty) {
      return false;
    }

    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    if(password == null || password.isEmpty) {
      return false;
    }
    return password.length >= 8;
  }

  static bool isValidPasswordV2(String password) {
    if(password == null || password.isEmpty) {
      return false;
    }
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }


  static bool isValidName(String name) {
    if(name == null || name.isEmpty) {
      return false;
    }
    return name.length >= 2 && name.length <= 100;
  }

  static bool isValidBio(String bio) {
    if(bio == null || bio.isEmpty) {
      return false;
    }
    return bio.length <= 150;
  }

  static bool isValidAge(String age){
    if(age == null || age.isEmpty){
      return false;
    }

    return int.tryParse(age ?? '')! > 0;
  }

  static bool isCheckboxChecked(Map<String, bool> hobbies) {
    return hobbies.values.any((isChecked) => isChecked);
  }


  //check ngày trong quá khứ
  static bool isValidDate(String date) {
    if(date == null || date.isEmpty) {
      return false;
    }
    try {
      DateTime selectedDate = DateTime.parse(date);
      return selectedDate.isAfter(DateTime.now().subtract(Duration(days: 1)));
    } catch (e) {
      return false;
    }
  }

}