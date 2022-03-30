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
import IITool

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
    public let status = BehaviorRelay<APIStatus>(value: .idle)
    public let tagColor = BehaviorRelay<UIColor>(value: .activityGray)
    public let tagTitle = BehaviorRelay<String>(value: "")
    public let order = BehaviorRelay<String?>(value: nil)
    
    private(set) public var id: Int?
    
    private let disposeBag = DisposeBag()
    
    init() {
    }
    
    public init(_ eventId: Int) {
        id = eventId
    }
    
    public init(with model: ActivityAPIModel.CheckingPass?) {
        bind(with: model)
    }
    
    public func bind(with model: ActivityAPIModel.CheckingPass?) {
        guard let model = model else {
            tip.accept("-")
            return
        }
        
        id = model.EventID
        title.accept(model.Title ?? "")
        subTitle.accept(model.SubTitle ?? "")
        tip.accept(model.Salutatory ?? "")
        tagColor.accept(getActivityColor(model.ActivityType ?? .unknown))
        tagTitle.accept(getActivityTitle(model.ActivityType ?? .unknown))
        order.accept(model.Order)
        
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
            
            if startDateInRegion.compare(toDate: endDateInRegion, granularity: .day) == .orderedSame {
                oneDayOnly.accept(true)
                beginTime.accept("\(startTimeString)~\(endTimeString)")
            } else {
                oneDayOnly.accept(false)
                beginTime.accept(startTimeString)
                endTime.accept(endTimeString)
            }
        }
    }
    
    private func getActivityColor(_ type: ActivityAPIModel.CheckingPass.`Type`) -> UIColor {
        switch type {
        case .annualParty:
            return .activityYellow
        case .gamania:
            return .activityOrange
        case .epidemicPrevention:
            return .activityRed
        default:
            return .activityGray
        }
    }
    
    private func getActivityTitle(_ type: ActivityAPIModel.CheckingPass.`Type`) -> String {
        switch type {
        case .annualParty:
            return "尾牙"
        case .gamania:
            return "全局總動員"
        case .epidemicPrevention:
            return "報到"
        case .none:
            return "報到"
        default:
            return ""
        }
    }
}
