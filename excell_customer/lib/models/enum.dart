enum AppTheme { Dark, Light }

enum FooterState {
  Default,
  ValidCredentialsEntered,
  ValidatingCredentials,
  ValidatedCredentialsResultWrong,
  OTPEntryPending,
  OTPEnteredResultCorrect,
  OTPEnteredResultWrong,
  ResendOTP,
  DueExist,
  DueNotExist,
}

enum Direction { x, y }

enum StorageKey {
  UserToken,
  CustId,
  MobileNo,
  CutomerName,
  ContactNo,
  AltContactNo,
  Address,
  City,
  State,
  Emailid,
  Locations,
  FBToken,
  CMSId
}

enum TicketsScreenMode { CreateTicket, ViewTickets, Loading }

enum MyPackagesScreenMode { List, Detail, NoPackages }

enum EnquiryScreenMode { WelcomeScreen, BasicDetail, AddressDetail, ThankYou }
