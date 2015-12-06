//
//  main.swift
//  4
//
//  Created by Brian Kendig on 12/4/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func md5(string: String) -> [UInt8] {
    var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
    autoreleasepool() {
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
    }
    return digest
}

func main() {
    let secret = "yzbqklnj"
    var i = 0
    var found1 = false, found2 = false

    while (!found2) {
        let key = secret + String(format:"%u", i)
        let hash = md5(key)
        if (!found1 && hash[0] == 0 && hash[1] == 0 && hash[2] < 0x10) {
            found1 = true
            print(String(format:"First hash found at %d", i))
            print(hash);
        }
        if (hash[0] == 0 && hash[1] == 0 && hash[2] == 0) {
            found2 = true
            print(String(format:"Second hash found at %d", i))
            print(hash);
        }
        i++
    }
}

main()
