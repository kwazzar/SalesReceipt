//
//  ReceiptEntity.swift
//  SalesReceipt
//
//  Created by Quasar on 06.12.2024.
//

import CoreData
// MARK: - ReceiptEntity
@objc(ReceiptEntity)
final class ReceiptEntity: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var date: Date?
    @NSManaged var customerName: String?
    @NSManaged var items: NSSet?
    @NSManaged var pdfPath: String?
}
