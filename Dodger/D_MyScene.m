//
//  D_MyScene.m
//  Dodger
//
//  Created by Benjamin Myers on 5/9/14.
//  Copyright (c) 2014 AppGuys. All rights reserved.
//

#import "D_MyScene.h"

@implementation D_MyScene

NSDate *startDate;
NSTimer *stopWatchTimer;
NSTimeInterval secondsAlreadyRun;
int touchCount;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        int boxYStart;
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenHeight = screenSize.height;
        
        if (screenHeight < 568) {
            boxYStart = 440;
        } else {
            boxYStart = 528;
        }
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        _box = [SKSpriteNode spriteNodeWithImageNamed:@"box"];
        _box.name = boxCategoryName;
        _box.position = CGPointMake(160, 80);
        _box.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_box.frame.size];
        _box.physicsBody.dynamic = NO;
        _touchLocation.x = 160;
        _touchLocation.y = 80;
        
        [self addChild:_box];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    SKPhysicsBody *body = [self.physicsWorld bodyAtPoint:touchLocation];
    
    if (body && [body.node.name isEqualToString:boxCategoryName]) {
        self.isFingerOnBox = YES;
    }
    
    [self onStartPressed:self];
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    if (self.isFingerOnBox) {
        UITouch* touch = [touches anyObject];
        _touchLocation = [touch locationInNode:self];
        _previousLocation = [touch previousLocationInNode:self];
//        _boxX = _box.position.x + (_touchLocation.x - _previousLocation.x);
//        _boxY = _box.position.y + (_touchLocation.y  - _previousLocation.y);
        _boxX = _touchLocation.x;
        _boxY = _touchLocation.y;
        _boxX = MAX(_boxX, _box.size.width/2);
        _boxX = MIN(_boxX, self.size.width - _box.size.width/2);
        _boxY = MAX(_boxY, _box.size.height/2);
        _boxY = MIN(_boxY, self.size.height - _box.size.height/2);
    }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    self.isFingerOnBox = NO;
    [self onStopPressed:self];
}

-(void)showActivity:(NSTimer *)timer {
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
    // Add the saved interval
    timeInterval += secondsAlreadyRun;
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    NSLog(@"%@", timeString);
}

- (void)onStartPressed:(id)sender {
    
    stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1/10
                                                      target:self
                                                    selector:@selector(showActivity:)
                                                    userInfo:nil
                                                     repeats:YES];
    // Save the new start date every time
    startDate = [[NSDate alloc] init]; // equivalent to [[NSDate date] retain];
    [stopWatchTimer fire];
}

- (void)onStopPressed:(id)sender {
    // _Increment_ secondsAlreadyRun to allow for multiple pauses and restarts
    //secondsAlreadyRun += [[NSDate date] timeIntervalSinceDate:startDate];
    [stopWatchTimer invalidate];
    stopWatchTimer = nil;
    [self showActivity:stopWatchTimer];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    _box.position = CGPointMake(_touchLocation.x, _touchLocation.y);
    //NSLog(@"%f:%f", _touchLocation.x, _touchLocation.y);
}

@end
