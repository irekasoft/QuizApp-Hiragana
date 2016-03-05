//
//  QuizVC.m
//  QuizApp
//
//  Created by Muhammad Hijazi  on 1/10/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import "QuizVC.h"



@interface QuizVC ()

@end

@implementation QuizVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self generateQuestion];
    
}

- (void)generateQuestion{
    
    self.countLabel.text = [NSString stringWithFormat:@"%d",correctCount++];
    
    NSString *file;
    
    file = [[NSBundle mainBundle] pathForResource:@"HiraganaList" ofType:@"csv"];
    
	NSLog(@"Beginning...");
    
	NSStringEncoding encoding = 0;
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:file];
    NSLog(@"stream %@",stream);
	CHCSVParser * p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
    [p setRecognizesBackslashesAsEscapes:YES];
    [p setSanitizesFields:YES];
    
	
	NSLog(@"encoding: %@", CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding)));
    [p setDelegate:self];
	[p parse];
	
    //NSLog(@"%@", _lines);
    
    selectedItems = [_lines randomItemsForSize:4 startFrom:1];
    shuffledArray = [selectedItems shuffleArray];
    
    self.questionLabel.text = selectedItems[0][0];
    
    int a = 0;
    
    for (QSButton *button in self.answerButtons){
        
        [button setTitle:shuffledArray[a++][1] forState:UIControlStateNormal];
        
    }
}


- (IBAction)answer:(id)sender {
    
    QSButton *button = (QSButton *)sender;
    
    NSString *questionStg = shuffledArray[button.tag - 1][1];
    NSString *answerStg = selectedItems[0][1];
    
    
//    NSString *title = [NSString stringWithFormat:@"%@ = %@",questionStg, answerStg];
    
    NSString *text;
    if ([answerStg isEqualToString:questionStg]) {
        text = @"Right";
        isCorrect = YES;
        
        [self generateQuestion];
    }else{
        text = @"Wrong";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    

    
    isCorrect = NO;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
}

#pragma mark - CHCSV Parser


- (void)parserDidBeginDocument:(CHCSVParser *)parser {

    _lines = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    _currentLine = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    
    [_currentLine addObject:field];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    [_lines addObject:_currentLine];
   
    _currentLine = nil;
}
- (void)parserDidEndDocument:(CHCSVParser *)parser {
    //	NSLog(@"parser ended: %@", csvFile);
    
    //NSLog(@"lines : %@",_lines);
    
}
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"ERROR: %@", error);
    _lines = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
