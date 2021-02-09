//
//  myNav.m
//  Bill
//
//

#import "myNav.h"

@interface myNav ()

@end

@implementation myNav

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (BOOL)shouldAutorotate
{

    //NSLog([self.visibleViewController shouldAutorotate]?@"nav autorotate YES":@"nav autorotate NO");
    return [self.visibleViewController shouldAutorotate];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    NSLog( [self.visibleViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]?@"nav shouldautorotate YES":@"nav shouldautorotate NO");

      return [self.visibleViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
