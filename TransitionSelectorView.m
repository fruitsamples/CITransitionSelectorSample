/* TransitionSelectorView.m - simple CG based CoreImage view 
 
 Version: 1.1
 
 © Copyright 2006-2009 Apple, Inc. All rights reserved.
 
 IMPORTANT:  This Apple software is supplied to 
 you by Apple Computer, Inc. ("Apple") in 
 consideration of your agreement to the following 
 terms, and your use, installation, modification 
 or redistribution of this Apple software 
 constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, 
 install, modify or redistribute this Apple 
 software.
 
 In consideration of your agreement to abide by 
 the following terms, and subject to these terms, 
 Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this 
 original Apple software (the "Apple Software"), 
 to use, reproduce, modify and redistribute the 
 Apple Software, with or without modifications, in 
 source and/or binary forms; provided that if you 
 redistribute the Apple Software in its entirety 
 and without modifications, you must retain this 
 notice and the following text and disclaimers in 
 all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or 
 logos of Apple Computer, Inc. may be used to 
 endorse or promote products derived from the 
 Apple Software without specific prior written 
 permission from Apple.  Except as expressly 
 stated in this notice, no other rights or 
 licenses, express or implied, are granted by 
 Apple herein, including but not limited to any 
 patent rights that may be infringed by your 
 derivative works or by other works in which the 
 Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS 
 IS" basis.  APPLE MAKES NO WARRANTIES, EXPRESS OR 
 IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED 
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY 
 AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING 
 THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE 
 OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY 
 SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL 
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, 
 REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF 
 THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER 
 UNDER THEORY OF CONTRACT, TORT (INCLUDING 
 NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN 
 IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF 
 SUCH DAMAGE.
 
 */

#import "TransitionSelectorView.h"




@implementation TransitionSelectorView

- (void)awakeFromNib
{
    NSTimer    *timer;
    NSURL      *url;

    thumbnailWidth  = 340.0;
    thumbnailHeight = 240.0;
    thumbnailGap    = 20.0;


    url   = [NSURL fileURLWithPath: [[NSBundle mainBundle]
        pathForResource: @"Rose" ofType: @"jpg"]];
    [self setSourceImage: [CIImage imageWithContentsOfURL: url]];


    url   = [NSURL fileURLWithPath: [[NSBundle mainBundle]
        pathForResource: @"Frog" ofType: @"jpg"]];
    [self setTargetImage: [CIImage imageWithContentsOfURL: url]];


    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0/30.0  target: self
        selector: @selector(timerFired:)  userInfo: nil  repeats: YES];

    base = [NSDate timeIntervalSinceReferenceDate];
    [[NSRunLoop currentRunLoop] addTimer: timer  forMode: NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer: timer  forMode: NSEventTrackingRunLoopMode];
}


- (void)setSourceImage: (CIImage *)source
{
    [source retain];
    [sourceImage release];
    sourceImage = source;
}

- (void)setTargetImage: (CIImage *)target
{
    [target retain];
    [targetImage release];
    targetImage = target;
}

- (CIImage *)shadingImage
{
    if(!shadingImage)
    {
        NSURL  *url;

        url   = [NSURL fileURLWithPath: [[NSBundle mainBundle]
            pathForResource: @"Shading" ofType: @"tiff"]];
        shadingImage = [[CIImage alloc] initWithContentsOfURL: url];
    }

    return shadingImage;
}

- (CIImage *)blankImage
{
    if(!blankImage)
    {
        NSURL  *url;

        url   = [NSURL fileURLWithPath: [[NSBundle mainBundle]
            pathForResource: @"Blank" ofType: @"jpg"]];
        blankImage = [[CIImage alloc] initWithContentsOfURL: url];
    }

    return blankImage;
}

- (CIImage *)maskImage
{
    if(!maskImage)
    {
        NSURL  *url;

        url   = [NSURL fileURLWithPath: [[NSBundle mainBundle]
            pathForResource: @"Mask" ofType: @"jpg"]];
        maskImage = [[CIImage alloc] initWithContentsOfURL: url];
    }

    return maskImage;
}

- (void)timerFired: (id)sender
{
    [self setNeedsDisplay: YES];
}


- (CIImage *)imageForTransition: (int)transitionNumber  atTime: (float)t
{
    CIFilter  *transition, *crop;

    transition    = transitions[transitionNumber];

    if(fmodf(t, 2.0) < 1.0f)
    {
        [transition setValue: sourceImage  forKey: @"inputImage"];
        [transition setValue: targetImage  forKey: @"inputTargetImage"];
    }

    else
    {
        [transition setValue: targetImage  forKey: @"inputImage"];
        [transition setValue: sourceImage  forKey: @"inputTargetImage"];
    }

    [transition setValue: [NSNumber numberWithFloat: 0.5*(1-cos(fmodf(t, 1.0f) * M_PI))]
        forKey: @"inputTime"];

    crop = [CIFilter filterWithName: @"CICrop"
        keysAndValues: @"inputImage", [transition valueForKey: @"outputImage"],
            @"inputRectangle", [CIVector vectorWithX: 0  Y: 0
            Z: thumbnailWidth  W: thumbnailHeight], nil];

    return [crop valueForKey: @"outputImage"];
}

- (void)drawRect: (NSRect)rectangle
{
    CGPoint origin;
    CGRect  thumbFrame;
    float   t;
    int     w,i;

    thumbFrame = CGRectMake(0,0, thumbnailWidth,thumbnailHeight);
    t          = 0.4*([NSDate timeIntervalSinceReferenceDate] - base);

	CIContext* context = [[NSGraphicsContext currentContext] CIContext];

    if(transitions[0] == nil)
        [self setupTransitions];

    w = (int)ceil(sqrt((double)TRANSITION_COUNT));

    for(i=0 ; i<TRANSITION_COUNT ; i++)
    {
        origin.x = (i % w) * (thumbnailWidth  + thumbnailGap);
        origin.y = (i / w) * (thumbnailHeight + thumbnailGap);
	
		if (context != nil)
			[context drawImage: [self imageForTransition: i
				atTime: t + 0.1*i]  atPoint: origin  fromRect: thumbFrame];
    }
}

@end
