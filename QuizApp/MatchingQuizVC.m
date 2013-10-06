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
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    NSString *file = [[NSBundle mainBundle]                                         pathForResource:@"MatchingQuiz1" ofType:@"plist"];
    
    NSArray *plistDict = [[NSArray alloc]
                          initWithContentsOfFile:file];
    
    
    NSLog(@"string %@",plistDict);


    
    // track the qs item original coordinate
    for (id view in [self.view subviews]){
        
        if ([view isKindOfClass:[QSItem class]]) {
            
            QSItem *item = (QSItem *)view;
            item.originalPoint = item.center;
            item.currentPoint = item.originalPoint;
            [item addTarget:self action:@selector(wasDragged:forEvent:) forControlEvents:UIControlEventTouchDragInside];
            [item addTarget:self action:@selector(wasTouchedUp:forEvent:) forControlEvents:UIControlEventTouchUpInside];
            
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

- (NSDictionary *)correctAnswers{
    
    if (!_correctAnswers){
        

        
        // question number : answer tag
        _correctAnswers = @{@"1":@(2),
                            @"2":@(3),
                            @"3":@(4),
                            @"4":@(1),
                            
                            };
        
    }
    
    return _correctAnswers;
    
}

#pragma mark

- (IBAction)wasDragged:(id)sender forEvent:(UIEvent *)event {
    
    UIButton *button = (UIButton *)sender;
    
    //NSLog(@"frame %@", NSStringFromCGRect(button.frame));
    
    // get the touch
    if (button.tag ==0 || button.tag == 1 ||
        button.tag == 2 || button.tag == 3 ||
        button.tag == 4 ){
        
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
        
        button.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
    }
    
    
}

- (IBAction)wasTouchedUp:(id)sender forEvent:(UIEvent *)event
{

    //NSLog(@"%@ array ", self.correctAnswers);
    QSItem *button = (QSItem *)sender;
    BOOL isIntersec = NO;
    
    button.transform = CGAffineTransformMakeScale(1, 1);
    
    // checking for the answer
    // to remove unneeded right or wrong
    for (id view in [self.view subviews]){
        
        if ([view isKindOfClass:[AnswerBox class]]) {
            
            AnswerBox *answerBox = (AnswerBox *)view;
            
            NSLog(@"intersec");
            if (CGRectIntersectsRect(button.frame, answerBox.frame)){

                //NSLog(@"dict %@",self.answeringDictionary);
                
                // if there is stuff there please snap
                // snapping UI
                int currentState = [[self.answeringDictionary objectForKey:[NSString stringWithFormat:@"%d",answerBox.tag]] intValue];
                
                NSLog(@"my current state %d",currentState);
                
                // kotak kosong
                if (currentState == 0) {
                    [UIView animateWithDuration:0.2 animations:^{
                        button.center = answerBox.center;
                    }];
                    [self resetAnsweringDictWithTag:button.tag];
                    
                    [self.answeringDictionary setObject:@(button.tag) forKey:[NSString stringWithFormat:@"%d",answerBox.tag]];
                // kotak ada barang
                }else if (currentState > 0 && currentState != button.tag){
                    
                    NSLog(@"kotak berisi");
                    
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
    NSLog(@"edit %@",self.answeringDictionary);
    // need to always update
}

- (void)resetAnsweringDictWithTag:(int)tag{

    // clear the previous one
    // reset
    for (NSString *key in [self.answeringDictionary allKeys]) {
        
        int a = [[self.answeringDictionary objectForKey:key] intValue];
        
        
        
        NSLog(@"check %d->%d",a,tag);
        if (a == tag) {
            
            [self.answeringDictionary setObject:@(0) forKey:key];
            
        }
        
    }    
    
}

- (IBAction)check:(id)sender {

    UIButton *button ;

    NSLog(@"log %@",self.answeringDictionary);
    
    
    int questionCount = [self.answeringDictionary count];
    int correctCount = 0;
    
    for (NSString *key in [self.answeringDictionary allKeys]) {
        
        NSString *value = self.answeringDictionary[key];
        UIImageView *imageView = [self findClass:[RightWrongImageView class] withTag:[key intValue]];
        
        int correctAnsIdx = [self.correctAnswers[key] intValue];
        
        // correct
        if (correctAnsIdx == [value intValue]) {
            
            [imageView setBackgroundColor:[UIColor greenColor]];
            correctCount ++;
            
            // wrong
        }else{
            [imageView setBackgroundColor:[UIColor redColor]];
            
        }
    }

    NSString *msg = [NSString stringWithFormat:@"%d / %d", correctCount, questionCount];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jawapan" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alert show];
 
    
}

- (IBAction)reset:(id)sender {
    
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
