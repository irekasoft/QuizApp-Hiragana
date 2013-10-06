//
//  QSItem.h
//  MyStoryBook
//
//  Created by Muhammad Hijazi  on 29/9/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSItem : UIButton

@property (nonatomic, assign) CGPoint originalPoint;

@property (nonatomic, assign) CGPoint currentPoint;

@property (nonatomic, assign) int locationNumber;

@end
