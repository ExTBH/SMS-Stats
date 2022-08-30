#import <UIKit/UIKit.h>

//The main view controller of the Chat App, hook it and add a button for Stats
@interface CKMessagesController : UISplitViewController
@property (nonatomic, strong) NSString* testProp;
- (UIButton*)buttonWithImageNamed:(NSString*)image;
@end