//
//  FirstViewController.m
//  myDDL
//
//  Created by 周千惠 on 2017/11/28.
//  Copyright © 2017年 University of leeds. All rights reserved.
//

#import "addViewController.h"
#import "ClassModel.h"

@interface addViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, copy) NSString *type;

//four textfields
@property (weak, nonatomic) IBOutlet UITextField *courseTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextField *submitTextField;

//all arrays needed for the time picker
@property (nonatomic, strong) NSArray *yearArray;
@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, strong) NSArray *dayArray;
@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) NSArray *minArray;
@property (nonatomic, strong) NSArray *secondArray;

//variables for the 'time' text field
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *min;
@property (nonatomic, copy) NSString *second;

//arrays needed for the other 3 picker
@property (nonatomic, strong) NSArray *courseArray;
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) NSArray *submitArray;

@end

@implementation addViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.type = @"course";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//hide the navigation bar
//the navigation bar is not needed in this view
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

//four buttons are connected together, each button connected to one picker
- (IBAction)courseButtonClick:(UIButton *)button {
    [self.pickView removeFromSuperview];
    if (button.tag == 100) {            //the first button
        self.type = @"course";
    } else if (button.tag == 101) {     //the second button
        self.type = @"time";
    } else if (button.tag == 102) {     //the third button
        self.type = @"type";
    } else if (button.tag == 103) {     //the fourth button
        self.type = @"submit";
    }                                   //different tag were set for each button
    [self.view addSubview:self.pickView];
    [self.pickView reloadAllComponents];
}

//this button send all the details in 4 textfields to model
//the details are saved in the ClassModel
- (IBAction)ddLButtonClick:(UIButton *)sender {
    ClassModel *model = [[ClassModel alloc] init];
    model.name = self.courseTextField.text;
    model.time = self.timeTextField.text;
    model.type = self.typeTextField.text;
    model.submit = self.submitTextField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ddLButtonClick" object:nil
    userInfo:@{@"model": model}];
}

//the time picker need 6 components, but only 1 is enough for others
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([self.type isEqualToString:@"course"]) {       //the first picker
        return 1;
    } else if ([self.type isEqualToString:@"time"]) {  //the second picker
        return 6;
    } else {
        return 1;                                      //the last two pickers
    }
    
}

//define number of rows in each components for pickers
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([self.type isEqualToString:@"course"]) {
        return self.courseArray.count; //which is 5
    } else if ([self.type isEqualToString:@"time"]) {
        if (component == 0) {
            return self.yearArray.count; //which is 5
        } else if (component == 1) {
            return self.monthArray.count; //which is 12
        } else if (component == 2) {
            return self.dayArray.count; //which is 31
        } else if (component == 3) {
            return self.hourArray.count; //which is 24
        } else if (component == 4) {
            return self.minArray.count; //which is 60
        } else {
            return self.secondArray.count; //which is also 60
        }
    } else if ([self.type isEqualToString:@"type"]) {
        return self.typeArray.count; //which is 5
    } else  {
        return self.submitArray.count; //which is 2
    }
}

//define the content in each row for the picker
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.type isEqualToString:@"course"]) {
        return self.courseArray[row];
    } else if ([self.type isEqualToString:@"time"]) {
        if (component == 0) {
            return self.yearArray[row];
        } else if (component == 1) {
            return self.monthArray[row];
        } else if (component == 2) {
            return self.dayArray[row];
        } else if (component == 3) {
            return self.hourArray[row];
        } else if (component == 4) {
            return self.minArray[row];
        } else {
            return self.secondArray[row];
        }
    } else if ([self.type isEqualToString:@"type"]) {
        return self.typeArray[row];
    } else {
        return self.submitArray[row];
    }
}

//connect each picker to the text field (sent the details user selected to the text field)
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([self.type isEqualToString:@"course"]) {
        self.courseTextField.text = self.courseArray[row];
    } else if ([self.type isEqualToString:@"time"]) {
        if (component == 0) {
            self.year = self.yearArray[row];
        } else if (component == 1) {
            self.month = self.monthArray[row];
        } else if (component == 2) {
            self.day = self.dayArray[row];
        } else if (component == 3) {
            self.hour = self.hourArray[row];
        } else if (component == 4) {
            self.min = self.minArray[row];
        } else {
            self.second = self.secondArray[row];
        }
        //each component for the time picker are connected to each string(year/month/day/hour/min/second)
        //then they are shown in the text field
        self.timeTextField.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@", self.year, self.month, self.day, self.hour, self.min, self.second];
    } else if ([self.type isEqualToString:@"type"]) {
        self.typeTextField.text = self.typeArray[row];
    } else {
        self.submitTextField.text = self.submitArray[row];
    }
}

//define the size and position of picker view
- (UIPickerView *)pickView {
    if (_pickView == nil) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 150)];
        _pickView.dataSource = self;
        _pickView.delegate = self;
    }
    return _pickView;
}

//array for the course picker
- (NSArray *)courseArray {
    if (_courseArray == nil) {
        _courseArray = [NSArray arrayWithObjects:@"ELEC2240", @"ELEC2660", @"ELEC2130", @"ELEC2430", @"ELEC2530", nil];
    }
    return _courseArray;
}

//arrays for the time picker
- (NSArray *)yearArray {
    if (_yearArray == nil) {
        _yearArray = [NSArray arrayWithObjects:@"2015", @"2016", @"2017", @"2018", @"2019", nil];
    }
    return _yearArray;
}
- (NSArray *)monthArray {
    if (_monthArray == nil) {
        _monthArray = [NSArray arrayWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12",nil];
    }
    return _monthArray;
}
- (NSArray *)dayArray {
    if (_dayArray == nil) {
        _dayArray = [NSArray arrayWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", nil];
    }
    return _dayArray;
}
- (NSArray *)hourArray {
    if (_hourArray == nil) {
        _hourArray = [NSArray arrayWithObjects:@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24",  nil];
    }
    return _hourArray;
}
- (NSArray *)minArray {
    if (_minArray == nil) {
        _minArray = [NSArray arrayWithObjects:@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24",  @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59", @"60", nil];
    }
    return _minArray;
}
- (NSArray *)secondArray {
    if (_secondArray == nil) {
        _secondArray = [NSArray arrayWithObjects:@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24",  @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59", @"60", nil];
    }
    return _secondArray;
}

//array for the type picker
- (NSArray *)typeArray {
    if (_typeArray == nil) {
        _typeArray = [NSArray arrayWithObjects:@"Problem Sheet", @"Lab Report", @"Document", @"Essay", @"Other", nil];
    }
    return _typeArray;
}

//array for the submit picker
- (NSArray *)submitArray {
    if (_submitArray == nil) {
        _submitArray = [NSArray arrayWithObjects:@"Online", @"Mailbox", nil];
    }
    return _submitArray;
}

@end
