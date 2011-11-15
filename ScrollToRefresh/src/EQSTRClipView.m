//
//  EQSTRClipView.m
//  ScrollToRefresh
//
// Copyright (C) 2011 by Alex Zielenski.

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "EQSTRClipView.h"
#import "EQSTRScrollView.h"

@implementation EQSTRClipView
- (NSPoint)constrainScrollPoint:(NSPoint)proposedNewOrigin { // this method determines the "elastic" of the scroll view or how high it can scroll without resistence. 
	NSPoint constrained = [super constrainScrollPoint:proposedNewOrigin];
	CGFloat scrollValue = proposedNewOrigin.y+self.documentVisibleRect.size.height; // this is the y value where the top of the document view is
	
	if (self.isRefreshing) { // if we are refreshing
		if (scrollValue>=self.headerView.frame.origin.y) { // and if we are scrolled past the refresh view
			if (scrollValue>=self.headerView.frame.origin.y+self.headerView.frame.size.height) // and if we are scrolled above the refresh view
				proposedNewOrigin.y = constrained.y+self.headerView.frame.size.height; // constrain us to the refresh view
			return NSMakePoint(constrained.x, proposedNewOrigin.y);
		}
	}
	return constrained;
}
- (NSRect)documentRect { //this is to make scrolling feel more normal so that the spinner is within the scrolled area
	NSRect sup = [super documentRect];
	if (self.isRefreshing) {
		sup.size.height+=self.headerView.frame.size.height;
	}
	return sup;
}
- (BOOL)isRefreshing {
	return [(EQSTRScrollView*)self.superview isRefreshing];
}
- (NSView*)headerView {
	return [(EQSTRScrollView*)self.superview refreshHeader];
}
- (BOOL)isFlipped {
	return NO;
}
@end
