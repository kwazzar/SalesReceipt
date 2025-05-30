//
//  CoreDataStack.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import CoreData

// MARK: - Core Data Setup
final class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let model = NSManagedObjectModel()

        let itemEntity = NSEntityDescription()
        itemEntity.name = "ItemEntity"
        itemEntity.managedObjectClassName = NSStringFromClass(ItemEntity.self)

        let receiptEntity = NSEntityDescription()
        receiptEntity.name = "ReceiptEntity"
        receiptEntity.managedObjectClassName = NSStringFromClass(ReceiptEntity.self)

        let itemId = NSAttributeDescription()
        itemId.name = "id"
        itemId.attributeType = .UUIDAttributeType
        itemId.isOptional = false

        let itemDesc = NSAttributeDescription()
        itemDesc.name = "desc"
        itemDesc.attributeType = .stringAttributeType
        itemDesc.isOptional = true

        let itemPrice = NSAttributeDescription()
        itemPrice.name = "price"
        itemPrice.attributeType = .doubleAttributeType
        itemPrice.isOptional = false

        let itemImage = NSAttributeDescription()
        itemImage.name = "image"
        itemImage.attributeType = .stringAttributeType
        itemImage.isOptional = true

        let itemQuantity = NSAttributeDescription()
        itemQuantity.name = "quantity"
        itemQuantity.attributeType = .integer32AttributeType
        itemQuantity.isOptional = false
        itemQuantity.defaultValue = 1

        let receiptId = NSAttributeDescription()
        receiptId.name = "id"
        receiptId.attributeType = .UUIDAttributeType
        receiptId.isOptional = false

        let receiptDate = NSAttributeDescription()
        receiptDate.name = "date"
        receiptDate.attributeType = .dateAttributeType
        receiptDate.isOptional = true

        let receiptCustomerName = NSAttributeDescription()
        receiptCustomerName.name = "customerName"
        receiptCustomerName.attributeType = .stringAttributeType
        receiptCustomerName.isOptional = true

         let receiptPdfPath = NSAttributeDescription()
        receiptPdfPath.name = "pdfPath"
        receiptPdfPath.attributeType = .stringAttributeType
        receiptPdfPath.isOptional = true

        itemEntity.properties = [itemId, itemDesc, itemPrice, itemImage, itemQuantity]
        receiptEntity.properties = [receiptId, receiptDate, receiptCustomerName, receiptPdfPath]

        let itemsRelation = NSRelationshipDescription()
        itemsRelation.name = "items"
        itemsRelation.destinationEntity = itemEntity
        itemsRelation.minCount = 0
        itemsRelation.maxCount = 0
        itemsRelation.deleteRule = .cascadeDeleteRule
        itemsRelation.isOptional = true

        let receiptRelation = NSRelationshipDescription()
        receiptRelation.name = "receipt"
        receiptRelation.destinationEntity = receiptEntity
        receiptRelation.minCount = 0
        receiptRelation.maxCount = 1
        receiptRelation.deleteRule = .nullifyDeleteRule
        receiptRelation.isOptional = true

        itemsRelation.inverseRelationship = receiptRelation
        receiptRelation.inverseRelationship = itemsRelation

        receiptEntity.properties.append(itemsRelation)
        itemEntity.properties.append(receiptRelation)

        model.entities = [itemEntity, receiptEntity]

        let container = NSPersistentContainer(name: "SalesDatabaseModel", managedObjectModel: model)
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }

        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
               fatalError("Failed to locate document directory.")
           }
           let storeURL = documentDirectory.appendingPathComponent("SalesDatabaseModel.sqlite")
           container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//extension CoreDataStack {
//    func migrateExistingData() {
//        // Створюємо запит вручну, вказуючи ім'я сутності
//        let fetchRequest = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
//
//        do {
//            let items = try context.fetch(fetchRequest)
//            var hasChanges = false
//
//            for item in items {
//                            if item.id == nil { // Check if id is nil
//                                item.id = UUID() // Assign a new UUID
//                                hasChanges = true
//                            }
//                        }
//
//            if hasChanges {
//                try context.save()
//                print("Migration completed: Updated \(items.count) items with new UUIDs.")
//            } else {
//                print("Migration not needed: All items already have valid IDs.")
//            }
//        } catch {
//            print("Error during migration: \(error)")
//        }
//    }
//}
