//
//  SwiftUIView.swift
//
//
//  Created by Rodrigo Dutra on 4/19/21.
//

import SwiftUI

public extension NSUIColor {
    func codable() -> CodableColor {
        return CodableColor(color: self)
    }
}

public struct CodableColor {
    public let color: NSUIColor
}

extension CodableColor: Encodable {
    public func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        color.encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }
}

extension CodableColor: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let decodedData = try container.decode(Data.self)
        let nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        //    self.color = try NSUIColor(coder: nsCoder).unwrappedOrThrow()
        // `unwrappedOrThrow()` is from OptionalTools: https://github.com/RougeWare/Swift-Optional-Tools
        
        // You can use this if you don't want to use OptionalTools:
        
        guard let color = NSUIColor(coder: nsCoder) else {
            
            struct UnexpectedlyFoundNilError: Error {}
            
            throw UnexpectedlyFoundNilError()
        }
        
        self.color = color
    }
}
