//
//  SalesDatabase.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import CoreData

final class SalesDatabase {
    static let shared = SalesDatabase()
    private let context = CoreDataStack.shared.context
    
    func saveReceipt(_ receipt: Receipt) {
        let receiptEntity = ReceiptEntity(context: context)
        receiptEntity.id = receipt.id
        receiptEntity.date = receipt.date
        receiptEntity.customerName = receipt.customerName.value
        
        for item in receipt.items {
            let itemEntity = ItemEntity(context: context)
            itemEntity.id = Int32(item.id)
            itemEntity.desc = item.description
            itemEntity.price = item.price.value
            itemEntity.image = item.image.value
            itemEntity.receipt = receiptEntity
        }
        CoreDataStack.shared.saveContext()
    }
    
    func getAllReceipts() -> [Receipt] {
        let request = NSFetchRequest<ReceiptEntity>(entityName: "ReceiptEntity") // Создаем запрос с типом ReceiptEntity
        
        do {
            let results = try context.fetch(request)
            return results.map { entity in
                let items: [Item] = (entity.items as? Set<ItemEntity>)?.compactMap { itemEntity in
                    Item(
                        id: Int(itemEntity.id),
                        description: itemEntity.desc ?? "",
                        price: Price(itemEntity.price),
                        image: ImageItem(itemEntity.image)
                    )
                } ?? []
                
                return Receipt(
                    id: entity.id ?? UUID(),
                    date: entity.date ?? Date(),
                    customerName: CustomerName(entity.customerName),
                    items: items
                )
            }
        } catch {
            print("Failed to fetch receipts: \(error)")
            return []
        }
    }
    
    func clearAllReceipts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ReceiptEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            CoreDataStack.shared.saveContext()
        } catch {
            print("Failed to clear receipts: \(error)")
        }
    }
}
