#import "SSViewController.h"


// Private declarations; this class only.
@interface SSViewController()  <UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) UITableView *SSTableView;
@end

@implementation SSViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self configureLookAndBar];
    [self configureTableview];

}

// MARK: - General Methods
- (void)configureLookAndBar{
    // Who likea transparent background?
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    //Bar buttons you know
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self
                                                                        action:@selector(removeSettingsVC:)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"All Time" menu:[self menuForBarItem]];
}

- (UIMenu*)menuForBarItem{
        UIAction *allTime = [UIAction actionWithTitle:@"All time" image:nil identifier:nil handler:^(UIAction *handler) {
            //TODO:  - write the copy part
            
        }];
        UIAction *lastWeek = [UIAction actionWithTitle:@"Last 7 days" image:nil identifier:nil handler:^(UIAction *handler) {
            //TODO:  - write the copy part
            self.navigationItem.rightBarButtonItem.title = @"Last 7 days";
        }];
        UIAction *lastMonth = [UIAction actionWithTitle:@"Last 30 days" image:nil identifier:nil handler:^(UIAction *handler) {
            //TODO:  - write the copy part
        }];
    return [UIMenu menuWithTitle:@"" children:@[allTime, lastWeek, lastMonth]];
}
- (void)configureTableview{
    self.SSTableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    self.SSTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.SSTableView];
    self.SSTableView.delegate = self;
    self.SSTableView.dataSource = self;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.SSTableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.SSTableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.SSTableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.SSTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    self.SSTableView.sectionHeaderHeight = 33;
    self.SSTableView.allowsSelection = NO;
}


-(void)removeSettingsVC:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 3; }

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = UIColor.clearColor;
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:label];
    
    switch (section) {
        case 0:
            label.text = @"Total";
            break;
        case 1:
            label.text = @"SMS";
            break;
        case 2:
            label.text = @"iMessage";
            break;
    }    label.textColor = UIColor.secondaryLabelColor;
    
    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:headerView.safeAreaLayoutGuide.leadingAnchor constant:20],
        [label.centerYAnchor constraintEqualToAnchor:headerView.safeAreaLayoutGuide.centerYAnchor]
    ]];
    
    
    return  headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 2:
            return 33;
            break;
        default:
            return 22;
    }   

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 2){
        UIView *footerView = [UIView new];
        footerView.backgroundColor = UIColor.clearColor;
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [footerView addSubview:label];
        
        label.text = @"SMS Stats iOS Router & ExTBH";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.tertiaryLabelColor;
        
        [NSLayoutConstraint activateConstraints:@[
            [label.leadingAnchor constraintEqualToAnchor:footerView.safeAreaLayoutGuide.leadingAnchor constant:20],
            [label.centerYAnchor constraintEqualToAnchor:footerView.safeAreaLayoutGuide.centerYAnchor]
        ]];
        return  footerView;
    }
    return nil;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatsCell"];
    cell.backgroundColor = UIColor.clearColor;
    cell.textLabel.text = @"Weeee";


    return cell;
}



// Alow for copying the data
- (UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
    UIAction *copy = [UIAction actionWithTitle:@"Copy" image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(UIAction *handler) {
            //TODO:  - write the copy part
        }];
    UIMenu *menu = [UIMenu menuWithTitle:@"" children:@[copy]];
    UIContextMenuConfiguration *menuConfig = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^(NSArray *suggestedActions) { return menu;}
    ];
    return  menuConfig;
}

@end