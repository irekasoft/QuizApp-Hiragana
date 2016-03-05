//
//  CardCell.h
//  QuizApp
//
//  Created by Hijazi on 1/31/14.
//  Copyright (c) 2014 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *foreignLbl;
@property (weak, nonatomic) IBOutlet UILabel *pronounceLbl;
@property (weak, nonatomic) IBOutlet UILabel *hiraganaExample;
@property (weak, nonatomic) IBOutlet UILabel *hira_romaji;
@end
