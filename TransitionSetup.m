/* TransitionSetup.m - initial setup of the transition filters
 
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


@implementation TransitionSelectorView (TransitionSetup)

- (void)setupTransitions
{
    CIVector  *extent;
    float      w,h;
    int        i;

    w      = thumbnailWidth;
    h      = thumbnailHeight;

    extent = [CIVector vectorWithX: 0  Y: 0  Z: w  W: h];

    transitions[0] = [CIFilter filterWithName: @"CISwipeTransition"
            keysAndValues: @"inputExtent", extent,
                @"inputColor", [CIColor colorWithRed:0  green:0 blue:0  alpha:0],
                @"inputAngle", [NSNumber numberWithFloat: 0.3*M_PI],
                @"inputWidth", [NSNumber numberWithFloat: 80.0],
                @"inputOpacity", [NSNumber numberWithFloat: 0.0], nil];

    transitions[1] = [CIFilter filterWithName: @"CIDissolveTransition"];
    
    transitions[2] = [CIFilter filterWithName: @"CISwipeTransition"			// dupe
            keysAndValues: @"inputExtent", extent,
                @"inputColor", [CIColor colorWithRed:0  green:0 blue:0  alpha:0],
                @"inputAngle", [NSNumber numberWithFloat: M_PI],
                @"inputWidth", [NSNumber numberWithFloat: 2.0],
                @"inputOpacity", [NSNumber numberWithFloat: 0.2], nil];

    transitions[3] = [CIFilter filterWithName: @"CIModTransition"
            keysAndValues:
                @"inputCenter",[CIVector vectorWithX: 0.5*w Y: 0.5*h],
                @"inputAngle", [NSNumber numberWithFloat: M_PI*0.1],
                @"inputRadius", [NSNumber numberWithFloat: 30.0],
                @"inputCompression", [NSNumber numberWithFloat: 10.0], nil];

    transitions[4] = [CIFilter filterWithName: @"CIFlashTransition"
            keysAndValues: @"inputExtent", extent,
                @"inputCenter",[CIVector vectorWithX: 0.3*w Y: 0.7*h],
                @"inputColor", [CIColor colorWithRed:1 green:.8 blue:.6 alpha:1],
                @"inputMaxStriationRadius", [NSNumber numberWithFloat: 2.5],
                @"inputStriationStrength", [NSNumber numberWithFloat: 0.5],
                @"inputStriationContrast", [NSNumber numberWithFloat: 1.37],
                @"inputFadeThreshold", [NSNumber numberWithFloat: 0.85], nil];

    transitions[5] = [CIFilter filterWithName: @"CIDisintegrateWithMaskTransition"
            keysAndValues:
                @"inputMaskImage", [self maskImage],
				@"inputShadowRadius", [NSNumber numberWithFloat: 10.0],
                @"inputShadowDensity", [NSNumber numberWithFloat:0.7],
                @"inputShadowOffset", [CIVector vectorWithX: 0.0  Y: -0.05*h], nil];

    transitions[6] = [CIFilter filterWithName: @"CIRippleTransition"
            keysAndValues: @"inputExtent", extent,
                @"inputShadingImage", [self shadingImage],
                @"inputCenter",[CIVector vectorWithX: 0.5*w Y: 0.5*h],
                @"inputWidth", [NSNumber numberWithFloat: 80],
                @"inputScale", [NSNumber numberWithFloat: 30.0], nil];

    transitions[7] = [CIFilter filterWithName: @"CICopyMachineTransition"
            keysAndValues: @"inputExtent", extent,
                @"inputColor", [CIColor colorWithRed:.6 green:1 blue:.8 alpha:1],
                @"inputAngle", [NSNumber numberWithFloat: 0],
                @"inputWidth", [NSNumber numberWithFloat: 40],
                @"inputOpacity", [NSNumber numberWithFloat: 1.0], nil];

    transitions[8] = [CIFilter filterWithName: @"CIPageCurlTransition"
            keysAndValues: @"inputExtent", extent,
                @"inputShadingImage", [self shadingImage],
				@"inputBacksideImage", [self blankImage],
                @"inputAngle",[NSNumber numberWithFloat: -0.2*M_PI],
                @"inputRadius", [NSNumber numberWithFloat: 70], nil];

    for(i=0 ; i<TRANSITION_COUNT ; i++)
        [transitions[i] retain];
}

@end
