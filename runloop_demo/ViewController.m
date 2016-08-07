//
//  ViewController.m
//  runloop_demo
//
//  Created by kevingao on 16/8/7.
//  Copyright © 2016年 kevingao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //设置视图
    [self setUpView];
}

//设置视图
- (void)setUpView{
    
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    //标题数组
    NSArray* title_array = [NSArray arrayWithObjects:
                            @"1.获取到当前线程的run loop(线程不安全)",
                            @"2.获取对应的CFRunLoopRef类(线程安全)",
                            @"3.成功驱动了一个run loop",
                            @"4.NSTimer 定时源 方法一",
                            @"5.NSTimer 定时源 方法二",
                            @"6.GCD 的timer",
                            @"7.RunLoop观察者",
                            @"8.Cocoa中使用任何performSelector…的方法",
                            @"9.常驻子线程，保持子线程一直处理事件",
                            nil];
    
    //创建10个按钮
    NSInteger index = 0;
    
    for (index = 0; index < [title_array count]; index++) {
        
        CGRect temp_rect = CGRectMake(30 + (index%2)*160, 60 + (index/2)*80, 150, 40);
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        button.tag = index;
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [button setTitle:[title_array objectAtIndex:index] forState:UIControlStateNormal];
        
        button.frame = temp_rect;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor blackColor];
        
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        
        button.contentMode = UIViewContentModeLeft;
        
        [self.view addSubview:button];
    }
    
}

//按钮点击事件
- (void)buttonClicked:(UIButton*)button{
    
    //标题数组
    NSArray* title_array = [NSArray arrayWithObjects:
                            @"1.获取到当前线程的run loop(线程不安全)",
                            @"2.获取对应的CFRunLoopRef类(线程安全)",
                            @"3.成功驱动了一个run loop",
                            @"4.NSTimer 定时源 方法一",
                            @"5.NSTimer 定时源 方法二",
                            @"6.GCD 的timer",
                            @"7.RunLoop观察者",
                            @"8.Cocoa中使用任何performSelector…的方法",
                            @"9.常驻子线程，保持子线程一直处理事件",
                            nil];
    
    NSLog(@"%@",[title_array objectAtIndex:button.tag]);
    
    switch (button.tag) {
        case 0:
        {
            //1.获取到当前线程的run loop(线程不安全)
        
            NSRunLoop* runloop = [NSRunLoop currentRunLoop];
            
            NSLog(@"%@",runloop);
            
        }
            break;
        case 1:
        {
            //"2.获取对应的CFRunLoopRef类(线程安全)",

            CFRunLoopRef ref = [[NSRunLoop currentRunLoop] getCFRunLoop];
            
            NSLog(@"%@",ref);
        }
            break;
        case 2:
        {
            //3.成功驱动了一个run loop
            
            BOOL isRunning = NO;
            
            NSInteger count = 0;
            
            do {
                
                isRunning = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                count++;
                
                NSLog(@"isRunning : %d",isRunning);
                
                if (count == 20) {
                    
                    isRunning = NO;
                }
                
            } while (isRunning);
            
            NSLog(@"isRunning 结束");
        }
            break;
        case 3:
        {
            //4.NSTimer 定时源 方法一
            
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(backgroundThreadFire:)
                                                            userInfo:nil
                                                             repeats:YES];
            
            //将timer添加到runloop
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }
            break;
        case 4:
        {
            //5.NSTimer 定时源 方法二
            
            NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(backgroundThreadFire:)
                                                   userInfo:nil
                                                    repeats:YES];
            
            //将timer添加到runloop
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }
            break;
        case 5:
        {
            //6.GCD 的timer
            
            //回调block
            void (^setBlock) (void) = ^ {
                
                //在这里执行事件
                [self executeAction];
            };
            
            NSTimeInterval period = 1.0; //设置时间间隔
            
            //标示
            const char* identifier = "com.kevingao.serialQueue";

            //主线程
            dispatch_queue_t temp_queue = dispatch_queue_create(identifier, NULL);
            
            //源
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, temp_queue);
            
            //每1.0秒执行
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
            
            //设置操作回调
            dispatch_source_set_event_handler(_timer, setBlock);
            
            //恢复源
            dispatch_resume(_timer);
        }
            break;
        case 6:
        {
            //7.RunLoop观察者
            
//            NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
//            
//            // Create a run loop observer and attach it to the runloop.
//            
//            CFRunLoopObserverContext  context = {0, (__bridge void *)(self), NULL, NULL, NULL};
//            
//            CFRunLoopObserverCallBack callback = 
//            
//            CFRunLoopObserverRef  observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
//                                                                     kCFRunLoopBeforeTimers,
//                                                                     YES,
//                                                                     0,
//                                                                     &myRunLoopObserver,
//                                                                     &context);
//            
//            if (observer)
//            {
//                CFRunLoopRef  cfLoop = [myRunLoop getCFRunLoop];
//                
//                CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
//            }
        }
            break;
        case 7:
        {
            //8.Cocoa中使用任何performSelector…的方法
            
            [self performSelector:@selector(executeAction) withObject:nil afterDelay:1.0];
            
        }
            break;
        case 8:
        {
            //9.常驻子线程，保持子线程一直处理事件
            
        }
            break;
        default:
            break;
    }

}

- (void)executeAction{

    NSLog(@"executeAction");
}

- (void)backgroundThreadFire:(NSTimer*)timer{

    NSLog(@"%@",timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
