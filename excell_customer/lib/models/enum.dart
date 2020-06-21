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
  Emailid
}

enum TicketsScreenMode { CreateTicket, ViewTickets, Loading }

enum MyPackagesScreenMode { List, Detail }