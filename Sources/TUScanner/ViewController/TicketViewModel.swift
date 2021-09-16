//
//  File.swift
//  
//
//  Created by ice on 2021/9/7.
//

import Foundation
import RxSwift
import RxRelay
import UIKit.UIImage
import SwiftDate
import TUStyle
import TUCore

public class TicketViewModel {
    public let title = BehaviorRelay<String>(value: "")
    public let subTitle = BehaviorRelay<String>(value: "")
    public let qrcode = BehaviorRelay<UIImage?>(value: nil)
    public let createTime = BehaviorRelay<String>(value: "")
    public let oneDayOnly = BehaviorRelay<Bool>(value: true)
    public let beginDay = BehaviorRelay<String>(value: "")
    public let beginTime = BehaviorRelay<String>(value: "")
    public let endDay = BehaviorRelay<String>(value: "")
    public let endTime = BehaviorRelay<String>(value: "")
    public let tip = BehaviorRelay<String>(value: "")
    
    private(set) public var id: Int?
    
    private let disposeBag = DisposeBag()
    
    public init() {
    }
    
    public func bind(with model: ActivityAPIModel.CheckingPass) {
        id = model.EventID
        title.accept(model.Title ?? "")
        subTitle.accept(model.SubTitle ?? "")
        tip.accept(model.Salutatory ?? "")
        
        if let dateInRegion = model.CheckingDatetime?.toDate(region: .current) {
            let date = dateInRegion.date
            let weekday = dateInRegion.weekdayName(.veryShort)
            let day = dateInRegion.formatter(format: "yyyy/MM/dd").string(from: date)
            let time = dateInRegion.formatter(format: "HH:mm").string(from: date)
            let string = day.appending("(\(weekday))").appending(time)
            createTime.accept(string)
        }
        
        if let startDateInRegion = model.StartDatetime?.toDate(region: .current),
           let endDateInRegion = model.EndDatetime?.toDate(region: .current) {
            let startWeekday = startDateInRegion.weekdayName(.veryShort)
            let endWeekday = endDateInRegion.weekdayName(.veryShort)
            
            let start = startDateInRegion.date
            let end = endDateInRegion.date
            
            let startDayString = startDateInRegion.formatter(format: "yyyy/MM/dd").string(from: start)
            let endDayString = endDateInRegion.formatter(format: "yyyy/MM/dd").string(from: end)
            
            beginDay.accept(startDayString.appending("(\(startWeekday))"))
            endDay.accept(endDayString.appending("(\(endWeekday))"))
            
            let startTimeString = startDateInRegion.formatter(format: "HH:mm").string(from: start)
            let endTimeString = endDateInRegion.formatter(format: "HH:mm").string(from: end)
            
            if start.compare(toDate: end, granularity: .day) == .orderedSame {
                oneDayOnly.accept(true)
                beginTime.accept("\(startTimeString)~\(endTimeString)")
            } else {
                oneDayOnly.accept(false)
                beginTime.accept(startTimeString)
                endTime.accept(endTimeString)
            }
        }
    }
}
