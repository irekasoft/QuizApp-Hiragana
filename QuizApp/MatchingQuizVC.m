//
//  ViewController.m
//  QuizApp
//
//  Created by Muhammad Hijazi  on 29/9/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import "MatchingQuizVC.h"
#import "QSItem.h"

@interface MatchingQuizVC ()

@end

@implementation MatchingQuizVC

#pragma mark -

- (void)setupData{
    
    // load
    NSArray *loadDataFile = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MatchQuiz1" ofType:@"csv"] encoding:NSUTF8StringEncoding error:NULL]
                             componentsSeparatedByString:@"\r"];
    
    NSLog(@"loadDataFile %@",loadDataFile);
    
    self.dataDict = [[NSMutableDictionary alloc] init];
    self.dataArray = [NSMutableArray array];
    NSArray *keys = [loadDataFile[0] componentsSeparatedByString:@","];
    
    for (int i = 1; i < [loadDataFile count]; i++) {
        NSArray *array = [loadDataFile[i] componentsSeparatedByString:@","];
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        for (int j = 0; j < [keys count] ; j++) {
            [tempDict setObject:array[j] forKey:keys[j]];
        }
        [self.dataArray addObject:tempDict];
    }
    //NSLog(@"self %@",self.dataArray);
}

- (NSMutableArray *)generateArrayNumberWithNo:(int)num{
    
    NSMutableArray *putNumberUsed = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= num; i++) {
        [putNumberUsed addObject:@(i)];
    }
    return putNumberUsed;
}

- (NSMutableArray *)shuffleMutArray:(NSMutableArray *)array{
    // shuffle
    for (int i = 0; i < array.count; i++) {
        int randomInt1 = arc4random() % [array count];
        int randomInt2 = arc4random() % [array count];
        [array exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
    }
    return array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupData];

    // this qustion is fixed for 4 question only
    // setup questions label
    for (UILabel *label in self.questionLabels){
        //NSLog(@"log %d", label.tag);
        label.text = self.dataArray[label.tag-1][@"question"];
    }
    
    NSMutableArray *putNumberUsed = [self generateArrayNumberWithNo:4];
    putNumberUsed = [self shuffleMutArray:putNumberUsed];
    
    NSLog(@"array %@",putNumberUsed);

    self.correctAnswers = [NSMutableDictionary dictionary];

    // looping the answer
    for (QSItem *item in self.answerItems) {
        NSLog(@"item.tag %ld",item.tag);
        int idx = [putNumberUsed[item.tag-1] intValue] - 1;
        NSString *strg = [NSString stringWithFormat:@"%@",self.dataArray[idx][@"answer"]];
        [item setTitle:strg forState:UIControlStateNormal];
    }
    
    
    for (int i = 0; i < [self.dataArray count] ; i++){
        int a = [putNumberUsed[i] intValue];
        [self.correctAnswers setValue:@(i+1) forKey:[NSString stringWithFormat:@"%d",a]];
    }
    
    NSLog(@"correct ans %@", self.correctAnswers);
    
    // track the qs item original coordinate
    for (id view in [self.view subviews]){
        
        if ([view isKindOfClass:[QSItem class]]) {
            
            QSItem *item = (QSItem *)view;
            item.originalPoint = item.center;
            item.currentPoint = item.originalPoint;
            [item addTarget:self action:@selector(wasDragged:forEvent:) forControlEvents:UIControlEventTouchDragInside];
            [item addTarget:self action:@selector(wasTouchedUp:forEvent:) forControlEvents:UIControlEventTouchUpInside];
            [item addTarget:self action:@selector(wasTouchedUp:forEvent:) forControlEvents:UIControlEventTouchUpOutside];

        }
   }
}



- (NSMutableDictionary *)answeringDictionary{
    
    if (!_answeringDictionary) {
        _answeringDictionary = [NSMutableDictionary dictionary];
        for (NSString *key in [self.correctAnswers allKeys]){
            [_answeringDictionary setObject:@(0) forKey:key];
        }
    }
    return _answeringDictionary;
}


#pragma mark

- (IBAction)wasDragged:(id)sender forEvent:(UIEvent *)event {
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"wasDragged %@", NSStringFromCGRect(button.frame));
    // get the touch
    if ([button isKindOfClass:[QSItem class]]){
        if (!isTouched) {
            originalPoint = button.center;
            isTouched = YES;
        }
        
        UITouch *touch = [[event touchesForView:button] anyObject];
        
        // get delta
        CGPoint previousLocation = [touch previousLocationInView:button];
        CGPoint location = [touch locationInView:button];
        CGFloat delta_x = location.x - previousLocation.x;
        CGFloat delta_y = location.y - previousLocation.y;
        
        // move button
        button.center = CGPointMake(button.center.x + delta_x,
                                    button.center.y + delta_y);
        
        
    }
    
    
}

- (IBAction)wasTouchedUp:(id)sender forEvent:(UIEvent *)event
{
    NSLog(@"wasTouchedUp %@  ", self.correctAnswers);
    QSItem *button = (QSItem *)sender;
    BOOL isIntersec = NO;
    
    // checking for the answer
    // to remove unneeded right or wrong
    for (id view in [self.view subviews]){
        
        if ([view isKindOfClass:[AnswerBox class]]) {
            
            AnswerBox *answerBox = (AnswerBox *)view;
            NSLog(@"intersec");
            if (CGRectIntersectsRect(button.frame, answerBox.frame)){

                // NSLog(@"dict %@",self.answeringDictionary);
                // if there is stuff there please snap
                // snapping UI
                int currentState = [[self.answeringDictionary objectForKey:[NSString stringWithFormat:@"%ld",answerBox.tag]] intValue];
                
                //NSLog(@"my current state %d",currentState);
                
                // kotak kosong
                if (currentState == 0) {
                    [UIView animateWithDuration:0.2 animations:^{
                        button.center = answerBox.center;
                    }];
                    [self resetAnsweringDictWithTag:button.tag];
                    [self.answeringDictionary setObject:@(button.tag) forKey:[NSString stringWithFormat:@"%ld",answerBox.tag]];
                    
                // kotak ada barang
                } else if (currentState > 0 && currentState != button.tag){
                    
                    //NSLog(@"kotak berisi");
                    [UIView animateWithDuration:0.2 animations:^{
                        button.center = button.originalPoint;
                    }];
                    
                    [self resetAnsweringDictWithTag:button.tag];

                }else if(currentState > 0 && currentState == button.tag){
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        button.center = answerBox.center;
                    }];
                    
                }
                

                button.currentPoint = answerBox.center;
                isIntersec = YES;
            }
            
            
            
        }
    }
    
    // is not intersec
    if (isIntersec == NO) {
        
        [UIView animateWithDuration:0.6 animations:^{
            button.center = button.originalPoint;
            isTouched = NO;
        }];
        
        [self resetAnsweringDictWithTag:button.tag];
    }
    // NSLog(@"edit %@",self.answeringDictionary);
    // need to always update
}

- (void)resetAnsweringDictWithTag:(NSInteger)tag{

    // clear the previous one
    // reset
    for (NSString *key in [self.answeringDictionary allKeys]) {
        
        int a = [[self.answeringDictionary objectForKey:key] intValue];
        
        //NSLog(@"check %d->%d",a,tag);
        if (a == tag) {
            
            [self.answeringDictionary setObject:@(0) forKey:key];
            
        }
        
    }    
    
}

#define PLS_COMPLETE_MSG @"Sila penuhkan ruang kosong"

- (IBAction)check:(id)sender
{
    
    int answeringCount = 0; // initiate
    NSLog(@"check %@",self.answeringDictionary);
    
    // check the stored in ansering dict
    for (NSString *key in [self.answeringDictionary allKeys]){
        BOOL answered = [self.answeringDictionary[key] boolValue];
        if (answered) answeringCount++;
    }
    
    // if the answer is less
    if (answeringCount < [self.answeringDictionary count]) {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PLS_COMPLETE_MSG message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
        
       
        for (NSString *key in [self.answeringDictionary allKeys]) {
            UIImageView *imageView = [self findClass:[RightWrongImageView class] withTag:[key intValue]];
            [imageView setBackgroundColor:[UIColor clearColor]];
        }
        
        
         return;
    }
    
    

    
    
    NSInteger questionCount = [self.answeringDictionary count];
    int correctCount = 0;
    
    for (NSString *key in [self.answeringDictionary allKeys]) {
        
        NSString *value = self.answeringDictionary[key];
        UIImageView *imageView = [self findClass:[RightWrongImageView class] withTag:[key intValue]];
        
        int correctAnsIdx = [self.correctAnswers[key] intValue];
        
        // correct
        if (correctAnsIdx == [value intValue]) {
            
            [imageView setBackgroundColor:[UIColor greenColor]];
            correctCount++;
            
            // wrong
        }else{
            [imageView setBackgroundColor:[UIColor redColor]];
            
        }
    }

    NSString *msg = [NSString stringWithFormat:@"%d / %ld", correctCount, questionCount];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jawapan" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    
//    [alert show];
 
    
}

- (IBAction)reset:(id)sender {
    
    for (NSString *key in [self.answeringDictionary allKeys]) {
        
        UIImageView *imageView = [self findClass:[RightWrongImageView class] withTag:[key intValue]];
       [imageView setBackgroundColor:[UIColor clearColor]];
    }
    
    NSMutableArray *putNumberUsed = [NSMutableArray arrayWithArray:@[@(1),@(2),@(3),@(4)]];
    
    for (int i = 0; i < putNumberUsed.count; i++) {
        int randomInt1 = arc4random() % [putNumberUsed count];
        int randomInt2 = arc4random() % [putNumberUsed count];
        [putNumberUsed exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
    }
    
    self.correctAnswers = [NSMutableDictionary dictionary];
    
    // looping the answer
    for (QSItem *item in self.answerItems) {
        
        NSLog(@"%ld",item.tag);
        int idx = [putNumberUsed[item.tag-1] intValue] - 1;
        
        NSString *strg = [NSString stringWithFormat:@"%@",self.dataArray[idx][@"answer"]];
        
        [item setTitle:strg forState:UIControlStateNormal];
        
        
    }
    
    
    for (int i = 0; i < [self.dataArray count] ; i++){
        
        int a = [putNumberUsed[i] intValue];
        
        
        [self.correctAnswers setValue:@(i+1) forKey:[NSString stringWithFormat:@"%d",a]];
    }
    
    NSLog(@"correct ans %@", self.correctAnswers);
    
    // track the qs item original coordinate
    for (id view in [self.view subviews]){
        
        if ([view isKindOfClass:[QSItem class]]) {
            
            QSItem *item = (QSItem *)view;

            [UIView animateWithDuration:0.6 animations:^{
               
                item.center = item.originalPoint;
                
            }];
            
            
        }
        
    }
    
    for (NSString *key in [self.answeringDictionary allKeys]) {
        
        
        [self.answeringDictionary setObject:@(0) forKey:key];

        
    }
    
}

#pragma mark - helper

- (id)findClass:(Class)class withTag:(int)tag{

    for (UIView *view in [self.view subviews]){
        if ([view isKindOfClass:[class class]] && view.tag == tag) {
            return view;
        }
    }
    
    return nil;
    
}

#pragma mark -

- (IBAction)closePanel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
@end
