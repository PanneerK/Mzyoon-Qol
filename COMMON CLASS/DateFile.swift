//
//  DateFile.swift
//  Mzyoon
//
//  Created by QOL on 14/05/19.
//  Copyright © 2019 QOL. All rights reserved.
//

import Foundation


class DateFile
{
    let date = Date()
    let dateFormatter1 = DateFormatter()

    func returnDateAlone() ->  String
    {
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeZone = TimeZone.current
        dateFormatter1.dateFormat = "MM/dd/yyyy"
        let date1 = dateFormatter1.string(from: date)
        
        return date1
    }
    
    func returnDateAndTime() -> String
    {
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeZone = TimeZone.current
        dateFormatter1.dateFormat = "MM/dd/yyyy hh:mm:ss"
        let date1 = dateFormatter1.string(from: date)
        
        return date1
    }
    
    func returnDateForProfile(getDate : Date) -> String
    {
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeZone = TimeZone.current
        dateFormatter1.dateFormat = "dd MMM yyyy"
        let date1 = dateFormatter1.string(from: getDate)
        
        return date1
    }
    
    func getDateAndReturnDate(getDate : Date) -> String
    {
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeZone = TimeZone.current
        dateFormatter1.dateFormat = "MM/dd/yyyy"
        let date1 = dateFormatter1.string(from: getDate)
        
        return date1
    }
}
