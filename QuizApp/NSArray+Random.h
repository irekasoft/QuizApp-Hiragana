//
//  NSArray+Random.h
//  QuizApp
//
//  Created by Muhammad Hijazi  on 11/10/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Random)

- (NSArray *)randomItemsForSize:(int)number;


- (NSArray *)randomItemsForSize:(int)number startFrom:(int)startNo;
- (NSArray *)shuffleArray;


@end
