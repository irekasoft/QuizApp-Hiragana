//
//  QSButton.h
//  QuizApp
//
//  Created by Muhammad Hijazi  on 8/10/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSButton : UIButton {
    
	UIColor *normalColor;
	UIColor *highlightedColor;
	
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
	
	float	radius;
    
    NSString *customText;
	
}

@property (nonatomic, retain) NSString *customText;
@property (nonatomic, retain) 	UIColor *normalColor;
@property (nonatomic, retain) 	UIColor *highlightedColor;
@property  CGFloat hue;
@property  CGFloat saturation;
@property  CGFloat brightness;

@end
