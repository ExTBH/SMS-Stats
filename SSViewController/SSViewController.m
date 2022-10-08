#import "SSViewController.h"



double nanoSecondsFromSeconds(double seconds){
    return seconds * 1000000000;
}

// Private declarations; this class only.
@interface SSViewController()  <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) UITableView *SSTableView;
@property (nonatomic, assign) int curentFilter; // 0 = All, 1 = 7Days, 2 = 30Days
@property (nonatomic, strong) NSString *service;
@end

@implementation SSViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self configureLookAndBar];
    [self configureTableview];
    self.service = [self.guid hasPrefix:@"SMS"] ? @"SMS" : @"iMessage";

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

            self.curentFilter = 0;
            self.navigationItem.leftBarButtonItem.menu = [self menuForBarItem];
            [self reloadRows];
        }];
        UIAction *lastWeek = [UIAction actionWithTitle:@"Last 7 days" image:nil identifier:nil handler:^(UIAction *handler) {

            self.curentFilter = 1;
            self.navigationItem.leftBarButtonItem.menu = [self menuForBarItem];
            [self reloadRows];
        }];
        UIAction *lastMonth = [UIAction actionWithTitle:@"Last 30 days" image:nil identifier:nil handler:^(UIAction *handler) {
            self.curentFilter = 2;
            self.navigationItem.leftBarButtonItem.menu = [self menuForBarItem];
            [self reloadRows];
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

- (void)reloadRows{
    NSMutableArray<NSIndexPath*> *indexPaths = [NSMutableArray new];
    NSInteger sections = self.SSTableView.numberOfSections;
    for(int i = 0; i <= sections -1; i++){
        NSInteger rows = [self.SSTableView numberOfRowsInSection:i];
        for(int j = 0; j <= rows - 1; j++){
            [indexPaths addObject:[NSIndexPath indexPathForRow:j inSection:i]];
        }
    }
    [self.SSTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (NSString*)textForCellAtIndexPath:(NSIndexPath*)indexPath{
    if(self.guid == nil){
        self.service = (indexPath.section == 1) ? @"SMS" : @"iMessage";
        switch(indexPath.section){
            case 0:
                switch(indexPath.row){
                    case 0:
                        return [SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message;"];
                    case 1:
                        return [SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message WHERE is_from_me = 1;"];
                    case 2:
                        return [SSDBManager rowCountForQuery:@"SELECT COUNT(*) FROM message WHERE is_from_me = 0;"];
                }
            case 1:
            case 2:
                switch(indexPath.row){
                    case 0:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE service = '%@'", self.service]];
                    case 1:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE service = '%@' AND is_from_me = 1;", self.service]];
                    case 2:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE service = '%@' AND is_from_me = 0;", self.service]];
                }

        }
        return nil;
    }
    // queries from the original https://github.com/c-ryan747/SMSStats2/blob/0a38d93eed5a288ea90420b0cdcf2a6aefb30782/CRStatsProvider.m#L52
    switch(indexPath.section){
            case 0:
                switch(indexPath.row){
                    case 0:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE service = '%@' AND ROWID IN (SELECT message_id FROM chat_message_join WHERE chat_id IN (SELECT ROWID FROM chat WHERE guid LIKE  '%@'));", self.service, self.guid]];
                    case 1:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE is_from_me = 1 and service = '%@' AND ROWID IN (SELECT message_id FROM chat_message_join WHERE chat_id IN (SELECT ROWID FROM chat WHERE guid LIKE  '%@'));", self.service, self.guid]];
                    case 2:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE is_from_me = 0 and service = '%@' AND ROWID IN (SELECT message_id FROM chat_message_join WHERE chat_id IN (SELECT ROWID FROM chat WHERE guid LIKE  '%@'));", self.service, self.guid]];
                }
        }
    return nil;

}

- (NSString*)textForCellAtIndexPath:(NSIndexPath*)indexPath filterWithDays:(int)days{
    // Getting past time in nanoSeconds since the DB use that
    NSDate *filterDate = [NSDate dateWithTimeIntervalSinceNow:-86400 * days];
    double filterAsNano = nanoSecondsFromSeconds([filterDate timeIntervalSinceReferenceDate]);
    if(self.guid == nil){
        self.service = (indexPath.section == 1) ? @"SMS" : @"iMessage";
        switch(indexPath.section){
            case 0:
                switch(indexPath.row){
                    case 0:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE date >= %0.f;", filterAsNano]];
                    case 1:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE is_from_me = 1 AND date >= %0.f;", filterAsNano]];
                    case 2:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE is_from_me = 0 AND date >= %0.f;", filterAsNano]];
                }
            case 1:
            case 2:
                switch(indexPath.row){
                    case 0:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE service = '%@' AND date >= %0.f;", self.service, filterAsNano]];
                    case 1:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE service = '%@' AND is_from_me = 1 AND date >= %0.f;", self.service, filterAsNano]];
                    case 2:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE service = '%@' AND is_from_me = 0 AND date >= %0.f;", self.service, filterAsNano]];
                }
        }
        return nil;
    }
    // queries from the original https://github.com/c-ryan747/SMSStats2/blob/0a38d93eed5a288ea90420b0cdcf2a6aefb30782/CRStatsProvider.m#L52
    switch(indexPath.section){
            case 0:
                switch(indexPath.row){
                    case 0:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE service = '%@' AND date >= %0.f AND ROWID IN (SELECT message_id FROM chat_message_join WHERE chat_id IN (SELECT ROWID FROM chat WHERE guid LIKE  '%@'));", self.service, filterAsNano, self.guid]];
                    case 1:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE service = '%@' AND is_from_me = 1 AND date >= %0.f AND ROWID IN (SELECT message_id FROM chat_message_join WHERE chat_id IN (SELECT ROWID FROM chat WHERE guid LIKE  '%@'));", self.service, filterAsNano, self.guid]];
                    case 2:
                        return [SSDBManager rowCountForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM message WHERE service = '%@' AND is_from_me = 0 AND date >= %0.f AND ROWID IN (SELECT message_id FROM chat_message_join WHERE chat_id IN (SELECT ROWID FROM chat WHERE guid LIKE  '%@'));", self.service, filterAsNano, self.guid]];
                }
        }
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    if(!self.guid){
        return 3;
    }
    return 1;
    }

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = UIColor.clearColor;
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:label];
    if(!self.guid){
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
        }
    }
    else{
        label.text = self.service;
    }

    label.textColor = UIColor.secondaryLabelColor;
    
    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:headerView.safeAreaLayoutGuide.leadingAnchor constant:20],
        [label.centerYAnchor constraintEqualToAnchor:headerView.safeAreaLayoutGuide.centerYAnchor]
    ]];
    
    
    return  headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if([self numberOfSectionsInTableView:tableView] -1 == section){
        return 33;
    }
    return 22;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if([self numberOfSectionsInTableView:tableView] -1 == section){
        UIView *footerView = [UIView new];
        footerView.backgroundColor = UIColor.clearColor;
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [footerView addSubview:label];
        
        label.text = @"SMS Stats 3";
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


    switch(indexPath.row){
        case 0:
            cell.textLabel.text = @"Total";
            break;
        case 1:
            cell.textLabel.text = @"Sent";
            break;
        case 2:
            cell.textLabel.text = @"Received";
            break;
    }
    count.text = [self textForCellAtIndexPath:indexPath];
    switch(self.curentFilter){
    case 0:
        count.text = [self textForCellAtIndexPath:indexPath];
        break;
    case 1:
        count.text = [self textForCellAtIndexPath:indexPath filterWithDays:7];
        break;
    case 2:
        count.text = [self textForCellAtIndexPath:indexPath filterWithDays:30];
        break;
}

    [count sizeToFit];
    cell.accessoryView = count;
    return cell;
}


@end