//
//  ViewController.h
//  QuizApp
//
//  Created by Muhammad Hijazi  on 29/9/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

/*

 7-oct-2013: what we have to do is to reset / have the notification when cheking.

 */
#import <UIKit/UIKit.h>
#import "AnswerBox.h"
#import "RightWrongImageView.h"
#import "QSItem.h"
#import "NSArray+Random.h"

@interface MatchingQuizVC : UIViewController  {

    CGPoint originalPoint;
    BOOL isTouched;


}

@property (strong, nonatomic) NSMutableDictionary *dataDict;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *questionLabels;

@property (strong, nonatomic) IBOutletCollection(QSItem) NSArray *answerItems;


@property (strong, nonatomic) NSDictionary *correctAnswers;
@property (strong, nonatomic) NSMutableDictionary *answeringDictionary;


@end
