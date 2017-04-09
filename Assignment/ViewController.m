//
//  ViewController.m
//  Assignment
//
//  Created by Kimi Wu on 4/9/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "ViewController.h"
#import "LabelCell.h"


NSString * const LabelCellIdentifier = @"kLabelCellIdentifier";
NSString * const InputFileName = @"input"; // Supporting Files/input.txt


@interface Graph ()
@property (strong, nonatomic) NSMutableSet *visitedKey;
@property (strong, nonatomic) NSMutableDictionary *adjacentLists;
@property (strong, nonatomic) NSMutableDictionary *contactDict;

@end

@implementation Graph

- (instancetype)init
{
   self = [super init];
    if (self) {
        self.visitedKey = [[NSMutableSet alloc] init];
        self.adjacentLists = [[NSMutableDictionary alloc] init];
        self.contactDict =  [[NSMutableDictionary alloc] init];
    }
    return self;
}

/**
** construct a graph with adjacent lists
** each name and telephone number is a vertex
**/
- (void)constructAdjacentLists:(NSArray *)inputArray
{
    for (id object in inputArray) {
        [self validateData:object];
        NSArray *contact = (NSArray *)object;
        NSString *name = contact[0];
        NSString *telphoneNumber = contact[1];
        [self addVertex:name];
        [self addVertex:telphoneNumber];
        [self addEdge:name toNode:telphoneNumber];
        [self addEdge:telphoneNumber toNode:name];
        
        // save all the contact string for each person for output display
        // contactDict would store data in the format:
        // Jack : [Jack 122], [Jack 456]
        // Bill : [Bill 456]
        NSMutableSet *numSet = [self.contactDict objectForKey:name] ? : [[NSMutableSet alloc] init];
        [numSet addObject:[NSString stringWithFormat:@"[%@ %@]", name, telphoneNumber]];
        [self.contactDict setObject:numSet forKey:name];
    }
}

- (void)addVertex:(NSString *)vertex
{
    if (![self.adjacentLists objectForKey:vertex]) {
        [self.adjacentLists setObject:[[NSMutableArray alloc] init] forKey:vertex];
    }
}

- (void)addEdge:(NSString *)fromNode toNode:(NSString *)toNode
{
    NSMutableArray *tempList;
    if ((tempList = [self.adjacentLists objectForKey:fromNode])) {
        if (![tempList containsObject:toNode]){
            [tempList addObject:toNode];
        }
    }
}

- (NSMutableArray *)traverseGraph
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSString *key in [self.adjacentLists allKeys]) {
        NSMutableSet *resultSet = [[NSMutableSet alloc] init];
        [self traverseBFS:key result:resultSet];
        if (resultSet.count) {
            [result addObject:resultSet];
        }
    }
    
    return result;
}

- (void)traverseBFS:(NSString *)key result:(NSMutableSet *)result
{
    if (![self.visitedKey containsObject:key]) {
        [self.visitedKey addObject:key];
        [result addObject:key];
        NSMutableArray *list = [self.adjacentLists objectForKey:key];
        
        for (NSString *node in list) {
            [self traverseBFS:node result:result];
        }
    }
}

- (void)validateData:(id)object
{
    NSAssert([object isKindOfClass:[NSArray class]], @"Data format error - should pass a two dimentional array");
    NSArray *array = (NSArray *)object;
    NSAssert(array.count==2, @"Data format error - should pass a n*2 two dimentional array");
    NSAssert(((NSString*)array[0]).length, @"Data format error - name should not be empty");
    NSAssert(((NSString*)array[1]).length, @"Data format error - telephone number should not be empty");
}

@end





@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) Graph *contactGraph;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *viewDataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    //main logic to solve the problem
    NSArray *input = [self parseInputFile];
    self.contactGraph = [[Graph alloc] init];
    [self.contactGraph constructAdjacentLists:input];
    NSMutableArray *contactGroups = [self.contactGraph traverseGraph];
    [self displayWithContactGroups:contactGroups];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{
    [self.collectionView.collectionViewLayout invalidateLayout];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -- View

- (void)setUpView
{
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerNib:[UINib nibWithNibName:[LabelCell nibIdentifier] bundle:nil] forCellWithReuseIdentifier:[LabelCell nibIdentifier]];
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [collectionView setBackgroundColor:[UIColor grayColor]];
        collectionView;
    });
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewDataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [LabelCell cellSizeWithData:self.viewDataSource[indexPath.item] forWidth:CGRectGetWidth(collectionView.bounds)];
    return size;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[LabelCell nibIdentifier] forIndexPath:indexPath];
    cell.contactLabel.text = self.viewDataSource[indexPath.item];
    return cell;
}

#pragma mark -- display
/**
 ** output to command line & feeds the data source for app view display
 **/
- (void)displayWithContactGroups:(NSArray *)groups
{
    self.viewDataSource = [[NSMutableArray alloc] init];
    NSUInteger setCount = 0;
    NSUInteger totalContactsCount = 0;
    
    for (NSSet *set in groups) {
        NSLog(@"Merged Set %ld:",setCount);
        NSMutableSet *mergedSet = [[NSMutableSet alloc] init];
        for (NSString *label in set.allObjects) {
            NSSet *contact = [self.contactGraph.contactDict objectForKey:label];
            if (contact) {
                totalContactsCount += contact.count;
                [mergedSet unionSet:contact];
            }
        }
        NSLog(@"%@", mergedSet);
        NSString *prefix = [NSString stringWithFormat:@"Merged Set %ld:\n",setCount];
        [self.viewDataSource addObject:[prefix stringByAppendingString:[[mergedSet allObjects] componentsJoinedByString:@"\n"]]];
        ++setCount;
    }
    if (self.viewDataSource.count) {
        [self.viewDataSource insertObject:[NSString stringWithFormat:@"Found %ld contacts.", totalContactsCount] atIndex:0];
    }
}


#pragma mark -- File Parser
/**
** Each string token in the file should be separated by white space, return character, or comma
**/
- (NSArray *)parseInputFile
{
    NSString* path = [[NSBundle mainBundle] pathForResource:InputFileName
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    //parse line token
    NSMutableCharacterSet *lineSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *lineArray = [content componentsSeparatedByCharactersInSet:lineSet];
    //parse string token in a line
    NSMutableCharacterSet *tokenSet = [NSMutableCharacterSet characterSetWithCharactersInString:@","];
    [tokenSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:lineArray.count];
    for (NSString *text in lineArray) {
        if (text.length) {
            [resultArray addObject:[text componentsSeparatedByCharactersInSet:tokenSet]];
        }
    }
    
    return resultArray;
}

@end
