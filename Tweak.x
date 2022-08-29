

%ctor {
	NSString *path = @"/var/mobile/Library/SMS/sms.db";
	FMDatabase *db = [FMDatabase databaseWithPath:path];
	NSLog(@"%@", db);
}