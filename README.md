# MGSelectionTagView
支持单选、多选、自适应宽高的标签选择View

## 可实现的功能
* 单选
* 多选
可设置最大可选择数，超过此值后，其他选项不可选
* 支持“其他”选项
选中“其他”选项后，其它的选项自动重置
* 自适应item宽度、高度，也可指定宽度、高度
* 可自定义不同状态的样式（默认、选中）
* item间距，line间距可自由设置
* 使用代理返回数据源，更灵活

## 效果图
<img src='https://github.com/songhailiang/MGSelectionTagView/blob/master/screenshot.gif' width='320' />

## 安装

### 使用CocoaPods

```ruby
pod 'MGSelectionTagView'
```

### 手动导入
- 将`Source`文件夹中的所有源代码拽入项目中

```objc
MGSelectionTagView.h
MGSelectionTagView.m
```

## 示例

1、设置delegate和dataSource
```objc
self.tagView.dataSource = self;
self.tagView.delegate = self;
```

2、实现dataSource
```objc
#pragma mark - MGSelectionTagViewDataSource

- (NSInteger)numberOfTagsInSelectionTagView:(MGSelectionTagView *)tagView {
    return self.tags.count;
}

- (NSString *)tagView:(MGSelectionTagView *)tagView titleForIndex:(NSInteger)index {

    return [self.tags objectAtIndex:index];
}
```

3、调用reloadData
```objc
[self.tagView reloadData];
```

下面是一些可选的代理：
1、指定某个tag是否选中
```objc
/**
 *  标识index位置的tag是否选中
 *
 */
- (BOOL)tagView:(MGSelectionTagView *)tagView isTagSelectedForIndex:(NSInteger)index {

    return NO;
}
```
2、指定某个tag是否是“其他”
```objc
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
```
3、tag选中后的代理
- 可用在单选时，点击跳转
```objc
- (void)tagView:(MGSelectionTagView *)tagView tagTouchedAtIndex:(NSInteger)index {

    NSLog(@"select tag:%@",[self.tags objectAtIndex:index]);
}
```
4、获取所有已选择的tag
- 调用indexesOfSelectionTags方法
```objc
    NSArray *indexes = [self.tagView indexesOfSelectionTags];
    NSMutableArray *selectedTags = [NSMutableArray arrayWithCapacity:indexes.count];
    
    for (NSNumber *index in indexes) {
        [selectedTags addObject:[self.tags objectAtIndex:index.integerValue]];
    }
    
    self.resultLabel.text = [selectedTags componentsJoinedByString:@","];
```

## 不足
为了使整个View能根据tag数自适应高度，你需要给View添加一个height的约束，然后在调用reloadData后更改height约束。
（如果你没有用自动布局，则需要在调用reloadData前先设置好View的宽度）
```objc
self.tagViewHeight.constant = CGRectGetHeight(self.tagView.frame);
```

## 期待
任何改进意见和pr都是非常受欢迎的
