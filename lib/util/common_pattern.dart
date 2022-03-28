class CommonPattern {
  static final mobile_regex = r"^[5-9][0-9]{9}$";
  static final name_regex = r"^[a-zA-Z][a-zA-Z\s]*$";
  static final email_regex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static final gst_regex =
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$';
  static final pincodeRegex = r"^[1-9][0-9]{5}$";
  static final passwordRegex = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{4,}$";

  static final pancardRegex = r"[A-Z]{5}[0-9]{4}[A-Z]{1}$";
  static final drivingLicenceRegex =
      r"^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$";
  static final voterIdRegex = r"^([a-zA-Z]){3}([0-9]){7}?$";
  static final passportRegex = r"^[A-Z]{1}-[0-9]{7}$";
  static final aadharRegex = r"^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$";
  static final addressRegex = r"^[a-zA-Z0-9\s,\/.#()-]+$";
}
