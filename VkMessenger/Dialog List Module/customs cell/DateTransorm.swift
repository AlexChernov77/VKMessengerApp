//
//  DateTransorm.swift
//  VkMessenger
//
//  Created by Александр Чернов on 26.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import UIKit
class DateTransorm {
    class func dateTransform (timeInterval: Int) -> String
    {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date as Date)
        return localDate
    }
}
