//
//  CurrencyValueUpdatedProtocol.swift
//  CurrencyExchange
//

import Foundation

protocol CurrencyValueUpdatedProtocol : AnyObject{
    func responseuUpdated(responseDictionary : [String:AnyObject]);
}
