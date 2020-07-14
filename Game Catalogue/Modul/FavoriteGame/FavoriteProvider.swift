//
//  FavoriteProvider.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 14/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//
import CoreData
import Foundation

class FavoriteProvider {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteGame")
        
        container.loadPersistentStores { storeDesription, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllMember(completion: @escaping(_ members: [FavoriteModel]) -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGame")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var members: [FavoriteModel] = []
                for result in results {
                    let member = FavoriteModel(id_game: result.value(forKeyPath: "id_game") as? Int32,
                                             name_game: result.value(forKeyPath: "name_game") as? String,
                                             release_game: result.value(forKeyPath: "release_game") as? String,
                                             rating_game: result.value(forKeyPath: "ratting_game") as? String,
                                             image_game: result.value(forKeyPath: "image_game") as? String)
                    
                    members.append(member)
                }
                completion(members)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getMember(_ id: Int, completion: @escaping(_ members: FavoriteModel) -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGame")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first{
                    let member = FavoriteModel(id_game: result.value(forKeyPath: "id_game") as? Int32,
                                             name_game: result.value(forKeyPath: "name_game") as? String,
                                             release_game: result.value(forKeyPath: "release_game") as? String,
                                             rating_game: result.value(forKeyPath: "ratting_game") as? String,
                                             image_game: result.value(forKeyPath: "image_game") as? String
                                             )
                    completion(member)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func createMember(_ idGame:Int32, _ nameGame: String, _ releaseGame: String, _ rattingGame: String, _ imageGame: String, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: taskContext) {
                let member = NSManagedObject(entity: entity, insertInto: taskContext)
                self.getMaxId { (id) in
                    member.setValue(idGame, forKeyPath: "id_game")
                    member.setValue(nameGame, forKeyPath: "name_game")
                    member.setValue(releaseGame, forKeyPath: "release_game")
                    member.setValue(rattingGame, forKeyPath: "ratting_game")
                    member.setValue(imageGame, forKeyPath: "image_game")
                    
                    do {
                        try taskContext.save()
                        completion()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            }
        }
    }
    
    func getMaxId(completion: @escaping(_ maxId: Int) -> ()) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGame")
            let sortDescriptor = NSSortDescriptor(key: "id_game", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchLimit = 1
            do {
                let lastMember = try taskContext.fetch(fetchRequest)
                if let member = lastMember.first, let position = member.value(forKeyPath: "id_game") as? Int{
                    completion(position)
                } else {
                    completion(0)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
        
    func deleteMember(_ id: Int, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id_game == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }
}
