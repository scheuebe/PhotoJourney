//
//  DataController.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 10.01.22.
//

import CoreData
import SwiftUI
import Combine

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {
    @AppStorage("surveySize") var surveySize: Int = 1
    
    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer
    
    @State var soundObjectController = SoundObjectController.shared
    
    /// for ML model
    let model = Resnet50()
    @State private var predictsToShow: Int = 1
    // @State private var resultFromClassification: String = ""
    // @State private var classificationLabel: String = ""

    /// Initialized a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs.)
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        // For testing and previewing purposes, we create a temporary,
        // in-memory database by writing to /dev/null so our data is
        // destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
            }
            #endif
        }
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    /// Creates example albums and items to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        // for albumCounter in 17...18 {
            let album = Album(context: viewContext)
            album.title = "Tomorrowland 2019"
            album.detail = "Boom, Belgium"
            album.items = []
            album.creationDate = Date()

            let image = UIImage(named: "tomorrowland-coverImage")
            let imageData = image?.jpegData(compressionQuality: 0.8)
            album.coverImage = imageData
            album.closed = false

            for itemCounter in 1...9 {
                let item = Item(context: viewContext)
                item.title = "Item \(itemCounter)"
                item.creationDate = Date()-81000000+(TimeInterval(itemCounter)*100000)
                item.completed = Bool.random()
                item.album = album
                item.resolvedAddress = "Address \(itemCounter)"
                item.latitude = 51.09326795-Double(itemCounter)
                item.longitude = 4.37288120-Double(itemCounter)

                let image = UIImage(named: "tomorrowland-\(itemCounter)")
                let imageData = image?.jpegData(compressionQuality: 0.5)
                item.mediaData = imageData

                item.priority = Int16.random(in: 1...3)
            }
        // }

        try viewContext.save()
    }
    
    func createQuestionnaireData() throws {
        let viewContext = container.viewContext
        let album = Album(context: viewContext)
        
        album.title = "Survey"
        album.detail = "Around the world"
        album.items = []
        album.creationDate = Date()
        
        let image = UIImage(named: surveyData.first!.mediaData)
        let imageData = image?.jpegData(compressionQuality: 0.8)
        album.coverImage = imageData
        album.closed = false
        
        for itemIndex in surveyData {
            let item = Item(context: viewContext)
            item.title = itemIndex.title
            item.creationDate = itemIndex.creationDate.toDate(.isoDate)
            item.album = album
            item.latitude = itemIndex.latitude
            item.longitude = itemIndex.longitude
            
            let image = UIImage(named: "\(itemIndex.mediaData)")
            let imageData = image?.jpegData(compressionQuality: 0.5)
            item.mediaData = imageData
        }
        try viewContext.save()
    }
    
    func createRandomQuestionnaire(imageObjectController: ImageObjectController) async throws {
        let viewContext = container.viewContext
        let album = Album(context: viewContext)
        
        album.title = "Best of 2022"
        album.detail = "Around the world"
        album.items = []
        album.creationDate = Date()
        let startDate = "2022-01-01 00:00:00 +0000"
        album.startDate = startDate.toDate(.localDate)
        print(Date())
        print(album.startDate)
        print(album.endDate)
        
        guard let url = URL(string: "https://picsum.photos/2000/3000") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data) ?? UIImage()
                let imageData = image.jpegData(compressionQuality: 0.5)
                album.coverImage = imageData
                album.closed = false
            }
        }
        task.resume()
        
        for _ in 0..<surveySize {
            let viewContext = container.viewContext
            let item = Item(context: viewContext)
            
            let result = await imageObjectController.asyncSearch()
            // let result = imageRequest[index]
            // _ = await fetchAPIResults(album: album, imageRequest: imageRequest, index: index)
            
            item.title = result.description
            print("Title: \(String(describing: result.description))")
            item.creationDate = result.created_at.toDate(.isoDateTimeSec)
            print("Creation Date from API: \(result.created_at)")
            print("Creation Date: \(String(describing: item.creationDate))")
            item.album = album
            // print("Album: \(String(describing: item.album))")
            print("URL: \(result.urls.full)")
            item.latitude = result.location?.position?.latitude ?? 0
            print("Latitude \(result.location?.position?.latitude ?? 0)")
            item.longitude = result.location?.position?.longitude ?? 0
            print("Longitude \(result.location?.position?.longitude ?? 0)")
            print("Index: \(String(describing: item.album?.itemsCount))")
            
            let image = await fetchImage(stringURL: result.urls.full)
            let imageData = image.jpegData(compressionQuality: 0.5)
            item.mediaData = imageData
            
            let resultFromClassification = await classifyImageWithAsync(image: image)
            item.classificationResult = resultFromClassification
            print("Classification Result: \(String(describing: item.classificationResult))")
            
            let soundResult = await callSoundAPI(classificationResult: item.classificationResult!)
            print(soundResult)
            
            if DownloadManager.shared.checkFileExists(fileName: item.classificationResult!) != true {
                await DownloadManager.shared.downloadFile(fileName: item.classificationResult!, soundURL: soundResult.results[0].previews.preview_lq_mp3)
            }
            
            try? viewContext.save()
        }
    }
    
    func callSoundAPI(classificationResult: String) async -> SoundList{
        soundObjectController.queryString = classificationResult.replacingOccurrences(of: " ", with: "%20")
        let apiSoundList = await soundObjectController.search()
        
        return apiSoundList
    }
    
    private func classifyImageWithAsync(image: UIImage) async -> String {
        
        // MARK: SquezeNet does need 227x227 pixels
        // let resizedImage = image.resizeImageTo(size:CGSize(width: 227, height: 227))
        
        // MARK: Resnet50 or MobileNetV2 need 224x224 pixels
        let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224))
        let buffer = resizedImage!.convertToBuffer()
        
        let output = try? model.prediction(image: buffer!)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            let result = results.prefix(predictsToShow).map { (key, value) in
                let formattedResultOfClassification = formatClassificationResultToStringForAPI(input: key)
                return formattedResultOfClassification[0]
                // self.resultFromClassification = formattedResultOfClassification[0]
                // return "\(key) = \(String(format: "%.2f", value * 100))%"
            }.joined(separator: "\n")
            
            return result
        }
        return ""
    }
    
    func formatClassificationResultToStringForAPI(input: String) -> [String] {
        var cutResults = input.components(separatedBy: CharacterSet(charactersIn: ","))
        
        for i in cutResults.indices {
            let str = cutResults[i].trimmingCharacters(in: .whitespacesAndNewlines)
            cutResults[i] = str
        }
        
        print(cutResults)
        return cutResults
    }
    
    private func buildURLRequest(stringURL: String) -> URLRequest {
        let url = URL(string: "\(stringURL)")!
        return URLRequest(url: url)
    }
    

    
    func fetchImage(stringURL: String) async -> UIImage {
        
        let request = buildURLRequest(stringURL: stringURL)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw fatalError()
            }
            
            let image = UIImage(data: data) ?? UIImage()
            return image
        }
        catch {
            return UIImage()
        }
    }

    /// Saves our Core Data context iff (only if) there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because our
    /// attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        // find me all items
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        // convert them to a delete request
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        // delete the request
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        // find me all albums
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Album.fetchRequest()
        // convert them to a delete request
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        // delete the request
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    // necessary to avoid problems with testing
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            // returns true if they added a certain numbers of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "complete":
            // returns true if they completed a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
            // an unknown award criterion; this should never be allowed
//          fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }

    }
}
