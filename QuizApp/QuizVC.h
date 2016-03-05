//
//  QuizVC.h
//  QuizApp
//
//  Created by Muhammad Hijazi  on 1/10/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCSVParser.h"
#import "QSButton.h"
#import "NSArray+Random.h"

@interface QuizVC : UIViewController <CHCSVParserDelegate, UIAlertViewDelegate> {
    
    NSMutableArray *_lines;
    NSMutableArray *_currentLine;
    NSArray *selectedItems;
    NSArray *shuffledArray;
    
    BOOL isCorrect;
    int correctCount;
}

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutletCollection(QSButton) NSArray *answerButtons;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end