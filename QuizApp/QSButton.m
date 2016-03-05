//
//  QSButton.m
//  QuizApp
//
//  Created by Muhammad Hijazi  on 8/10/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import "QSButton.h"

@implementation QSButton

@synthesize hue;
@synthesize saturation;
@synthesize brightness;
@synthesize normalColor, highlightedColor;
@synthesize customText;

// Delete initWithFrame and add the following:
-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.opaque = NO;
		self.normalColor = self.backgroundColor;
        self.backgroundColor = [UIColor clearColor];
        
		hue = 0.2;
        saturation = 0.2;
        brightness = 0.3;
        
		if (!self.highlightedColor) {
			self.highlightedColor = [UIColor blackColor];
			self.highlightedColor = self.titleLabel.shadowColor;
            
		}
        
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // if given a specific label override it
    // if not, just use from IB
    UILabel *aLabel;
    
    //    if (aLabel == nil) {
    aLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 80, 20)];
    aLabel.text = customText;
    
    aLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:aLabel];
    
    //    }
    
	//NSLog(@"aa%@",[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0].CGColor);
	//NSLog(@"aa%@", self.normalColor);
	radius = 15.0;

	   
    [self.normalColor setFill];
    [self.highlightedColor setStroke];
    
    CGFloat outerMargin = 2;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);


    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:outerRect cornerRadius:8.0f];

    [roundedRectPath setLineWidth:0.5];
    
	if (self.state != UIControlStateHighlighted) {
        
        [roundedRectPath stroke];
		
	}else {
		
        [[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.8] setFill];
		[roundedRectPath fill];
        [roundedRectPath stroke];
	}
    
}

#pragma mark - c

CGMutablePathRef createRoundedRectForRect2(CGRect rect, CGFloat radius) {
	
    CGMutablePathRef path = CGPathCreateMutable();
	
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect),
						CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect),
						CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect),
						CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect),
						CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
	
    return path;
}

// Add the following methods to the bottom
- (void)hesitateUpdate
{
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}


@end