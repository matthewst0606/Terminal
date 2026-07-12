//
//  FrameLibrary.swift
//  Terminal++
//
//  Created by Matt on 7/10/26.
//
import SwiftUI

enum FrameLib {
    case sidebar
    case jobsList
    case backgroundJobsRow
    case smallSymbol
    case list
    case overlayList
    case textbox
    case overlayContent
    case overlay

    var minWidth: CGFloat? {
        switch self {
        case .overlay, .overlayContent:
            return 200
            
        default: return nil
        }
    }
    
    var maxWidth: CGFloat? {
        switch self{
        case .overlayContent, .textbox, .list:
            return .infinity
            
            
        case .overlayList:
            return 250

        default:
            return nil

        }
        
    }
    
    var width: CGFloat? {
        switch self {
            
        case .sidebar:
            return 150
            
        case .jobsList, .backgroundJobsRow:
            return 280
            
        case .overlay, .overlayList:
            return 250

        case .smallSymbol:
            return 24

            
            
        default:
            return nil
        }
    }
    
    var minHeight: CGFloat? {
        switch self {
        case .overlayContent:
            return 100
            
        default: return nil
        }
    }
    
    var maxHeight: CGFloat? {
        switch self {
        case .overlayContent, .list, .overlayList:
            return .infinity
            
            
        default:
            return nil
        }
    }
    
    
    var height: CGFloat? {
        switch self {
            
        case .textbox:
            return 70

        case .smallSymbol:
            return 24
            
        default:
            return nil
        }
    }
    
    var alignment: Alignment? {
        switch self {
            
        case .jobsList, .backgroundJobsRow, .list:
            return .topLeading
            
        case .sidebar:
            return .topTrailing

        case .overlayContent:
            return .top
            
        default: return nil
        }
    }

    var padding: CGFloat {
        switch self {
        case .sidebar: 8
        case .overlay, .overlayContent, .overlayList: 12
        case .jobsList, .backgroundJobsRow: 14
        case .textbox: 8
        case .smallSymbol: 0
        case .list: 5
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .sidebar, .overlay: 14
        case .overlayContent, .overlayList, .list, .jobsList, .backgroundJobsRow: 12
        case .textbox: 10
        case .smallSymbol: 6
        }
    }
}
