//
//  MGSelectionTagView.h
//  MGSelectionTagView
//
//  Created by 宋海梁 on 16/5/10.
//  Copyright © 2016年 jicaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGSelectionTagView;

//数据源
@protocol MGSelectionTagViewDataSource <NSObject>

@required
- (NSInteger)numberOfTagsInSelectionTagView:(MGSelectionTagView *)tagView;
- (NSString *)tagView:(MGSelectionTagView *)tagView titleForIndex:(NSInteger)index;

@optional
/**
 *  标识index位置的tag是否选中
 *
 */
- (BOOL)tagView:(MGSelectionTagView *)tagView isTagSelectedForIndex:(NSInteger)index;

/**
 *  标识index位置的tag是否“其他”（设置了“其他”tag会在选择时产生互斥）
 *
 */
- (BOOL)tagView:(MGSelectionTagView *)tagView isOtherTagForIndex:(NSInteger)index;

@end

@protocol MGSelectionTagViewDelegate <NSObject>

@optional

//标签点击后代理事件
- (void)tagView:(MGSelectionTagView *)tagView tagTouchedAtIndex:(NSInteger)index;

@end


/**
 *  可选择标签View
 */
@interface MGSelectionTagView : UIView

#pragma mark - View Property

/**
 *  最多可选择的标签数 (<=0:不限制选择数量;=1:单选(标签互斥)；否则当已选择的标签数达到此值时，其余按钮不可点击
 *  默认=3
 */
@property (nonatomic, assign) NSInteger maxSelectNum;

#pragma mark - Item Property

/**
 *  标签字体：默认14
 */
@property (nonatomic, strong) UIFont *font;

/**
 *  指定标签宽度（width>0，会忽略paddingX参数）
 *  不指定宽度时会自适应宽度
 */
@property (nonatomic, assign) CGFloat itemWidth;

/**
 *  指定标签高度（height>0，会忽略paddingY参数）
 *  不指定高度时会自适应高度
 */
@property (nonatomic, assign) CGFloat itemHeight;

/**
 *  标签间距 默认=10
 */
@property (nonatomic, assign) CGFloat itemMargin;

/**
 *  标签内边距（横坐标） 相当于paddingLeft=paddingRight 默认=25
 */
@property (nonatomic, assign) CGFloat itemPaddingX;

/**
 *  标签内边距（纵坐标） 相当于paddingTop=paddingBottom 默认=8
 */
@property (nonatomic, assign) CGFloat itemPaddingY;

/**
 *  标签行间距 默认=10
 */
@property (nonatomic, assign) CGFloat lineSpacing;

/**
 *  字体颜色 默认：[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  标签选中时的颜色 默认：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *selectedTextColor;

/**
 *  标签背景图片
 */
@property (nonatomic, strong) UIImage *itemBackgroundImage;

/**
 *  标签选中时的图片
 */
@property (nonatomic, strong) UIImage *itemSelectedBackgroundImage;

@property (nonatomic, weak) id<MGSelectionTagViewDelegate> delegate;

@property (nonatomic, weak) id<MGSelectionTagViewDataSource> dataSource;

/**
 *  重新加载数据源
 */
- (void)reloadData;

/**
 *  获取选中的索引
 *
 */
- (NSArray *)indexesOfSelectionTags;

@end
