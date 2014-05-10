//
//  D_MyScene.h
//  Dodger
//

//  Copyright (c) 2014 AppGuys. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static NSString* boxCategoryName = @"box";

@interface D_MyScene : SKScene

// UI Properties
@property (nonatomic) SKSpriteNode *box;

// Variable Properties
@property (nonatomic) BOOL isFingerOnBox;
@property (nonatomic) CGPoint touchLocation;
@property (nonatomic) CGPoint previousLocation;
@property (nonatomic) int boxX;
@property (nonatomic) int boxY;

@end
