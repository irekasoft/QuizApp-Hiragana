//
//  NSArray+Random.m
//  QuizApp
//
//  Created by Muhammad Hijazi  on 11/10/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import "NSArray+Random.h"

@implementation NSArray (Random)

- (NSArray *)randomItemsForSize:(int)number startFrom:(int)startNo{
    
    NSMutableArray *pickedArray = [NSMutableArray array];
    
    int remaining = number;
    
    if ( [self count] >= remaining )
    {
        
        while (remaining > 0)
        {
            
            id name = [self objectAtIndex:(arc4random() % ([self count] - 1)) + 1];
            
            if ( ! [pickedArray containsObject: name] )
            {
                [pickedArray addObject: name];
                remaining --;
            
            }
        
        }
    
    }
    
    return [NSArray arrayWithArray:pickedArray];
}

- (NSArray *)randomItemsForSize:(int)number{
    
    NSMutableArray *pickedArray = [NSMutableArray array];
    
    int remaining = number;
    
    if ( [self count] >= remaining )
    {
        while (remaining > 0)
        {
            id name = [self objectAtIndex: arc4random() % [self count]];
            
            if ( ! [pickedArray containsObject: name] )
            {
                [pickedArray addObject: name];
                remaining --;
            }
        }
    }
    
    return [NSArray arrayWithArray:pickedArray];
}

- (NSArray *)shuffleArray{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    
    for (int i = 0; i < array.count; i++) {
        int randomInt1 = arc4random() % [array count];
        int randomInt2 = arc4random() % [array count];
       
        [array exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
    }
 

    return [NSArray arrayWithArray:array];
}

@end
