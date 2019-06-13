//
//  Question+CoreDataProperties.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 12/06/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var answers: [String]
    @NSManaged public var correctAnswer: Int32
    @NSManaged public var id: Int32
    @NSManaged public var question: String

}
