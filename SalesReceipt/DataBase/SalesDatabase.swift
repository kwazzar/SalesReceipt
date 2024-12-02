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
        print("Saving receipt: \(receipt.id), \(receipt.customerName.value), \(receipt.date)")
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
        let request = NSFetchRequest<ReceiptEntity>(entityName: "ReceiptEntity")
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

    //MARK: - hybrid
    func updatePdfPath(for receiptId: UUID, pdfPath: String) throws {
        let request = NSFetchRequest<ReceiptEntity>(entityName: "ReceiptEntity")
        request.predicate = NSPredicate(format: "id == %@", receiptId as CVarArg)

        do {
            if let entity = try context.fetch(request).first {
                entity.pdfPath = pdfPath
                CoreDataStack.shared.saveContext()
            } else {
                throw PdfError.missingURL
            }
        } catch {
            throw PdfError.notCreated
        }
    }
}

//MARK: - extension
//extension SalesDatabase {
//    private func mapItems(from entity: ReceiptEntity) -> [Item] {
//        (entity.items as? Set<ItemEntity>)?.compactMap { itemEntity in
//            Item(
//                id: Int(itemEntity.id),
//                description: itemEntity.desc ?? "",
//                price: Price(itemEntity.price),
//                image: ImageItem(itemEntity.image)
//            )
//        } ?? []
//    }
//
//    private func mapReceipt(from entity: ReceiptEntity) -> Receipt? {
//        guard let pdfPathValue = entity.pdfPath else {
////            print("Warning: Missing PDF path for receipt \(entity.id ?? UUID()).")
//            return nil
//        }
//        return Receipt(
//            id: entity.id ?? UUID(),
//            date: entity.date ?? Date(),
//            customerName: CustomerName(entity.customerName),
//            items: mapItems(from: entity),
//            pdfPath: PdfPath(pdfPathValue)
//        )
//    }
//}
