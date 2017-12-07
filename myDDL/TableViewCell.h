//
//  TableViewCell.h
//  myDDL
//
//  Created by 周千惠 on 2017/12/5.
//  Copyright © 2017年 University of leeds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

//two labels in the cell are connected here
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
