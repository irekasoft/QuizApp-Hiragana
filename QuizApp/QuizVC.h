//
//  QuizVC.h
//  QuizApp
//
//  Created by Muhammad Hijazi  on 1/10/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCSVParser.h"

@interface QuizVC : UIViewController <CHCSVParserDelegate> {
    
    NSMutableArray *_lines;
    NSMutableArray *_currentLine;
    
}

@end