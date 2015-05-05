//
//  StringExtension.swift
//  GithubClient
//
//  Created by Gru on 04/22/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import Foundation

extension String {

    func validate() -> Bool {

        // println( "validate()" )
        let regex       = NSRegularExpression( pattern: "[^0-9a-zA-Z\n\\-]", options: nil, error: nil )
        let elements    = countElements( self )
        let range       = NSMakeRange( 0, elements )

        let matches     = regex?.numberOfMatchesInString( self, options: nil, range: range )

        if matches > 0 {
            return false
        }

        return true
    }

    func validForURL() -> Bool {

        // println( "validForURL()" )
        let elements    = countElements(self)
        let range       = NSMakeRange( 0, elements )
        let regex       = NSRegularExpression( pattern: "[^0-9a-zA-Z\n]", options: nil, error: nil)
        let matches     = regex?.numberOfMatchesInString( self, options: nil, range: range )

        if matches > 0 {
            return false
        }
        
        return true
    }
}
