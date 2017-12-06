//
//  viewController.m
//  myDDL
//
//  Created by 周千惠 on 2017/12/5.
//  Copyright © 2017年 University of leeds. All rights reserved.
//

#import "viewController.h"
#import "ClassModel.h"
#import "TableViewCell.h"
#import "DetailViewController.h"

@interface viewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation viewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newCourseNoti:) name:@"ddLButtonClick" object:nil];
}

- (void)newCourseNoti:(NSNotification *)notify {
    NSLog(@"%@", notify.userInfo);
    ClassModel *model = notify.userInfo[@"model"];
    [self.dataArray addObject:model];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ClassModel *model = self.dataArray[indexPath.row];
    NSMutableString *stirng = [[NSMutableString alloc] initWithString:model.time];
    NSString *result = [stirng substringWithRange:NSMakeRange(0, 10)];
    
    cell.nameLabel.text = model.name;
    cell.timeLabel.text = [self intervalSinceNow:model.time];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassModel *model = self.dataArray[indexPath.row];
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=late-now;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ mins", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ hours", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ days", timeString];
        
    }
    
    return timeString;
}

- (NSString *)compareCurrentTime:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    NSLog(@"%f", timeInterval);
    timeInterval = -timeInterval;
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"just now"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld mins before",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld hours ago",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld days ago",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld months ago",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld years ago",temp];
    }
    return  result;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
