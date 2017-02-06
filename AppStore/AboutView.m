//
//  AboutView.m
//  AppStore
//
//  Created by 王宝 on 15/8/13.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "AboutView.h"
#import <CoreText/CoreText.h>

@implementation AboutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawTextAndPicture];
}

- (void)drawTextAndPicture {
    //创建上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //转换矩阵
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    NSMutableAttributedString *attsting = [[NSMutableAttributedString alloc] initWithString:_text];
    
    //设置CTRunDelegate，决定留给图片的空间大小
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.dealloc = RunDelegateDeallocCallback;
    callbacks.getAscent = RunDelegateGetAscentCallback;
    callbacks.getDescent = RunDelegateGetDescentCallback;
    callbacks.getWidth = RunDelegateGetWidthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(_imgName));
    
    //使用0xFFFC座位空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *string = [NSString stringWithCharacters:&objectReplacementChar length:1];
    string = @"a";
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:string];
    
    [space addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)delegate range:NSMakeRange(0, 1)];
    
    [space addAttribute:@"imageName" value:_imgName range:NSMakeRange(0, 1)];
    
    [attsting insertAttributedString:space atIndex:0];
    
    CFRelease(delegate);
    
    //换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting settings[] = {
        lineBreakMode
    };
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(__bridge id)kCTParagraphStyleAttributeName];
    
    [attsting addAttributes:attribute range:NSMakeRange(0, attsting.length)];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attsting);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(frame, context);
    
    
    //获取图片在绘制时的位置
    CFArrayRef lines = CTFrameGetLines(frame);
    CGPoint lineOrigns[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigns);
    
    for (int i=0; i<CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        for (int j=0; j<CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigns[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            //NSLog(@"width = %f",runRect.size.width);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imageName"];
            
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = CGSizeMake(65, 105);
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y;
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(framesetter);
    CFRelease(path);
    
}


void RunDelegateDeallocCallback( void* refCon ){
    
}

CGFloat RunDelegateGetAscentCallback( void *refCon ){
    //NSString *imageName = (__bridge NSString *)refCon;
    return 105;//[UIImage imageNamed:imageName].size.height;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    //NSString *imageName = (__bridge NSString *)refCon;
    return 75;//[UIImage imageNamed:imageName].size.width;
}



@end
