

#import "AppDelegate.h"
#import "JSONKit.h"
//通用方法
#import "GlobalMethod.h"
//创建model
#import "GlobalMethod+CreatModel.h"
//比较model
#import "GlobalMethod+ModelCompare.h"
//转换请求
#import "GlobalMethod+RequestExchange.h"
//获取m文件 方法名
#import "GlobalMethod+FetchMethodName.h"
//exchange model to json
#import "GlobalMethod+ExchangeModelToJson.h"
//fliter api response
#import "GlobalMethod+FilterApiJson.h"
//MicroServiceApiExchange
#import "GlobalMethod+MicroServiceApiExchange.h"
#import "GlobalMethod+AnalyseData.h"
//analyseApiOfLiuyu
#import "GlobalMethod+AnalyseApiOfLiuyu.h"
//analyse address
#import "GlobalMethod+AnalyseAddress.h"
//宏定义
#import "Macro.h"
//写入文件
#import "GlobalMethod+CopyImages.h"
//add key board observe
#import "GlobalMethod+Keyboard.h"
//transition english
#import "GlobalMethod+TransitionEnglish.h"

#define UILABEL  @"UILabel"
#define UIIMAGEVIEW @"UIImageView"
#define UIBUTTON @"UIButton"
#define UICONTROL @"UIControl"
#define UITEXTFIELD @"UITextField"
#define UISCROLLVIEW @"UIScrollView"
#define UIVIEW @"UIView"
#define UITABLEVIEWCELL @"UITableViewCell"
#define UIVIEWCONTROLLER @"UIViewController"
#define BASEVC @"BaseVC"
#define BASETABLEVC @"BaseTableVC"
#define UITABLEVIEW @"UITableView"
#define UICOLLECTIONVIEW @"UICollectionView"

@interface AppDelegate()
@end

@implementation AppDelegate

#pragma mark 初始化页面
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
//    self.textView = [[NSTextView alloc]initWithFrame:CGRectMake(0, 0, 595, 1000)];
    [self.scrollView.documentView addSubview:self.textView];
    NSSize contentSize = [self.scrollView contentSize];
    
    [self.scrollView setBorderType:NSNoBorder];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setHasHorizontalScroller:NO];
    [self.scrollView setAutoresizingMask:NSViewWidthSizable |
     NSViewHeightSizable];
    self.textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0,
                                                               contentSize.width, contentSize.height)];
    [self.textView setMinSize:NSMakeSize(0.0, contentSize.height)];
    [self.textView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
    [self.textView setVerticallyResizable:YES];
    [self.textView setHorizontallyResizable:NO];
    [self.textView setAutoresizingMask:NSViewWidthSizable];
    
    [[self.textView textContainer]
     setContainerSize:NSMakeSize(contentSize.width, FLT_MAX)];
    [[self.textView textContainer] setWidthTracksTextView:YES];
    
    [self.scrollView setDocumentView:self.textView];

    // 初始化数据
    self.tag = 1;
    self.isHasBtn = false;
    
}


#pragma mark 点击效果
//创建文件
- (IBAction)touchCreateFile:(id)sender {

    NSString *jsonStr = self.textView.textStorage.string;
    [self exchange:jsonStr];
    return;
}

#pragma mark testView
- (void)exchange:(NSString *)str{
    //初始化内容
    self.tag = 1;
    self.isHasBtn = false;
    //去掉空格
    str = [GlobalMethod getOffLineBreak:str];
    if (str == nil ||str.length == 0) {
        [self.textView setString:@""];
        return;
    }
    NSString * strClass = self.tfSuperClass.stringValue;
    //返回数据
    NSMutableString * strReturn = [NSMutableString string];
    //添加.h文件
    NSString * strFileH = [GlobalMethod readFile:[NSString stringWithFormat:@"%@H",strClass]];
    if (!isStr(strFileH)) {
        strFileH = [GlobalMethod readFile:[NSString stringWithFormat:@"%@H",@"UIView"]];
    }
    strFileH = [GlobalMethod replaceInString:strFileH replaceString:@"ClassName" withString:self.textClass.stringValue];
    
    //替换propertyH
    NSMutableString * strPropertyH = [NSMutableString string];
    //替换懒加载
    NSMutableString * strLazyInit = [NSMutableString string];
    //替换init
    NSMutableString * strAddSubView = [NSMutableString string];
    //替换懒加载
    NSMutableString * strResetView = [NSMutableString string];
    
    NSArray * ary = [GlobalMethod exchangeStrToModelAry:str];
    for (int i = 0; i < ary.count ; i++) {
        [strPropertyH appendString:[self fetchHFile:ary[i]]];
        [strLazyInit appendString:[self fetchLazyInit:ary[i]]];
        [strAddSubView appendString:[self fetchAddSubView:ary[i]]];
        [strResetView appendString:[self fetchResetHeight:ary[i]]];
    }
    strFileH = [GlobalMethod replaceInString:strFileH replaceString:@"PropertyH" withString:strPropertyH];
    [strReturn appendString:strFileH];
    [strReturn appendString:@"\n\n.m\n"];
    //添加.m文件
    NSString * strFileM = [GlobalMethod readFile:[NSString stringWithFormat:@"%@M",strClass]];
    if (!isStr(strFileM)) {
        strFileM = [GlobalMethod readFile:[NSString stringWithFormat:@"%@M",@"UIView"]];
    }
    strFileM = [GlobalMethod replaceInString:strFileM replaceString:@"ClassName" withString:self.textClass.stringValue];
    strFileM = [GlobalMethod replaceInString:strFileM replaceString:@"LazyInit" withString:strLazyInit];
    strFileM = [GlobalMethod replaceInString:strFileM replaceString:@"AddSubView" withString:strAddSubView];
    strFileM = [GlobalMethod replaceInString:strFileM replaceString:@"RestViewM" withString:strResetView];
    
    //添加额外数据
    
    NSString * strOther = [self fetchOther:str];
    strFileM = [GlobalMethod replaceInString:strFileM replaceString:@"Other" withString:strOther];

    [strReturn appendString:strFileM];
    
    self.textView.string = strReturn;
    
    
    
}

#pragma mark 点击
//获取文件数据
- (IBAction)touchReadFile:(NSButton *)sender {
            NSString * strPath = [[NSBundle mainBundle]pathForResource:sender.title ofType:@"json"];
            NSString * strFile = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
            if (self.textClass.stringValue.length > 0) {
                strFile = [GlobalMethod replaceInString:strFile replaceString:@"TestVC" withString:self.textClass.stringValue];
            }
            self.textView.string = strFile;
}

- (IBAction)touchEnglishComposition:(NSButton *)sender {
    if (self.textView.textStorage.string.length > 0) {
        self.textView.string =  [GlobalMethod transitionEnglish:self.textView.textStorage.string];

    }
}
#pragma mark 获取m文件方法
- (IBAction)fetchMethodName:(NSButton *)sender {
    NSString *jsonStr = self.textView.textStorage.string;
    NSString *strText = self.tfSuperClass.stringValue;
    self.textView.string = [GlobalMethod fetchMethodName:jsonStr regex:strText.length?strText:@"\\{[^\\{\\}]*\\}"];
}

#pragma mark filter api json
- (IBAction)filterApiJson:(NSButton *)sender {
    NSString *jsonStr = self.textView.textStorage.string;
    self.textView.string = [GlobalMethod fliterRequestApiJson:jsonStr];
}

#pragma mark创建model
- (IBAction)touchModel:(id)sender {
    NSString *str = self.textView.textStorage.string;
    str = [GlobalMethod getOffLineBreak:str];
    if (str == nil ||str.length == 0) {
        [self.textView setString:@""];
        return;
    }
    self.textView.string =  [GlobalMethod createModel:str className:self.textClass.stringValue];
}

#pragma mark比较 model
- (IBAction)touchModelCompare:(id)sender {
    self.tfSuperClass.stringValue = [GlobalMethod fetchModelName:self.textView.textStorage.string];
     self.textView.string = [GlobalMethod compareModel:self.textView.textStorage.string];
}
#pragma mark转换请求
- (IBAction)copyImages:(id)sender{
    [GlobalMethod copyImages];
    
}
#pragma mark转换请求
- (IBAction)touchExchangeRequest:(id)sender{
    self.textView.string = [GlobalMethod analyseData:self.textView.textStorage.string];
}

#pragma mark转换请求
- (IBAction)touchModelToJson:(id)sender{
    self.textView.string = [GlobalMethod exchangeModeltoJson:self.textView.textStorage.string];
}
#pragma mark 转换刘玉的请求
- (IBAction)analyseApiOfLiuYu:(id)sender{
    self.textView.string = [GlobalMethod analyseApiOfLiuyu:self.textView.textStorage.string];
}
#pragma mark转换请求
- (IBAction)microServiceRequest:(id)sender{
    self.textView.string = [GlobalMethod exchangeMicroServiceApi:self.textView.textStorage.string prefix:self.textClass.stringValue];
}

#pragma mark转换请求
- (IBAction)analyseAddress:(id)sender{
    self.textView.string = [GlobalMethod analyseAddress:self.textView.textStorage.string];
}
#pragma mark键盘监听
- (IBAction)keyboardObserve:(id)sender{
    [GlobalMethod addKeyboardObserve];
}
- (IBAction)removeKeyboardObserve:(id)sender{
    [GlobalMethod removeKeyobardObserve];
}
//获取h文件内容
- (NSString *)fetchHFile:(ModelProperty *)model{
    if ([GlobalMethod isAssign:model.strClass]) {
        return [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@;\n",model.strClass,model.strName];

    }
    return [NSString stringWithFormat:@"@property (strong, nonatomic) %@ *%@;\n",model.strClass,model.strName];
}

//获取m文件内容
- (NSString *)fetchLazyInit:(ModelProperty *)model{
    NSString * __block strFile = [GlobalMethod readFile:[NSString stringWithFormat:@"LazyInit_%@",model.strClass]];
    if (!isStr(strFile)) {
        strFile = [GlobalMethod readFile:@"LazyInit_CustomView"];
       strFile = [GlobalMethod replaceInString:strFile replaceString:@"UIView" withString:model.strClass];
    }
    //sld_test
    NSString * strExchange = [GlobalMethod fetchSpecific:@"Exchange" inFile:strFile block:^(NSString *strChange) {
        strFile = strChange;
    }];
    return  [GlobalMethod replaceInString:strFile replaceString:strExchange withString:model.strName];
}



//获取初始化内容
- (NSString *)fetchAddSubView:(ModelProperty *)model{
    if (model.strName.length == 0 || [GlobalMethod isNotUIKit:model.strClass]) {
        return @"";
    }
    NSMutableString * strReturn = [NSMutableString string];
    if ([self.tfSuperClass.stringValue isEqualToString:UITABLEVIEWCELL]) {
        [strReturn appendFormat:@"\t[self.contentView addSubview:self.%@];\n",model.strName];
    } else if( [self.tfSuperClass.stringValue isEqualToString:UIVIEW]) {
        [strReturn appendFormat:@"\t[self addSubview:self.%@];\n",model.strName];
    } else if([self.tfSuperClass.stringValue isEqualToString:UIVIEWCONTROLLER] ||[self.tfSuperClass.stringValue isEqualToString:BASEVC]||[self.tfSuperClass.stringValue isEqualToString:BASETABLEVC]) {
        [strReturn appendFormat:@"\t[self.view addSubview:self.%@];\n",model.strName];
    } else{
        [strReturn appendFormat:@"\t[self addSubview:self.%@];\n",model.strName];
    }

    return strReturn;
}

//获取高度内容
- (NSString *)fetchResetHeight:(ModelProperty *)model{
    if ([GlobalMethod isNotUIKit:model.strClass]) {
        return @"";
    }
    NSMutableString * strSpecial = [NSMutableString string];
    if([model.strClass isEqualToString:UILABEL]){
        strSpecial = [NSMutableString stringWithFormat:@"\t[self.%@ fitTitle:<#(NSString *)#> variable:<#(CGFloat)#>];\n",model.strName];
    }else if([model.strClass isEqualToString:UIIMAGEVIEW]) {
        strSpecial =[NSMutableString stringWithFormat:@"\n\t[self.%@ sd_setImageWithURL:[NSURL URLWithString:@\"\"] placeholderImage:[UIImage imageNamed:IMAGE_HEAD_DEFAULT]];\n",model.strName];
    }else {
        strSpecial =[NSMutableString stringWithFormat:@"\tself.%@.widthHeight = XY(W(<#宽#>), W(<#高#>));\n",model.strName];
    }
    if (isStr(model.strLeftViewName)) {
        [strSpecial appendFormat:@"\tself.%@.leftCenterY = XY(self.%@.right+W(<#向右移动#>),self.%@.centerY);\n",model.strName,model.strLeftViewName,model.strLeftViewName];
    }else{
        NSString * strTop = model.strUpViewName == nil ? @"W(<#居左#>)" : [NSString stringWithFormat:@"self.%@.bottom+W(<#向下移动#>)",model.strUpViewName];
        [strSpecial appendFormat:@"\tself.%@.leftTop = XY(W(<#居左#>),%@);\n",model.strName,strTop];
    }
    
    return strSpecial;
}

//获取其他
- (NSString *)fetchOther:(NSString *)str{
    NSMutableString * strRetun = [NSMutableString string];
    NSArray * ary = [str componentsSeparatedByString:@"\n"];
    if ([GlobalMethod isHasClass:UIBUTTON ary:ary]) {
        [strRetun appendString:[GlobalMethod readFile:[NSString stringWithFormat:@"Other_%@",UIBUTTON]]];
    }
    if ([GlobalMethod isHasClass:UITABLEVIEW ary:ary]) {
        [strRetun appendString:[GlobalMethod readFile:[NSString stringWithFormat:@"Other_%@",UITABLEVIEW]]];
    }
    if ([GlobalMethod isHasClass:UICOLLECTIONVIEW ary:ary]) {
        [strRetun appendString:[GlobalMethod readFile:[NSString stringWithFormat:@"Other_%@",UICOLLECTIONVIEW]]];
    }

    return strRetun;
}

@end
