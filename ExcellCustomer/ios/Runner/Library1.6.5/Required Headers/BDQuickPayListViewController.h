//
//  BDQuickPayListViewController.h
//  BillDesk_iOS_sdk
//
#import <UIKit/UIKit.h>

@protocol CardListUpdateProtocol <NSObject>
@required
-(void)updateCardList:(NSMutableArray*)cardList;

@end
@interface BDQuickPayListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
{
    UIAlertController *alertController;
    UIAlertAction *okAction,*cancelAction;
    int heightOfHeader;
    NSString *message;
    NSString *token;
    NSString *email;
    NSString *mobile;
    float amount;
    NSString *merchantID;
    NSArray *paymentArray;
    NSMutableArray *listArray;
    UITableView *listView;
    NSMutableDictionary *elementConfig;
    BOOL popUpPresent;
    UIAlertView *alert;
    UIToolbar* keyboardDoneButtonView;
    NSDictionary *cdDict,*dcDict;
    NSString *currentTokenSelectedForCell,*itemCode,*bank_id;
    NSUserDefaults *defaults;
}
@property(unsafe_unretained)id<CardListUpdateProtocol> delegate;
@property(strong,nonatomic)NSDictionary *configDictionary;
@property(strong,nonatomic)UITextField *cvvTextField;
@property(strong,nonatomic)UIButton *cvvSubmitButton;

@property(nonatomic,assign)float payableAmount;

- (id)initWithMessage:(NSString*)message_ andToken:(NSString*)token_ andEmail:(NSString *)email_ andMobile:(NSString *)mobile_ andAmount:(float)amount_ listArray:(NSMutableArray*)Array merchantId:(NSString*)merchant paymentArr:(NSArray*)Arr;
@end
