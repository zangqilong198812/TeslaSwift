//
//  RemoteSteeringWheelHeaterRequestOptions.swift
//  TeslaSwift
//
//  Created by Jordan Owens on 2/17/19.
//  Copyright © 2019 Jordan Owens. All rights reserved.
//

import Foundation

open class RemoteSteeringWheelHeaterRequestOptions: Encodable {
    open var on: Bool

    public init(on: Bool) {
        self.on = on
    }

    enum CodingKeys: String, CodingKey {
        case on
    }
}
