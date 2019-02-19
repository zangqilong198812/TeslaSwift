//
//  RemoteSeatHeaterRequestOptions.swift
//  TeslaSwift
//
//  Created by Jordan Owens on 2/17/19.
//  Copyright © 2019 Jordan Owens. All rights reserved.
//

import Foundation

open class RemoteSeatHeaterRequestOptions: Encodable {

    open var seat: SeatHeater
    open var level: Int

    init(seat: SeatHeater, level: Int) {
        self.seat = seat
        self.level = level
    }

    enum CodingKeys: String, CodingKey {
        case seat = "heater"
        case level = "level"
    }
}

public enum SeatHeater: Int, Encodable {
    case driver = 0
    case passenger = 1
    case rearLeft = 2
    case rearLeftBack = 3
    case rearCenter = 4
    case rearRight = 5
    case rearRightBack = 6
    case thirdRowLeft = 7
    case thirdRowRight = 8
}
