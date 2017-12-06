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

//connect the table view with this file
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

//connect the dataArray(for each cell) with the ClassModel
- (void)newCourseNoti:(NSNotification *)notify {
    NSLog(@"%@", notify.userInfo);
    ClassModel *model = notify.userInfo[@"model"];
    [self.dataArray addObject:model];
    [self.tableView reloadData];
}

//hide the navigation bar in the view controller on the right hand side
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

//show the navigation bar in the detail view controller
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//define each row in the table view (connect dataArray with cells)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//connect the file 'TableViewCell'
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ClassModel *model = self.dataArray[indexPath.row];
    NSMutableString *stirng = [[NSMutableString alloc] initWithString:model.time];
    NSString *result = [stirng substringWithRange:NSMakeRange(0, 10)];
    
    //define the 2 labels in the cell
    cell.nameLabel.text = model.name;
    cell.timeLabel.text = [self intervalSinceNow:model.time];
    return cell;
}

//a method to delete the countdown that the user don't need
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the data
        [_dataArray removeObjectAtIndex:indexPath.row];
        //remove the data in the table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//?????
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClassModel *model = self.dataArray[indexPath.row];
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}



//a method to calculate the time interval
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:00:00"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=late-now;
    
    //if the time interval is less than 1 hour
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ mins", timeString];
        
    }
    //if the time interval is less than 1 day
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ hours", timeString];
    }
    //if the time interval is more than 1 day
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ days", timeString];
        
    }
    return timeString;
}

//when the user select a time which has passed
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
