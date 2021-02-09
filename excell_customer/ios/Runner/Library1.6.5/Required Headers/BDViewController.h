//
//  BDViewController.h
//  BillDesk_iOS_sdk
//

@protocol LibraryPaymentStatusProtocol <NSObject>
@required
-(void)paymentStatus:(NSString*)message;
@optional
-(void)onError:(NSException *)exception;
-(void)tryAgain;
-(void)cancelTransaction;
@end
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BDQuickPayListViewController.h"
@interface BDViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,CardListUpdateProtocol,CLLocationManagerDelegate>
{
    // CLLocationManager *locationManager;
    int heightOfHeader;
    NSString *message;
    NSString *token;
    NSString *email;
    NSString *mobile;
    NSString *txtpaycategory;
    float amount;
    NSString *merchantID;
    NSArray * unsorted;
    //NSString *netBankingUrl;
    NSString *btnfontName;
    NSString *lblfontName;
    NSString *override_bankid;
    NSString *override_itemcode;
    float fontSize;
    NSMutableArray *quickPayList;
    float currentLat;
    float currentLong;
    BOOL hideNavBar,flag,defaultCategoryF;
    //BDButton *button;
    int y,pymtStausCount;
    UIView *backGroundView;
   // TPKeyboardAvoidingScrollView * scrollView;
    NSUserDefaults *defaults;
    UIAlertController *alertController;
    UIAlertAction *okAction;
    NSArray *payCategoryItems;
    NSString *forceOption,*defaultCategory,*TXTPAYCATEGORY;
}
@property(nonatomic,assign)float payableAmount;
@property(strong,nonatomic)NSDictionary *configDictionary;
@property(unsafe_unretained)id<LibraryPaymentStatusProtocol> delegate;


@property(strong,nonatomic)NSMutableArray *debitCardBankDetails;
@property(strong,nonatomic)NSMutableArray *netBankingBankDetails;
@property(strong,nonatomic)NSMutableArray *debitCardBankNames;
@property(strong,nonatomic)NSMutableArray *netBankingBankNames;
@property(strong,nonatomic)NSMutableArray *selectedPaymentOptionArray;
@property(strong,nonatomic)NSString *selectedPaymentOptionID;

@property(nonatomic,assign)BOOL isQuickPay;
@property (strong,nonatomic)CLLocationManager *locationManager;
- (id)initWithMessage:(NSString*)message_ andToken:(NSString*)token_ andEmail:(NSString *)email_ andMobile:(NSString *)mobile_ andAmount:(float)amount_ __attribute__((deprecated("Use -initWithMessage:andToken: andEmail: andMobile: Instead")));
- (id)initWithMessage:(NSString*)message_ andToken:(NSString*)token_ andEmail:(NSString *)email_ andMobile:(NSString *)mobile_ andAmount:(float)amount_ andTxtPayCategory:(NSString *)txtpaycategory_ __attribute__((deprecated("Use -initWithMessage: andToken: andEmail: andMobile: andTxtPayCategory: Instead")));;
- (id)initWithMessage:(NSString*)message_ andToken:(NSString*)token_ andEmail:(NSString *)email_ andMobile:(NSString *)mobile_ andAmount:(float)amount_ setOrientation:(NSInteger)orientation __attribute__((deprecated("Use -initWithMessage: andToken: andEmail: andMobile: setOrientation: Instead")));;
- (id)initWithMessage:(NSString*)message_ andToken:(NSString*)token_ andEmail:(NSString *)email_ andMobile:(NSString *)mobile_ andAmount:(float)amount_ setOrientation:(NSInteger)orientation andTxtPayCategory:(NSString *)txtpaycategory_ __attribute__((deprecated("Use -initWithMessage: andToken: andEmail: andMobile: setOrientation: andTxtPayCategory: Instead")));;

- (id)initWithMessage:(NSString*)message_ andToken:(NSString*)token_ andEmail:(NSString *)email_ andMobile:(NSString *)mobile_;
- (id)initWithMessage:(NSString*)message_ andToken:(NSString*)token_ andEmail:(NSString *)email_ andMobile:(NSString *)mobile_ andTxtPayCategory:(NSString *)txtpaycategory_;
- (id)initWithMessage:(NSString*)message_ andToken:(NSString*)token_ andEmail:(NSString *)email_ andMobile:(NSString *)mobile_ setOrientation:(NSInteger)orientation;
- (id)initWithMessage:(NSString*)message_ andToken:(NSString*)token_ andEmail:(NSString *)email_ andMobile:(NSString *)mobile_ setOrientation:(NSInteger)orientation andTxtPayCategory:(NSString *)txtpaycategory_;

-(void)pushPGStatus;


@end
