//
//  ViewController.m
//  LoadBigImageDemo
//
//  Created by xieqilin on 2018/6/13.
//  Copyright © 2018年 xieqilin. All rights reserved.
//

#import "ViewController.h"
#import "ImageTableViewCell.h"
#import "XYRunloopLoad.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#Description#>*/
@property (nonatomic, copy) NSArray *images;

/** <#注释#> */
@property (nonatomic, strong) Timer *timer;

@end
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = [[Timer alloc] init];
    [self.timer startTimer];
    self.images = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidateTimer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImageTableViewCell class]) forIndexPath:indexPath];
//    cell.index.text = [NSString stringWithFormat:@"%@",@(indexPath.row)];
//    NSInteger index = arc4random() % 9;
//    cell.bgImage.image = LOADIMAGE(self.images[index], @".jpg");
    //注意内存的变化
    for (NSIndexPath *index in [tableView indexPathsForVisibleRows]) {
        if ([indexPath isEqual:index]) {
            [[XYRunloopLoad instanceRunloopLoad] addTask:^{
                cell.index.text = [NSString stringWithFormat:@"%@",@(indexPath.row)];
                NSInteger index = arc4random() % 9;
                cell.bgImage.image = LOADIMAGE(self.images[index], @".jpg");
            }];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageTableViewCell class]) bundle:NSBundle.mainBundle] forCellReuseIdentifier:NSStringFromClass([ImageTableViewCell class])];
    }
    return _tableView;

}


@end
