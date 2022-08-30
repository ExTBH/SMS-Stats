#import "SSViewController.h"


// Private declarations; this class only.
@interface SSViewController()  <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) UITableView *SSTableView;
@property (nonatomic, assign) int curentFilter; // 0 = All, 1 = 7Days, 2 = 30Days
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

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" menu:[self menuForBarItem]];
    self.curentFilter = 0;
}
// To filter the Stats based on time
- (UIMenu*)menuForBarItem{
        UIAction *allTime = [UIAction actionWithTitle:@"All time" image:nil identifier:nil handler:^(UIAction *handler) {
            //TODO:  - Logic
            self.curentFilter = 0;
            self.navigationItem.leftBarButtonItem.menu = [self menuForBarItem];
        }];
        UIAction *lastWeek = [UIAction actionWithTitle:@"Last 7 days" image:nil identifier:nil handler:^(UIAction *handler) {
            //TODO:  - Logic
            self.curentFilter = 1;
            self.navigationItem.leftBarButtonItem.menu = [self menuForBarItem];
        }];
        UIAction *lastMonth = [UIAction actionWithTitle:@"Last 30 days" image:nil identifier:nil handler:^(UIAction *handler) {
            //TODO:  - Logic
            self.curentFilter = 2;
            self.navigationItem.leftBarButtonItem.menu = [self menuForBarItem];
            
        }];

    switch(self.curentFilter){
        case 0:
            allTime.image = [UIImage systemImageNamed:@"checkmark"];
            break;
        case 1:
            lastWeek.image = [UIImage systemImageNamed:@"checkmark"];
            break;
        case 2:
            lastMonth.image = [UIImage systemImageNamed:@"checkmark"];
            break;
    }
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
    UILabel *count = [UILabel new];

    

    switch(indexPath.section){
        case 0:
            switch(indexPath.row){
                case 0:
                    cell.textLabel.text = @"Total";
                    count.text = [NSString stringWithFormat:@"%u",[SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message;"]];
                    break;
                case 1:
                    cell.textLabel.text = @"Sent";
                    count.text = [NSString stringWithFormat:@"%u",[SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message WHERE is_from_me = 1;"]];
                    break;
                case 2:
                    cell.textLabel.text = @"Received";
                    count.text = [NSString stringWithFormat:@"%u",[SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message WHERE is_from_me = 0;"]];
                    break;
            }
            break;
        case 1:
            switch(indexPath.row){
                case 0:
                    cell.textLabel.text = @"Total";
                    count.text = [NSString stringWithFormat:@"%u",[SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message WHERE service = 'SMS'"]];
                    break;
                case 1:
                    cell.textLabel.text = @"Sent";
                    count.text = [NSString stringWithFormat:@"%u",[SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message WHERE service = 'SMS' AND is_from_me = 1;"]];
                    break;
                case 2:
                    cell.textLabel.text = @"Received";
                    count.text = [NSString stringWithFormat:@"%u",[SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message WHERE service = 'SMS' AND is_from_me = 0;"]];
                    break;
            }
            break;
        case 2:
            switch(indexPath.row){
                case 0:
                    cell.textLabel.text = @"Total";
                    count.text = [NSString stringWithFormat:@"%u",[SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message WHERE service = 'iMessage'"]];
                    break;
                case 1:
                    cell.textLabel.text = @"Sent";
                    count.text = [NSString stringWithFormat:@"%u",[SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message WHERE service = 'iMessage' AND is_from_me = 1;"]];
                    break;
                case 2:
                    cell.textLabel.text = @"Received";
                    count.text = [NSString stringWithFormat:@"%u",[SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message WHERE service = 'iMessage' AND is_from_me = 0;"]];
                    break;
            }
            break;
    }

    [count sizeToFit];
    cell.accessoryView = count;
    return cell;
}


@end