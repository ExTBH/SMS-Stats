#import "AppHeaders/AppHeaders.h"
#import "SSViewController/SSViewController.h"
#import "SSDBManager/SSDBManager.h"


static NSString *currentConversationGuid;
static NSString *currentConversationName;

// has a CKConversation // hook it
%hook CKTranscriptCollectionViewController
- (void)viewDidLoad{
    %orig;
    currentConversationGuid = self.conversation.chat.guid;
    currentConversationName = self.conversation.name;
}
%end

@interface CKDetailsController : UIViewController
@end

%hook CKDetailsController
- (void)viewDidLoad{
    %orig;
    UIBarButtonItem *statsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"s.circle"] 
                                                                        style:UIBarButtonItemStyleDone target:self 
                                                                        action:@selector(presentSSViewController:)];
    
    self.navigationItem.leftBarButtonItem = statsButton;
}
%new
-(void)presentSSViewController:(id)sender{
    SSViewController *statsVC = [SSViewController new];
    statsVC.title = [NSString stringWithFormat:@"Stats for %@", currentConversationName];
    statsVC.guid = currentConversationGuid;
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:statsVC];
    [self presentViewController:navVC animated:YES completion:nil];
}
%end