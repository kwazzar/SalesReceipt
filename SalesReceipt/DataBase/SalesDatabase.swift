//
//  SalesDatabase.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import CoreData

protocol SalesDatabaseProtocol {
    func saveReceiptToDatabase(_ receipt: Receipt)
    func fetchLastReceipts(limit: Int) throws -> [Receipt]
    func fetchAllReceipts() async throws -> [Receipt]
    func clearAllReceipts() throws
    func updatePdfPath(for receiptId: UUID, pdfPath: String) throws
    func deleteReceipt(_ receiptId: UUID) throws
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
            itemEntity.id = item.id ?? UUID()
            itemEntity.desc = item.description.value
            itemEntity.price = item.price.value
            itemEntity.image = item.image.value
            itemEntity.quantity = Int32(item.quantity)
            itemEntity.receipt = receiptEntity
        }
        
        CoreDataStack.shared.saveContext()
    }

    func fetchLastReceipts(limit: Int) throws -> [Receipt] {
        let request = NSFetchRequest<ReceiptEntity>(entityName: "ReceiptEntity")
        request.fetchLimit = limit
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results = try context.fetch(request)
            return results.map { mapReceipt(from: $0) }
        } catch {
            throw DatabaseError.fetchReceiptsFailed(underlyingError: error)
        }
    }

    func fetchAllReceipts() async throws -> [Receipt] {
        return try await Task.detached(priority: .background) {
            let request = NSFetchRequest<ReceiptEntity>(entityName: "ReceiptEntity")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            do {
                let results = try self.context.fetch(request)
                return results.map { self.mapReceipt(from: $0) }
            } catch {
                throw DatabaseError.fetchReceiptsFailed(underlyingError: error)
            }
        }.value
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

    func deleteReceipt(_ receiptId: UUID) throws {
        let request = NSFetchRequest<ReceiptEntity>(entityName: "ReceiptEntity")
        request.predicate = NSPredicate(format: "id == %@", receiptId as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let receiptToDelete = results.first {
                context.delete(receiptToDelete)
                CoreDataStack.shared.saveContext()
            } else {
                throw DatabaseError.deleteReceiptFailed(reason: .receiptNotFound)
            }
        } catch {
            throw DatabaseError.deleteReceiptFailed(reason: .deletionFailed(error))
        }
    }
}

//MARK: - extension
extension SalesDatabase {
    private func mapItems(from entity: ReceiptEntity) -> [Item] {
       return (entity.items as? Set<ItemEntity>)?.compactMap { itemEntity in
            mapItemEntityToModel(itemEntity)
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

    private func mapItemEntityToModel(_ entity: ItemEntity) -> Item {
//        print("Entity Price: \(entity.price)")
        return Item(
            id: entity.id,
            description: Description(entity.desc),
            price: Price(entity.price),
            image: ImageItem(entity.image),
            quantity: Int(entity.quantity)
        )
    }
}
