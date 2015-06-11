//
//  MolonDebug.h
//
//  Created by Molon on 13-10-4.
//  Copyright (c) 2013年 Molon. All rights reserved.
//

#ifndef MolonFramework_Debug_h
#define MolonFramework_Debug_h

#ifdef DEBUG

#define DLOG(format, ...)                   \
NSLog(@"\n%s:%d\n%@",               \
__PRETTY_FUNCTION__, __LINE__,      \
[NSString stringWithFormat:format, ## __VA_ARGS__])

#define _po(o) DLOG(@"%@", (o))
#define _pn(o) DLOG(@"%d", (o))
#define _pf(o) DLOG(@"%f", (o))
#define _ps(o) DLOG(@"CGSize: {%.0f, %.0f}", (o).width, (o).height)
#define _pr(o) DLOG(@"NSRect: {{%.0f, %.0f}, {%.0f, %.0f}}", (o).origin.x, (o).origin.y, (o).size.width, (o).size.height)

#define DOBJ(obj)  DLOG(@"%s: %@", #obj, [(obj) description])

#define MARK    NSLog(@"\nMARK: %s, %d", __PRETTY_FUNCTION__, __LINE__)

#define START_TIMER                 \
NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
#define END_TIMER(msg)              \
DLOG(@"%@ Time = %f",msg,[NSDate timeIntervalSinceReferenceDate]-start);


#define DEALLOC_DLOG \
- (void)dealloc \
{ \
DLOG(@"dealloc %@",NSStringFromClass([self class])); \
} \


#define DLOG_DEALLOC DLOG(@"dealloc %@",NSStringFromClass([self class]));

#else

#define DLOG(format, ...)
#define _po(o)
#define _pn(o)
#define _pf(o)
#define _ps(o)
#define _pr(o)
#define DOBJ(obj)
#define MARK
#define START_TIMER
#define END_TIMER
#define DEALLOC_DLOG 
#define DLOG_DEALLOC

#endif

#ifdef DEBUG

#define LOG(...) NSLog(__VA_ARGS__)
#define LOG_METHOD \
NSLog(@"\nLine:%d\nFunction:%s\n", __LINE__, __FUNCTION__)
#else
#define LOG(...)
#define LOG_METHOD
#endif

#endif
