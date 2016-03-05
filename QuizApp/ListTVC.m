//
//  ListTVC.m
//  QuizApp
//
//  Created by Muhammad Hijazi  on 2/10/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import "ListTVC.h"

@interface ListTVC ()

@end

@implementation ListTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
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

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_lines count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    cell.hiragana.text = _lines[indexPath.row + 1][0];
    cell.romaji.text = _lines[indexPath.row + 1][1];
    cell.hiraganaExample.text = _lines[indexPath.row + 1][2];
    cell.hira_romaji.text = _lines[indexPath.row + 1][3];
    
    
    return cell;
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


@end
