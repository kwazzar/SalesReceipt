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
    @NSManaged var id: UUID
    @NSManaged var desc: String?
    @NSManaged var price: Double
    @NSManaged var image: String?
    @NSManaged var quantity: Int32
    @NSManaged var receipt: ReceiptEntity?
}

extension ItemEntity {
    @objc
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
    }
}
