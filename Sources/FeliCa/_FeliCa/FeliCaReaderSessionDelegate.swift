//
//  FeliCaReaderSessionDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

@available(iOS 13.0, *)
public protocol FeliCaReaderSessionDelegate: JapanNFCReaderSessionDelegate {
    func feliCaReaderSession(didRead feliCaCard: FeliCaCard)
}

#endif