#import "AppHeaders/AppHeaders.h"
#import "SSViewController/SSViewController.h"
#import "SSDBManager/SSDBManager.h"

%hook CKMessagesController
- (void)viewDidLoad{
	%orig;
	UIButton *statsButton = [self buttonWithImageNamed:@"s.circle"];
	[statsButton addTarget:self action:@selector(presentJDEViewController:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:statsButton];
	[NSLayoutConstraint activateConstraints:@[
		[statsButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
		[statsButton.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:50],
	]];
}

%new
- (UIButton*)buttonWithImageNamed:(NSString*)image{
    //init
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setImage:[UIImage systemImageNamed:image] forState:UIControlStateNormal];
    //sizes

    return btn;
}

%new
-(void)presentJDEViewController:(id)sender{
	[SSDBManager statsForGUID:nil];
    SSViewController *statsVC = [SSViewController new];
    statsVC.title = @"Ststs";
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:statsVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

%end