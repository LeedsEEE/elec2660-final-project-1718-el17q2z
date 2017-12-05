//
//  DetailViewController.m
//  myDDL
//
//  Created by 周千惠 on 2017/12/5.
//  Copyright © 2017年 University of leeds. All rights reserved.
//

#import "DetailViewController.h"
#import "ClassModel.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.label1.text = self.model.name;
    self.label2.text = self.model.time;
    self.label3.text = self.model.type;
    self.label4.text = self.model.submit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
