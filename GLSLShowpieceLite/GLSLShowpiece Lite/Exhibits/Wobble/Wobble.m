//-------------------------------------------------------------------------
//
//	File: Wobble.m
//
//  Abstract: Wobble GLSL Exhibit
// 			 
//  Disclaimer: IMPORTANT:  This Apple software is supplied to you by
//  Apple Inc. ("Apple") in consideration of your agreement to the
//  following terms, and your use, installation, modification or
//  redistribution of this Apple software constitutes acceptance of these
//  terms.  If you do not agree with these terms, please do not use,
//  install, modify or redistribute this Apple software.
//  
//  In consideration of your agreement to abide by the following terms, and
//  subject to these terms, Apple grants you a personal, non-exclusive
//  license, under Apple's copyrights in this original Apple software (the
//  "Apple Software"], to use, reproduce, modify and redistribute the Apple
//  Software, with or without modifications, in source and/or binary forms;
//  provided that if you redistribute the Apple Software in its entirety and
//  without modifications, you must retain this notice and the following
//  text and disclaimers in all such redistributions of the Apple Software. 
//  Neither the name, trademarks, service marks or logos of Apple Inc.
//  may be used to endorse or promote products derived from the Apple
//  Software without specific prior written permission from Apple.  Except
//  as expressly stated in this notice, no other rights or licenses, express
//  or implied, are granted by Apple herein, including but not limited to
//  any patent rights that may be infringed by your derivative works or by
//  other works in which the Apple Software may be incorporated.
//  
//  The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
//  MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
//  THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
//  OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//  
//  IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
//  OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
//  MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
//  AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
//  STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
// 
//  Copyright (c) 2004-2007 Apple Inc., All rights reserved.
//
//-------------------------------------------------------------------------

#import "Wobble.h"

@implementation Wobble

- (void) initStartRadius
{
	startRadius = [[UniformData alloc] init];
	
	[startRadius initCurrent:0];
	[startRadius initMin:0];
	[startRadius initMax:60];
	[startRadius initDelta:0.01];
} // initScale

- (void) setupUniforms
{
	[self initStartRadius];
	
	glUseProgramObjectARB(programObject);
	
	glUniform3fARB([self getUniformLocation:programObject uniformName:"LightPosition"], 0.0, 0.0, 4.0);
	glUniform1iARB([self getUniformLocation:programObject uniformName:"WobbleTex"], 0);
	glUniform2fARB([self getUniformLocation:programObject uniformName:"Freq"], 4.0, 4.0);
	glUniform2fARB([self getUniformLocation:programObject uniformName:"Amplitude"], 0.05, 0.05);
	glUniform1fvARB([self getUniformLocation:programObject uniformName:"StartRad"], 1, [startRadius current]);
} // setupUniforms


- (void) initLazy
{
	[super initLazy];
	
	// Setup GLSL

	// Get a model and set its quadric
	
	model = [[Models alloc] init];

	// get all the day texture
	
	wobbleTexture = [self loadTextureFromResource: @"Day" ];
	
	// Load vertex and fragment shaders

	[self loadShadersFromResource:@"Wobble" ];

	// Setup uniforms
	
	[self setupUniforms];
} // initLazy

- (void) dealloc
{
	glDeleteTextures(1, &wobbleTexture);

	[startRadius dealloc];
	
	[model dealloc];
	
	[super dealloc];
} // dealloc

- (NSString *) name
{
	return @"Wobble";
} // name

- (NSString *) descriptionFilename
{
	return [appBundle pathForResource: @"Wobble" ofType: @"rtf"];
} // descriptionFilename

- (void) renderFrame
{
	[super renderFrame];
	
	glUseProgramObjectARB(programObject);
	
	[startRadius animate];
	
	glUniform1fvARB([self getUniformLocation:programObject uniformName:"StartRad"], 1, [startRadius current]);

	glBindTexture(GL_TEXTURE_2D, wobbleTexture);

	glRotatef(-90, 1.0, 0.0, 0.0);

	[model drawModel:kModelSolidSphere];
	
	glUseProgramObjectARB(NULL);
} // renderFrame

@end
