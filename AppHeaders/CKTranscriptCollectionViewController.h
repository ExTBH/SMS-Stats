#import <UIKit/UIKit.h>
#import "CKConversation.h"

@interface CKTranscriptCollectionViewController : UIViewController
@property (nonatomic, strong, readwrite) CKConversation *conversation;
@end