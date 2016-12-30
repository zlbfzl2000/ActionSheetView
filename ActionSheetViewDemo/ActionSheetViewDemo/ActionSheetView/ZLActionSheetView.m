
//
//  GoodsOwnCertificationViewController.m
//  DDKD
//
//  Created by 小虾米 on 2016/12/28.
//  Copyright © 2016年 shiqingming. All rights reserved.
//
#import "ZLActionSheetView.h"

#define cancelTag  9999

#define titleTag   10000

#define   BtnHeight  44

#define Margin 6

// 高亮状态下的图片
#define highImageColor     0xF2F2F2

#define TextLinkColor           0x07afb2

#define TextWhiteColor 0xffffff

#define  ListTitleFont  [UIFont systemFontOfSize:14]

#define SeparatorColor     0xE2E2E2

#define BgGlobeColor       0xEDF0F2

#define SCREENWIDTH                         [[UIScreen mainScreen] bounds].size.width

#define SCREENHEIGHT                        [[UIScreen mainScreen] bounds].size.height

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface ZLActionSheetView ()
{
    int _btnTag;
}
@property (nonatomic ,copy)ZLActionSheetClickBlock clickBlock;
@property (nonatomic, weak) ZLActionSheetView *actionSheet;
@property (nonatomic, weak) UIView *sheetView;
@end

@implementation ZLActionSheetView

- (instancetype)initWithDelegate:(id<ZLActionSheetViewDelegate>)delegate title:(NSString *)titleMessage CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString *)otherTitles, ...{
    self = [super init];
    
    ZLActionSheetView *actionSheet = self;
    self.actionSheet = actionSheet;
    
    actionSheet.delegate = delegate;
    
    // 黑色遮盖
    actionSheet.frame = [UIScreen mainScreen].bounds;
    actionSheet.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:actionSheet];
    actionSheet.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverClick)];
    [actionSheet addGestureRecognizer:tap];
    
    // sheet
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
    sheetView.backgroundColor = UIColorFromRGB(BgGlobeColor);
    sheetView.alpha = 0.9;
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    sheetView.hidden = YES;
    
    _btnTag = 0;
    
    if(titleMessage){
        [self setupBtnWithTitle:titleMessage isTitle:YES];
    }
    
    NSString* curStr;
    va_list list;
    if(otherTitles)
    {
        [self setupBtnWithTitle:otherTitles isTitle:NO];
        
        va_start(list, otherTitles);
        while ((curStr = va_arg(list, NSString*))) {
            [self setupBtnWithTitle:curStr isTitle:NO];
            
        }
        va_end(list);
    }
    
    CGRect sheetViewF = sheetView.frame;
    
    if(cancelTitle!=nil){
        sheetViewF.size.height = BtnHeight * _btnTag + Margin;
    }else{
        sheetViewF.size.height = BtnHeight * (_btnTag-1);
    }
    sheetView.frame = sheetViewF;
    
    if(cancelTitle!=nil){
        // 取消按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, sheetView.frame.size.height - BtnHeight, SCREENWIDTH, BtnHeight)];
        [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(TextWhiteColor)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(highImageColor)] forState:UIControlStateHighlighted];
        [btn setTitle:cancelTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = ListTitleFont;
        btn.tag = cancelTag;
        [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.sheetView addSubview:btn];
    }
    return actionSheet;
}
#pragma private function
- (void)setupBtnWithTitle:(NSString *)title isTitle:(BOOL) isTitle{
    // 创建按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnHeight * (_btnTag - 1) , SCREENWIDTH, BtnHeight)];
    [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(TextWhiteColor)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(highImageColor)] forState:UIControlStateHighlighted];
     [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(TextWhiteColor)] forState:UIControlStateDisabled];
    [btn setTitle:title forState:UIControlStateNormal];
    if(_selectIndex==_btnTag){
        [btn setTitleColor:UIColorFromRGB(TextLinkColor) forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if(isTitle){
        btn.titleLabel.font = ListTitleFont;
        btn.enabled =NO;
        btn.tag  =titleTag;
    }else{
        btn.titleLabel.font = ListTitleFont;
        [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = _btnTag;
    }
    
    [self.sheetView addSubview:btn];
    
    
    // 最上面画分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    line.backgroundColor = UIColorFromRGB(SeparatorColor);
    [btn addSubview:line];
    
    _btnTag ++;
}
- (void)coverClick{
    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = SCREENHEIGHT;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sheetView.frame = sheetViewF;
        self.actionSheet.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.actionSheet removeFromSuperview];
        [self.sheetView removeFromSuperview];
    }];
}
// button的点击事件
- (void)sheetBtnClick:(UIButton *)btn{

    if (btn.tag == cancelTag) {
        [self coverClick];
        return;
    }
    // 让代理去执行方法
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self.actionSheet clickedButtonAtIndex:btn.tag];
        [self coverClick];
    }
    
    if (self.clickBlock) {
        self.clickBlock(self,btn.tag);
    }
}
- (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma public function
-(void)showWithClickBlock:(ZLActionSheetClickBlock)clickBlock{
    
    [self show];
    self.clickBlock = clickBlock;
    
}
- (void)show{
    
    self.sheetView.hidden = NO;
    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = SCREENHEIGHT;
    self.sheetView.frame = sheetViewF;
    
    CGRect newSheetViewF = self.sheetView.frame;
    newSheetViewF.origin.y = SCREENHEIGHT - self.sheetView.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.sheetView.frame = newSheetViewF;
        
        self.actionSheet.alpha = 0.3;
    }];
}
#pragma setter  getter
-(void)setSelectIndex:(int)selectIndex{
    if(selectIndex > 0){
        UIButton *btn=[self.sheetView viewWithTag:selectIndex];
        if(_selectColor){
            UIButton *btn=[self.sheetView viewWithTag:selectIndex];
            [btn setTitleColor:_selectColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:UIColorFromRGB(TextLinkColor) forState:UIControlStateNormal];
        }
    }
}
-(void)setCancelFont:(UIFont *)cancelFont{
   
    _cancelFont  =cancelFont;
    
    UIButton *bt = (UIButton*)[self.sheetView viewWithTag:cancelTag];
   
    [bt.titleLabel setFont:cancelFont];
  
}
-(void)setCancelTextColor:(UIColor *)cancelTextColor{
    
    _cancelTextColor =cancelTextColor;
    UIButton *bt = (UIButton*)[self.sheetView viewWithTag:cancelTag];
    [bt setTitleColor:cancelTextColor forState:UIControlStateNormal];
     [bt setTitleColor:cancelTextColor forState:UIControlStateHighlighted];
     [bt setTitleColor:cancelTextColor forState:UIControlStateDisabled];
     [bt setTitleColor:cancelTextColor forState:UIControlStateSelected];
}
-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;

    UIButton *bt = (UIButton*)[self.sheetView viewWithTag:titleTag];
    
    [bt.titleLabel setFont:titleFont];
    
}
-(void)setTitleTextColor:(UIColor *)titleTextColor{
    
    _titleTextColor  = titleTextColor;
    UIButton *bt = (UIButton*)[self.sheetView viewWithTag:titleTag];
    [bt setTitleColor:titleTextColor forState:UIControlStateNormal];
    [bt setTitleColor:titleTextColor forState:UIControlStateHighlighted];
    [bt setTitleColor:titleTextColor forState:UIControlStateDisabled];
    [bt setTitleColor:titleTextColor forState:UIControlStateSelected];
    
}
@end
