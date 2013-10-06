//
//  ListTVC.h
//  QuizApp
//
//  Created by Muhammad Hijazi  on 2/10/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCSVParser.h"

@interface ListTVC : UITableViewController <CHCSVParserDelegate>{
    
    NSMutableArray *_lines;
    NSMutableArray *_currentLine;
    
}



@end