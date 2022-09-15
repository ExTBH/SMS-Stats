
@interface IMChat : NSObject
@property (nonatomic, readonly) NSString *guid; 
@end

@interface CKConversation : NSObject
@property (nonatomic, retain) IMChat *chat;
@property (nonatomic, readonly) NSString *name;
@end