//
//  ListCollectionVC.m
//  QuizApp
//
//  Created by Hijazi on 1/31/14.
//  Copyright (c) 2014 iReka Soft. All rights reserved.
//

#import "ListCollectionVC.h"

#import "CHCSVParser.h"

@interface ListCollectionVC () <UICollectionViewDelegate, UICollectionViewDataSource, CHCSVParserDelegate>{
    
    
}

@property (strong, nonatomic) NSMutableArray *lines;
@property (strong, nonatomic) NSMutableArray *currentLine;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ListCollectionVC

- (void)setupParsing{
    
    NSString *file;
    
    file = [[NSBundle mainBundle] pathForResource:@"HiraganaList" ofType:@"csv"];
	
	NSLog(@"Beginning...");
	NSStringEncoding encoding = 0;
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:file];
	CHCSVParser * p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
    [p setRecognizesBackslashesAsEscapes:YES];
    [p setSanitizesFields:NO];
    [p setDelegate:self];
	
	NSLog(@"encoding: %@", CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding)));
    
    
	[p parse];
    
    NSLog(@"raw difference: %@", _lines[0][1]);
    [self.collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupParsing];
    

    [self.collectionView setPagingEnabled:YES];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.lines count] - 1;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.foreignLbl.text = self.lines[indexPath.row + 1][0];
    cell.pronounceLbl.text = _lines[indexPath.row + 1][1];
    cell.hiraganaExample.text = _lines[indexPath.row + 1][2];
    cell.hira_romaji.text = _lines[indexPath.row + 1][3];
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}


#pragma mark - CHCSVParserDelegate



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
