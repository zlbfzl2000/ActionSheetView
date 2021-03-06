//
//  ZLActionSheetView.h
//  ActionSheetViewDemo
//
//  Created by 小虾米 on 2016/12/30.
//  Copyright © 2016年 小虾米. All rights reserved.
//
#import <UIKit/UIKit.h>

@class ZLActionSheetView;

@protocol ZLActionSheetViewDelegate <NSObject>

@optional

/**
 *  点击按钮
 */
- (void)actionSheet:(ZLActionSheetView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


typedef void(^ZLActionSheetClickBlock)(ZLActionSheetView *sheetView ,NSInteger index);

@interface ZLActionSheetView : UIView

/**
 *  代理
 */
@property (nonatomic, weak  ) id <ZLActionSheetViewDelegate> delegate;

/**
 *  必须在selectIndex之前设置
 */
@property (nonatomic, strong) UIColor                    *selectColor;

@property (nonatomic, assign) int                        selectIndex;

@property (nonatomic ,strong)UIColor *cancelTextColor;

@property (nonatomic ,strong)UIFont *cancelFont;

@property (nonatomic ,strong)UIColor *titleTextColor;

@property (nonatomic ,strong)UIFont *titleFont;
/**
 *  创建对象方法
 */
- (instancetype)initWithDelegate:(id<ZLActionSheetViewDelegate>)delegate title:(NSString *)titleMessage CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString*)otherTitles,... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

-(void)showWithClickBlock:(ZLActionSheetClickBlock)clickBlock;

@end
