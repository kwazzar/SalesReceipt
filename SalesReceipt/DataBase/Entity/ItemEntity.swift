//
//  ItemEntity.swift
//  SalesReceipt
//
//  Created by Quasar on 06.12.2024.
//

import CoreData
// MARK: - ItemEntity
@objc(ItemEntity)
final class ItemEntity: NSManagedObject {
    @NSManaged var id: Int32
    @NSManaged var desc: String?
    @NSManaged var price: Double
    @NSManaged var image: String?
    @NSManaged var receipt: ReceiptEntity?
}
