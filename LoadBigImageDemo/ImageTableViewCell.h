//
//  ImageTableViewCell.h
//  LoadBigImageDemo
//
//  Created by xieqilin on 2018/6/13.
//  Copyright © 2018年 xieqilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *index;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end
