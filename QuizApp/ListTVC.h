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


@interface MyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *romaji;
@property (weak, nonatomic) IBOutlet UILabel *hiragana;
@property (weak, nonatomic) IBOutlet UILabel *hiraganaExample;
@property (weak, nonatomic) IBOutlet UILabel *hira_romaji;

@end

@implementation MyCell

@end