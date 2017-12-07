//
//  DetailViewController.h
//  myDDL
//
//  Created by 周千惠 on 2017/12/5.
//  Copyright © 2017年 University of leeds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassModel;

@interface DetailViewController : UIViewController

//ClassModel is used in the DetailViewController
@property (nonatomic, strong) ClassModel *model;

@end
