//
//  MGSelectionTagView.m
//  MGSelectionTagView
//
//  Created by 宋海梁 on 16/5/10.
//  Copyright © 2016年 jicaas. All rights reserved.
//

#import "MGSelectionTagView.h"

@interface MGSelectionTagView ()

@property (nonatomic, strong) UIButton *otherButton;     //“其他”按钮
@property (nonatomic, strong) NSMutableArray *allButtons;

@end

@implementation MGSelectionTagView

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customerInit];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self customerInit];
    }
    return self;
}

- (void)customerInit {
    
    _font = [UIFont systemFontOfSize:14.0];
    _itemMargin = 10.0;
    _itemPaddingX = 25.0;
    _itemPaddingY = 8.0;
    _lineSpacing = 10.0;
    _maxSelectNum = 3;
    _textColor = [UIColor blackColor];
    _selectedTextColor = [UIColor whiteColor];
}

#pragma mark - View Method

/**
 *  重新加载数据源
 */
- (void)reloadData {
    
    [self layoutIfNeeded];
    
    [self.allButtons removeAllObjects];
    
    //移除原来的子View
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    NSAssert(self.dataSource, @"SelectionTagView 必须实现dataSource代理!");
    //标签总数
    NSInteger total = [self.dataSource numberOfTagsInSelectionTagView:self];
    
    self.otherButton = nil; //重置OtherButton对象
    
    CGRect previousFrame = CGRectZero;   //上一个标签的frame
    for (int i = 0; i < total; i++) {
        
        NSString *title = [self.dataSource tagView:self titleForIndex:i];
        UIButton *button = [self buttonWithTitle:title];
        
        [self.allButtons addObject:button];
        button.tag = i;
        [self addSubview:button];
        
        BOOL isOther = [ self.dataSource respondsToSelector:@selector(tagView:isOtherTagForIndex:)] ? [self.dataSource tagView:self isOtherTagForIndex:i] : NO;
        if (isOther) {
            self.otherButton = button;
        }
        
        BOOL selected = [self.dataSource respondsToSelector:@selector(tagView:isTagSelectedForIndex:)] ? [self.dataSource tagView:self isTagSelectedForIndex:i] : NO;
        button.selected = selected;
        
        //重新计算按钮frame
        CGSize buttonSize = button.bounds.size;
        buttonSize.width  = self.itemWidth > 0 ? self.itemWidth : (buttonSize.width + self.itemPaddingX*2);
        buttonSize.height = self.itemHeight > 0 ? self.itemHeight : (buttonSize.height + self.itemPaddingY*2);
        
        CGRect newRect = CGRectZero;
        //根据判断来确定button的frame
        if (buttonSize.width > CGRectGetWidth(self.bounds)) {
            //标签按钮宽度已超过view的宽度,取view的宽度
            newRect.size = CGSizeMake(CGRectGetWidth(self.bounds),buttonSize.height);
            if (i == 0) { //第一个标签，不留间距
                newRect.origin = CGPointMake(0 ,0);
            }else{
                newRect.origin = CGPointMake(0 ,CGRectGetMaxY(previousFrame) + self.lineSpacing);
            }
        }
        else{
            newRect.size = buttonSize;
            //换行显示
            if (CGRectGetMaxX(previousFrame) + buttonSize.width + self.itemMargin > CGRectGetWidth(self.bounds)) {
                newRect.origin = CGPointMake(0, CGRectGetMaxY(previousFrame) + self.lineSpacing);
            }
            else {
                if (i == 0) { //第一个标签，不留间距
                    newRect.origin = CGPointMake(0, 0);
                }
                else {
                    newRect.origin = CGPointMake(CGRectGetMaxX(previousFrame) + self.itemMargin, previousFrame.origin.y);
                }
            }
        }
        button.frame = newRect;
        previousFrame = button.frame;
    }
    
    //更新view高度
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(previousFrame);
    self.frame = frame;
    //更新选择最多个数
    [self updateMaxSelectStatus];
}

#pragma mark - Private Method

- (UIButton *)buttonWithTitle:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//设置类型
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = self.font;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
    [button setTitleColor:self.selectedTextColor forState:UIControlStateHighlighted];
    
    //设置背景图片
    if (self.itemBackgroundImage) {
        [button setBackgroundImage:self.itemBackgroundImage  forState:UIControlStateNormal];
    }
    
    if (self.itemSelectedBackgroundImage) {
        [button setBackgroundImage:self.itemSelectedBackgroundImage forState:UIControlStateSelected];
        [button setBackgroundImage:self.itemSelectedBackgroundImage forState:UIControlStateHighlighted];
    }
    
    button.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(tagButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit]; //按钮自适应
    
    return button;
}

- (void)tagButtonTouched:(UIButton *)sender {
    
    //选中变为非选中
    sender.selected = !sender.selected;
    
    //单选
    if (_maxSelectNum == 1) {
        if (sender.selected) {
            for (UIButton *btn in self.subviews) {
                if (btn && ![btn isEqual:sender]) {
                    btn.selected = NO;
                }
            }
        }
    }
    //多选
    else {
        //判断点击的是否是其它button
        if ([sender isEqual:self.otherButton]) {
            if (sender.selected) {
                for (UIButton *btn in self.subviews) {
                    if (btn && ![btn isEqual:self.otherButton]) {
                        btn.selected = NO;
                        btn.userInteractionEnabled = YES;
                    }
                }
            }
            else {
                for (UIButton *btn in self.subviews) {
                    if (btn) {
                        btn.userInteractionEnabled = YES;
                    }
                }
            }
            
        }else{
            
            self.otherButton.selected = NO;
            [self updateMaxSelectStatus];
        }
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagView:tagTouchedAtIndex:)]) {
        [self.delegate tagView:self tagTouchedAtIndex:sender.tag];
    }
}

//最大选择数限制
- (void)updateMaxSelectStatus {
    
    if (_maxSelectNum > 1) {
        NSMutableArray * selectdButtonArray = [[NSMutableArray alloc] init];
        //添加选中的按钮
        for (UIButton *btn in self.subviews) {
            if (btn && btn.selected) {
                [selectdButtonArray addObject:btn];
            }
        }
        
        if (selectdButtonArray.count >= _maxSelectNum) {
            
            for (UIButton *btn in self.subviews) {
                if (btn) {
                    btn.userInteractionEnabled = [selectdButtonArray containsObject:btn];
                }
            }
            
            self.otherButton.userInteractionEnabled = YES;
            
        }else{
            
            for (UIButton *btn in self.subviews) {
                if (btn) {
                    btn.userInteractionEnabled = YES;
                }
            }
        }
    }
}

- (NSArray *)indexesOfSelectionTags {
    
    NSMutableArray * mArray = [NSMutableArray array];
    for (int i = 0; i < self.allButtons.count; i ++) {
        UIButton * button = [self.allButtons objectAtIndex:i];
        if (button.selected) {
            [mArray addObject:@(i)];
        }
    }
    return mArray;
}

#pragma mark - LazyLoad
- (NSMutableArray *)allButtons {
    
    if (!_allButtons) {
        _allButtons = [NSMutableArray array];
    }
    return _allButtons;
}

@end
