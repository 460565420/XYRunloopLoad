//
//  XYRunloopLoad.m
//  Property
//
//  Created by xieqilin on 2018/6/12.
//  Copyright © 2018年 xieqilin. All rights reserved.
//

#import "XYRunloopLoad.h"

@implementation Timer

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerMethed) userInfo:nil repeats:YES];
}

//什么都不做
- (void)timerMethed {
    NSLog(@"timerMethed");
}

- (void)invalidateTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
    self.timer = nil;
}

@end

@interface XYRunloopLoad()

/** 存放任务的数组*/
@property (nonatomic, strong) NSMutableArray *tasks;
/** 单列的runloop不用释放  在不同页面可以使用同一个runloop*/
@property (nonatomic, assign) CFRunLoopRef runloop;

@end

@implementation XYRunloopLoad

- (void)removAllTask {
    [self.tasks removeAllObjects];
}

- (void)addTask:(RunLoopBlcok)blcok {
    [self.tasks addObject:blcok];
    if (self.tasks.count > self.maxCount) {
        [self.tasks removeObjectAtIndex:0];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addRunLoop];
        self.tasks = [@[] mutableCopy];
        self.maxCount = 20;
    }
    return self;
}

+ (instancetype)instanceRunloopLoad {
    static XYRunloopLoad *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XYRunloopLoad alloc] init];
    });
    return instance;
}

- (void)addRunLoop {
    self.runloop = CFRunLoopGetCurrent();
    //定义一个上下文   （当前的执行环境？）
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };

    //定义观察者
    /*
     CFOptionFlags activities 就是上面的类型
     <#Boolean repeats#>   重复
     <#CFRunLoopObserverCallBack callout#> 回调的指针
     <#CFRunLoopObserverContext *context#> 上下文 传递参数用
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &context);
    CFRunLoopAddObserver(self.runloop, observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    XYRunloopLoad * runloopLoad = (__bridge XYRunloopLoad *)info;

    if (runloopLoad.tasks.count == 0){
        return;
    }
    NSLog(@"%ld", runloopLoad.tasks.count);

    RunLoopBlcok block = runloopLoad.tasks.firstObject;
    block();
    [runloopLoad.tasks removeObjectAtIndex:0];
}

@end
