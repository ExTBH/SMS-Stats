#import "AppHeaders/AppHeaders.h"
#import "SSViewController/SSViewController.h"
#import "SSDBManager/SSDBManager.h"

%hook CKConversationListCollectionViewController
- (void)viewDidLoad{
    %orig;
    UIBarButtonItem *origEditButton = self.navigationItem.leftBarButtonItem;
    UIBarButtonItem *statsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"s.circle"] 
                                                                        style:UIBarButtonItemStyleDone target:self 
                                                                        action:@selector(presentSSViewController:)];
    
    self.navigationItem.leftBarButtonItems = @[origEditButton, statsButton];
}

%new
-(void)presentSSViewController:(id)sender{
    SSViewController *statsVC = [SSViewController new];
    statsVC.title = @"SMS Stats";
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:statsVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

%end