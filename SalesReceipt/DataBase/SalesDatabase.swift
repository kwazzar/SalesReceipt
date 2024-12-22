//
//  SalesDatabase.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import CoreData

protocol SalesDatabaseProtocol {
    func saveReceiptToDatabase(_ receipt: Receipt)
    func fetchAllReceipts() throws -> [Receipt]
    func clearAllReceipts() throws
    func updatePdfPath(for receiptId: UUID, pdfPath: String) throws
}

final class SalesDatabase: SalesDatabaseProtocol {
    static let shared = SalesDatabase()
    private let context = CoreDataStack.shared.context

    private init() {
//        CoreDataStack.shared.migrateExistingData()
    }

    func saveReceiptToDatabase(_ receipt: Receipt) {
            let receiptEntity = ReceiptEntity(context: context)
            receiptEntity.id = receipt.id
            receiptEntity.date = receipt.date
            receiptEntity.customerName = receipt.customerName.value

            for item in receipt.items {
                let itemEntity = ItemEntity(context: context)
                itemEntity.id = item.id
                itemEntity.desc = item.description.value
                itemEntity.price = item.price.value
                itemEntity.image = item.image.value
                itemEntity.receipt = receiptEntity
            }
            CoreDataStack.shared.saveContext()

        }

    func fetchAllReceipts() throws -> [Receipt] {
        let request = NSFetchRequest<ReceiptEntity>(entityName: "ReceiptEntity")
        do {
            let results = try context.fetch(request)
            return results.map { mapReceipt(from: $0) }
        } catch {
            throw DatabaseError.fetchReceiptsFailed(underlyingError: error)
        }
    }

        func clearAllReceipts() throws {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ReceiptEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
                CoreDataStack.shared.saveContext()
            } catch {
                throw DatabaseError.clearReceiptsFailed(underlyingError: error)
            }
        }

        func updatePdfPath(for receiptId: UUID, pdfPath: String) throws {
            let request = NSFetchRequest<ReceiptEntity>(entityName: "ReceiptEntity")
            request.predicate = NSPredicate(format: "id == %@", receiptId as CVarArg)

            guard let entity = try context.fetch(request).first else {
                throw DatabaseError.updatePDFPathFailed(reason: .receiptNotFound)
            }

            entity.pdfPath = pdfPath
            CoreDataStack.shared.saveContext()
        }
    }

//MARK: - extension
extension SalesDatabase {
    private func mapItems(from entity: ReceiptEntity) -> [Item] {
        (entity.items as? Set<ItemEntity>)?.compactMap { itemEntity in
            Item(
                id: itemEntity.id,
                description: Description(itemEntity.desc),
                price: Price(itemEntity.price),
                image: ImageItem(itemEntity.image)
            )
        } ?? []
    }

    private func mapReceipt(from entity: ReceiptEntity) -> Receipt {
        return Receipt(
            id: entity.id ?? UUID(),
            date: entity.date ?? Date(),
            customerName: CustomerName(entity.customerName),
            items: mapItems(from: entity)
        )
    }
}
