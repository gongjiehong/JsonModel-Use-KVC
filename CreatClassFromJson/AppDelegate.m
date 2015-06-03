//
//  AppDelegate.m
//  CreatClassFromJson
//
//  Created by 龚杰洪 on 15/2/3.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "AppDelegate.h"
#import "DragView.h"
#import "NSString+com.h"

@interface AppDelegate () < DragViewDelagate >
{
    NSURL *_loadURL;
    NSString *_fileName;
}
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet DragView *dragView;
@property (weak) IBOutlet NSTextField *urlField;
@property (weak) IBOutlet NSTextField *nameField;
@property (strong) IBOutlet NSTextView *dataView;
@property (weak) IBOutlet NSButton *imgView;
@property (strong) NSURL *fileURL;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.dragView.delegate = self;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (void)onLoadFile
{
    self.imgView.image = [NSImage imageNamed:@"hasFile.png"];
}

- (NSDictionary *)creatFile:(NSDictionary *)data path:(NSString *)name
{
    NSMutableString *temp = [NSMutableString stringWithFormat:@"@interface %@ : JsonBaseModel\n", [name onlyCapitalizedFistString]];
    NSMutableString *imTemp = [NSMutableString stringWithFormat:@"@implementation %@\n", [name onlyCapitalizedFistString]];
    __block NSString *subArrayClass = @"";
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        if ([obj isKindOfClass:[NSArray class]])
        {
            if ([obj count] > 0)
            {
                id subTemp = obj[0];
                while ([subTemp isKindOfClass:[NSArray class]])
                {
                    if ([subTemp count] > 0)
                    {
                        subTemp = subTemp[0];
                    }
                    else
                    {
                        subTemp = @"";
                    }
                }
                if ([subTemp isKindOfClass:[NSDictionary class]])
                {
                    NSString *subName = [NSString stringWithFormat:@"%@%@",
                                         [name onlyCapitalizedFistString],
                                         [key onlyCapitalizedFistString]];
                    
                    NSDictionary *tempDic = [self creatFile:subTemp path:subName];
                    NSString *subTemp = tempDic[@"interface"];
                    NSString *subImpTemp = tempDic[@"implementation"];
                    [temp insertString:subTemp atIndex:0];
                    [imTemp insertString:subImpTemp atIndex:0];
                    if (subArrayClass.length == 0)
                    {
                        subArrayClass = [NSString stringWithFormat:@"\n-(Class)getItemClassWithPropretyName:(NSString *)name\n{\n    if ([name isEqualToString:@\"%@\"])\n    {\n        return [%@ class];\n    }",key,subName];
                    }
                    else
                    {
                        subArrayClass = [subArrayClass stringByAppendingFormat:@"\n    else if ([name isEqualToString:@\"%@\"])\n    {\n        return [%@ class];\n    }",key,subName];
                    }
                    
                }
                else
                {
                    
                }
            }
            
            [temp appendFormat:@"@property (strong, nonatomic) NSMutableArray *%@;\n",key];
        }
        else if([obj isKindOfClass:[NSDictionary class]])
        {
            NSString *subName = [NSString stringWithFormat:@"%@%@",[name onlyCapitalizedFistString],[key onlyCapitalizedFistString]];
            NSDictionary *tempDic = [self creatFile:obj path:subName];
            NSString *subTemp = tempDic[@"interface"];
            NSString *subImpTemp = tempDic[@"implementation"];
            [temp insertString:subTemp atIndex:0];
            [imTemp insertString:subImpTemp atIndex:0];
            [temp appendFormat:@"@property (strong, nonatomic) %@ *%@;\n",subName,key];
            if (subArrayClass.length == 0)
            {
                subArrayClass = [NSString stringWithFormat:@"\n-(Class)getItemClassWithPropretyName:(NSString *)name\n{\n    if ([name isEqualToString:@\"%@\"])\n    {\n        return [%@ class];\n    }",key,subName];
            }
            else
            {
                subArrayClass = [subArrayClass stringByAppendingFormat:@"\n    else if ([name isEqualToString:@\"%@\"])\n    {\n        return [%@ class];\n    }",key,subName];
            }

        }
        else
        {
            [temp appendFormat:@"@property (strong, nonatomic) NSString *%@;\n",key];
        }
    }];

    [temp appendString:@"\n@end\n\n"];

    if (subArrayClass.length > 0)
    {
        subArrayClass = [subArrayClass stringByAppendingString:@"\n    return [NSString class];\n}\n"];
        [imTemp appendString:subArrayClass];
    }

    [imTemp appendFormat:@"\n@end\n\n"];

    return @{ @"interface" : temp,
              @"implementation" : imTemp };
}
- (void)creat
{
    NSURL *temp = self.fileURL;
    if (_loadURL != nil)
    {
        temp = _loadURL;
    }
    NSData *data = nil;
    if (self.dataView.string.length > 0)
    {
        data = [self.dataView.string dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        data = [NSData dataWithContentsOfURL:temp];
    }
    if (data == nil)
    {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/%@", _fileName];
    NSDictionary *result = [self creatFile:dic path:_fileName];
    NSString *interFace = result[@"interface"];
    interFace = [NSString stringWithFormat:@"#import \"JsonBaseModel.h\"\n\n%@", interFace];
    NSString *implace = result[@"implementation"];
    implace = [NSString stringWithFormat:@"#import \"%@.h\"\n\n%@", [_fileName onlyCapitalizedFistString], implace];
    NSString *interpath = [NSString stringWithFormat:@"%@.h", path];
    NSString *imPath = [NSString stringWithFormat:@"%@.m", path];
    [interFace writeToFile:interpath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [implace writeToFile:imPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (IBAction)onload:(id)sender
{
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    NSArray *filesToOpen;

    [oPanel setAllowsMultipleSelection:NO];
    [oPanel setCanChooseDirectories:NO];
    [oPanel setCanChooseFiles:YES];

    long result = [oPanel runModal];
    if (result == 1)
    {
        filesToOpen = [oPanel URLs];
        self.fileURL = [filesToOpen objectAtIndex:0];
        [self onLoadFile];
    }
}

- (IBAction)onStart:(id)sender
{
    _fileName = self.nameField.stringValue;
    if (self.urlField.stringValue.length > 0)
    {
        _loadURL = [NSURL URLWithString:self.urlField.stringValue];
    }
    else
    {
        _loadURL = nil;
    }
    if (_fileName.length == 0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"请输入文件名";
        [alert beginSheetModalForWindow:self.window completionHandler:nil];
    }
    else if (_loadURL == nil && self.fileURL == nil && self.dataView.string.length == 0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"请输入URL,加入文件或者输入数据";
        [alert beginSheetModalForWindow:self.window completionHandler:nil];
    }
    else
    {
        [self creat];
    }
}

#pragma mark - drage view delegate

- (BOOL)dragFileURL:(NSURL *)fileURL
{
    NSString *path = [fileURL path];
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (isDir)
    {
        return NO;
    }
    self.fileURL = fileURL;
    [self onLoadFile];
    [self.window becomeKeyWindow];
    [self.window becomeFirstResponder];
    return YES;
}

@end
