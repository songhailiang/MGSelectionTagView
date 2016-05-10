//
//  ViewController.m
//  MGSelectionTagView
//
//  Created by 宋海梁 on 16/5/10.
//  Copyright © 2016年 jicaas. All rights reserved.
//

#import "ViewController.h"
#import "MGSelectionTagView.h"

@interface ViewController ()<MGSelectionTagViewDelegate,MGSelectionTagViewDataSource>

@property (weak, nonatomic) IBOutlet MGSelectionTagView *tagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;

@property (weak, nonatomic) IBOutlet UITextField *maxSelectNumText;
@property (weak, nonatomic) IBOutlet UISwitch *otherButtonSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoWidthSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoHeightSwitch;
@property (weak, nonatomic) IBOutlet UITextField *widthText;
@property (weak, nonatomic) IBOutlet UITextField *heightText;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (nonatomic, strong) NSArray *tags;

- (IBAction)autoWidthSwitchChanged:(id)sender;
- (IBAction)autoHeightSwitchChanged:(id)sender;

- (IBAction)refreshView:(id)sender;
- (IBAction)okButtonTouched:(id)sender;

@end

@implementation ViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self prepareDataSource];
    [self setupViewUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setupViewUI {

    self.navigationItem.title = @"可选择的标签View";
    self.tagView.dataSource = self;
    self.tagView.delegate = self;
    
    self.tagView.itemBackgroundImage = [UIImage imageNamed:@"buttonNormal"];
    self.tagView.itemSelectedBackgroundImage = [UIImage imageNamed:@"buttonSelected"];
    
    [self refreshView:nil];
}

#pragma mark - Data

- (void)prepareDataSource {

    self.tags = @[@"书画",@"芭蕾舞",@"烹饪",@"时装模特",@"北京一日游",@"音乐",@"太极拳",@"广场舞",@"其他"];
}

#pragma mark - MGSelectionTagViewDataSource

- (NSInteger)numberOfTagsInSelectionTagView:(MGSelectionTagView *)tagView {
    return self.tags.count;
}

- (NSString *)tagView:(MGSelectionTagView *)tagView titleForIndex:(NSInteger)index {

    return [self.tags objectAtIndex:index];
}

/**
 *  标识index位置的tag是否选中
 *
 */
- (BOOL)tagView:(MGSelectionTagView *)tagView isTagSelectedForIndex:(NSInteger)index {

    return NO;
}

/**
 *  标识index位置的tag是否“其他”（设置了“其他”tag会在选择时产生互斥）
 *
 */
- (BOOL)tagView:(MGSelectionTagView *)tagView isOtherTagForIndex:(NSInteger)index {

    if (self.otherButtonSwitch.on && [[self.tags objectAtIndex:index] isEqualToString:@"其他"]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - MGSelectionTagViewDelegate

- (void)tagView:(MGSelectionTagView *)tagView tagTouchedAtIndex:(NSInteger)index {

    NSLog(@"select tag:%@",[self.tags objectAtIndex:index]);
}

#pragma mark - View Method

- (IBAction)autoWidthSwitchChanged:(id)sender {
    
    self.widthText.hidden = self.autoWidthSwitch.on;
}

- (IBAction)autoHeightSwitchChanged:(id)sender {
    self.heightText.hidden = self.autoHeightSwitch.on;
}

- (IBAction)refreshView:(id)sender {
    
    [self.view endEditing:YES];
    
    self.tagView.maxSelectNum = [self.maxSelectNumText.text integerValue];
    
    if (!self.autoWidthSwitch.on) {
        self.tagView.itemWidth = [self.widthText.text floatValue];
    }
    else {
        self.tagView.itemWidth = 0;
    }
    
    if (!self.autoHeightSwitch.on) {
        self.tagView.itemHeight = [self.heightText.text floatValue];
    }
    else {
        self.tagView.itemHeight = 0;
    }
    
    [self.tagView reloadData];
    
    //调整View高度
    self.tagViewHeight.constant = CGRectGetHeight(self.tagView.frame);
}

- (IBAction)okButtonTouched:(id)sender {
    
    NSArray *indexes = [self.tagView indexesOfSelectionTags];
    NSMutableArray *selectedTags = [NSMutableArray arrayWithCapacity:indexes.count];
    
    for (NSNumber *index in indexes) {
        [selectedTags addObject:[self.tags objectAtIndex:index.integerValue]];
    }
    
    self.resultLabel.text = [selectedTags componentsJoinedByString:@","];
}
@end
