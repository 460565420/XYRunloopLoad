//
//  XYRunloopLoad.h
//  Property
//
//  Created by xieqilin on 2018/6/12.
//  Copyright © 2018年 xieqilin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RunLoopBlcok)(void);
@interface XYRunloopLoad : NSObject

/** 最大任务数量 默认20*/
@property (nonatomic, assign) NSInteger maxCount;

+ (instancetype)instanceRunloopLoad;
//添加任务
- (void)addTask:(RunLoopBlcok)blcok;
- (void)removAllTask;

@end

@interface Timer : NSObject

//在使用XYRunloopLoad前开启timer
- (void)startTimer;
//页面销毁时  销毁timer
- (void)invalidateTimer;
@property (nonatomic, strong) NSTimer *timer;

@end

