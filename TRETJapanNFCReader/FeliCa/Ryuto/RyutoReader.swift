//
//  RyutoReader.swift
//  DriversLicenseReader
//
//  Created by treastrain on 2019/11/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

@available(iOS 13.0, *)
public typealias RyutoCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class RyutoReader: FeliCaReader {
    
    private var ryutoCardItemTypes: [RyutoCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// RyutoReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// RyutoReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// RyutoReader を初期化する。
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    public override init(viewController: FeliCaReaderViewController) {
        super.init(viewController: viewController)
    }
    
    /// りゅーと からデータを読み取る
    /// - Parameter itemTypes: りゅーと から読み取りたいデータのタイプ
    public func get(itemTypes: [RyutoCardItemType]) {
        self.ryutoCardItemTypes = itemTypes
        self.beginScanning()
    }
    
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, itemTypes: [RyutoCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        self.ryutoCardItemTypes = itemTypes
        self.getItems(session, feliCaTag: feliCaTag, idm: idm, systemCode: systemCode) { (feliCaCard) in
            completion(feliCaCard)
        }
    }
    
    public override func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, completion: @escaping (FeliCaCard) -> Void) {
        var ryutoCard = RyutoCard(tag: feliCaTag, data: RyutoCardData(idm: idm, systemCode: systemCode))
        DispatchQueue(label: "TRETJPNRRyutoReader", qos: .default).async {
            var services: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.ryutoCardItemTypes {
                services[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: ryutoCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            ryutoCard.data.contents[systemCode] = FeliCaSystem(systemCode: systemCode, idm: idm, services: services)
            completion(ryutoCard)
        }
    }
}

#endif
