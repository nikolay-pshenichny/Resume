#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <Foundation/NSRegularExpression.h>

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        if (argc > 1)
        {
            NSString * fileName = [NSString stringWithUTF8String: argv[1]];
            
            
            NSFileManager * fileManager = [NSFileManager defaultManager];
            
            if ([fileManager fileExistsAtPath:fileName] == YES)
            {
                // Get values from the AddressBook
                NSMutableDictionary * properties = [NSMutableDictionary dictionary];
                ABAddressBook * ab = [ABAddressBook sharedAddressBook];
                ABPerson * me = ab.me;
                
                // Primary Email
                ABMultiValue * emails = [me valueForProperty:kABEmailProperty];
                long i = [emails indexForIdentifier:[emails primaryIdentifier]];
                NSString * primaryEmail = [emails valueAtIndex:i];
                [properties setValue:primaryEmail forKey:@"{Email}"];
                
                // Primary address
                ABMultiValue * addrs =  [me valueForProperty:kABAddressProperty];
                long j =[addrs indexForIdentifier:[addrs primaryIdentifier]];
                NSDictionary * primaryAddress = [addrs valueAtIndex:j];
                NSString* street = [primaryAddress objectForKey:kABAddressStreetKey];
                NSString* city = [primaryAddress objectForKey:kABAddressCityKey];
                NSString* state = [primaryAddress objectForKey:kABAddressStateKey];
                NSString* zip = [primaryAddress objectForKey:kABAddressZIPKey];
                [properties setValue:street forKey:@"{Street}"];
                [properties setValue:city forKey:@"{City}"];
                [properties setValue:state forKey:@"{State}"];
                [properties setValue:zip forKey:@"{ZIP}"];
                
                
                // Primary phone
                ABMultiValue * phones = [me valueForProperty:kABPhoneProperty];
                long k = [phones indexForIdentifier:[phones primaryIdentifier]];
                NSString * primaryPhone = [phones valueAtIndex:k];
                [properties setValue:primaryPhone forKey:@"{Phone}"];
                
                
                // Read file
                NSString *fileContentAsString = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
                
                // Substitute values
                for( NSString * key in properties)
                {
                    NSString * value = [properties valueForKey:key];
                    
                    fileContentAsString = [fileContentAsString stringByReplacingOccurrencesOfString:key withString:value];
                }
                
                // Save changes
                [fileContentAsString writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:Nil];
                
                
                /*
                 NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"(\\{[\\w]+\\})" options:NSRegularExpressionCaseInsensitive error:NULL];
                 
                 //NSUInteger matchesCount = [regex numberOfMatchesInString:a options:0 range:NSMakeRange(0, [a length])];
                 //printf("%lu", (unsigned long)matchesCount );
                 
                 NSMutableDictionary * properties = [NSMutableDictionary dictionary];
                 
                 NSArray * matches = [regex matchesInString:fileContentAsString options:0 range:NSMakeRange(0, [fileContentAsString length])];
                 
                 for (NSTextCheckingResult * match in matches) {
                 NSRange range = [match range];
                 NSString * key = [fileContentAsString substringWithRange:range];
                 NSString * addressBookPropertyName =[key substringWithRange:NSMakeRange(1, [key length]-2)];
                 printf("%s", [key UTF8String]);
                 
                 [properties setValue:addressBookPropertyName forKey:key];
                 }
                 
                 */
                
            }
            else
            {
                NSLog(@"File not found");
            }
        }
        else
        {
            NSLog(@"First argument should be a file path");
        }
    }
    return 0;
}   