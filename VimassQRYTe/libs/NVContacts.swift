//
//  NVContacts.swift
//  NVContact
//
//  Created by Tâm Nguyễn on 11/11/16.
//  Copyright © 2016 Tâm Nguyễn. All rights reserved.
//
//https://developer.apple.com/reference/contacts
//http://stackoverflow.com/questions/26382625/sorting-contacts-based-on-recently-used-most-used-urgency-in-addressbook-ios
//https://www.appsfoundation.com/post/create-edit-contacts-with-ios-9-contacts-ui-framework
//https://github.com/ooper-shlab/MyContacts-Swift/blob/master/MyContacts/ViewController.swift
//http://stackoverflow.com/questions/29727618/find-duplicate-elements-in-array-using-swift
//https://www.safaribooksonline.com/library/view/ios-9-swift/9781491936689/ch04.html
//https://www.safaribooksonline.com/library/view/ios-9-swift/9781491936689/ch04.html

import Foundation
import Contacts

class NVContacts : NSObject {
    public static let KEY_DEM_COUNT_FREE = "KEY_DEM_COUNT_FREE"
    open var addressBookStore : CNContactStore! = CNContactStore()
    var arrDuplicateContact:[(key : String, value : [CNContact])]?
    var arrDuplicatePhone:[(key : String, value : [CNContact])]?
    var countContacts = 0
    var allFullContact:[CNContact]? = nil
    
    func requestContactsAccess(usingBlock block:@escaping(Bool) -> Void) {
        addressBookStore.requestAccess(for: .contacts, completionHandler: { (result, error) in
            block(result)
        })
    }

    func khoiTaoDuplicate() -> Void {
        let contacts = getFullNameContacts()
        self.countContacts = contacts.count
        arrDuplicateContact = getDuplicateName(contacts: contacts)
        arrDuplicatePhone = getDuplicatePhone(contacts: contacts)
        if (arrDuplicateContact?.count)! > 0 && (arrDuplicatePhone?.count)! > 0 {
            for index in 0..<(arrDuplicateContact?.count)! {
                let item = arrDuplicateContact?[index]
                if let indexFilter = arrDuplicatePhone?.index(where: { (c1) -> Bool in
                    return c1.key.lowercased() == item?.key.lowercased()
                }) {
                    arrDuplicatePhone?.remove(at: indexFilter)
                }
            }
        }
        
    }

    func allContactKey() -> [CNKeyDescriptor] {
        return [CNContactFormatter.descriptorForRequiredKeys(for: .fullName) as CNKeyDescriptor,
                CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactMiddleNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactPreviousFamilyNameKey as CNKeyDescriptor,
                CNContactNameSuffixKey as CNKeyDescriptor,
                CNContactNicknameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactDepartmentNameKey as CNKeyDescriptor,
                CNContactJobTitleKey as CNKeyDescriptor,
                CNContactPhoneticGivenNameKey as CNKeyDescriptor,
                CNContactPhoneticMiddleNameKey as CNKeyDescriptor,
                CNContactPhoneticFamilyNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactNonGregorianBirthdayKey as CNKeyDescriptor,
                CNContactNoteKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactTypeKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor,
                CNContactPostalAddressesKey as CNKeyDescriptor,
                CNContactDatesKey as CNKeyDescriptor,
                CNContactUrlAddressesKey as CNKeyDescriptor,
                CNContactRelationsKey as CNKeyDescriptor,
                CNContactSocialProfilesKey as CNKeyDescriptor,
                CNContactInstantMessageAddressesKey as CNKeyDescriptor,]
    }

    func getCountOfContactsOnAddressBook() -> Int {
        var nCount = 0;
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        do {
            try addressBookStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
                nCount += 1
            })
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        print("\(#function) - nCount: \(nCount)")
        return nCount
    }

    //MARK: - Groups

    func getGroups() -> [CNGroup]? {
        do {
            return try addressBookStore.groups(matching: nil)
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        return nil
    }

    func getGroups(identifier:[String]) -> [CNGroup]? {
        do {
            let predicate = CNGroup.predicateForGroups(withIdentifiers: identifier)
            return try addressBookStore.groups(matching: predicate)
        } catch let error {
            print("\(#function) - error : \(error.localizedDescription)")
        }

        return nil
    }

    func getContactsInGroup(groupID : String) -> [CNContact] {
//        print("\(#function) - id : \(groupID) - count : \(groupID)")
        var flContacts = [CNContact]()
        do {
            let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groupID)
            let contacts = try addressBookStore.unifiedContacts(matching: predicate, keysToFetch: allContactKey())
            flContacts.append(contentsOf: contacts)
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
//        print("\(#function) - id : \(groupID) - count : \(flContacts.count)")
        return flContacts
    }

    func getContactsNoGroups() -> [CNContact]? {
        let groups = getGroups()
        var allContacts = getFullNameContacts()
        print("\(#function) - allContacts : \(allContacts.count)")
        if groups != nil {
            print("\(#function) - groups : \(groups?.count)")
            for item in groups! {
                let contacts = getContactsInGroup(groupID: item.identifier)
                for c1 in contacts {
                    if let index = allContacts.index(where: {$0.identifier == c1.identifier}) {
                        print("\(#function) - ====> \(index)")
                        allContacts.remove(at: index)
                    }
                }
            }
        }
        print("\(#function) - allContacts : \(allContacts.count)")
        return allContacts
    }

    func createGroup(name : String) -> CNGroup? {
        let newGroup:CNMutableGroup = CNMutableGroup()
        newGroup.name = name
        let saveRequest:CNSaveRequest = CNSaveRequest()
        saveRequest.add(newGroup, toContainerWithIdentifier: nil)
        do {
            try addressBookStore.execute(saveRequest)
            print("newGroup : \(newGroup.identifier)")
            return newGroup.copy() as? CNGroup
        } catch  {

        }
        return nil
    }

    func addContactToGroup(contacts:[CNContact], group:CNGroup) -> CNGroup {
        let saveRequest = CNSaveRequest()
        for item in contacts {
            saveRequest.addMember(item, to: group)
        }
        do {
            try addressBookStore.execute(saveRequest)
        } catch  {

        }
        return group
    }

    func updateGroup(group : CNMutableGroup) -> CNGroup? {
        let saveRequest = CNSaveRequest()
        saveRequest.update(group)
        do {
            try addressBookStore.execute(saveRequest)
            return group.copy() as? CNGroup
        } catch  {

        }
        return nil
    }
    
    func updateContact(contact : CNMutableContact) -> CNContact? {
        let saveRequest = CNSaveRequest()
        saveRequest.update(contact)
        do {
            try addressBookStore.execute(saveRequest)
            return contact.copy() as! CNContact
        } catch  {
            
        }
        return nil
    }

    func  deleteGroup(group : CNGroup) -> Bool {
        let saveRequest = CNSaveRequest()
        saveRequest.delete(group.mutableCopy() as! CNMutableGroup)
        do {
            try addressBookStore.execute(saveRequest)
            return true
        } catch  {

        }
        return false
    }

    func deleteContactInGroup(contact:CNContact, group:CNGroup) -> Bool {
        let saveRequest:CNSaveRequest = CNSaveRequest()
        saveRequest.removeMember(contact, from: group)
        do {
            try addressBookStore.execute(saveRequest)
        } catch let er {
            print("\(#function) - er : \(er.localizedDescription)")
        }
        return false
    }

    //MARK: - Xu ly contact
    func getContactsWithKeys() -> [CNContact] {
        var flContacts = [CNContact]()
        let request = CNContactFetchRequest(keysToFetch: [CNContactFormatter.descriptorForRequiredKeys(for: .fullName) as CNKeyDescriptor])
        do {
            try addressBookStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
                if let _ = CNContactFormatter.string(from: contact, style: .fullName) {
                    flContacts.append(contact)
                }
            })
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
//        self.allFullContact = flContacts
        return flContacts
    }
    
    func getFullNameContacts() -> [CNContact] {
        var flContacts = [CNContact]()
        let request = CNContactFetchRequest(keysToFetch: allContactKey())
        do {
            try addressBookStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
                if let _ = CNContactFormatter.string(from: contact, style: .fullName) {
                    flContacts.append(contact)
                }
            })
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        self.allFullContact = flContacts
        return flContacts
    }

    func getAccountsOfContacts() -> [CNContainer]? {
        do {
            return try addressBookStore.containers(matching: nil)
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getContactsInContainer(container : CNContainer, keysToFetch : Array<Any>) -> [CNContact] {
        var results = [CNContact]()

        let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
        do {
            let containerResults = try addressBookStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
            results.append(contentsOf: containerResults)
        } catch {
            print("Error fetching results for container")
        }
        return results;
    }

    func getInfoContainer() -> [(key : String, value : [CNContact])]? {
        if let arrContainer = getAccountsOfContacts() {
            var groups : [String : [CNContact]] = [String : [CNContact]]()
            for item in arrContainer {
                var name = ""
                switch item.type {
                case .cardDAV:
                    name = "iCloud"
                    if item.name.isEmpty {
                        name = "Facebook"
                    }
                    break
                case .exchange:
                    name = "Exchange"
                    break
                case .local:
                    name = "Local"
                    break
                case .unassigned:
                    name = "Unknow"
                    break
                }
                let arrContacts = getContactsInContainer(container: item, keysToFetch: allContactKey())
                if arrContacts.count > 0 {
                    debugPrint("\(#function) - name : \(name) - arrContacts.count : \(arrContacts.count)")
                    groups[name] = arrContacts
                }
            }
            let temp = groups.sorted(by: { (c1, c2) -> Bool in
                return true
            })
            return temp
        }
        return nil
    }

    func getNoNameContacts() -> [CNContact] {
        var flContacts = [CNContact]()
        do {
            let request = CNContactFetchRequest(keysToFetch: allContactKey())
            try addressBookStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
                let fullName = CNContactFormatter.string(from: contact, style: .fullName)
                if (fullName == nil) {
                    flContacts.append(contact)
//                    print("\(#function) : identifier : \(contact.identifier)")
                    
                }
            })
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        return flContacts
    }

    func getNoPhoneNumbers() -> [CNContact] {
        var flContacts = [CNContact]()
        let request = CNContactFetchRequest(keysToFetch: allContactKey())
        do {
            try addressBookStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
                let numbers:Array = contact.phoneNumbers
                if numbers.count == 0 {
                    flContacts.append(contact)
                }
            })
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        return flContacts
    }

    func getNoEmails() -> [CNContact] {
        var flContacts = [CNContact]()
//        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: allContactKey())
        do {
            try addressBookStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
                let numbers = contact.emailAddresses.count
                let numbersPhone = contact.phoneNumbers.count
                if numbers == 0, numbersPhone == 0 {
                    flContacts.append(contact)
                }
            })
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        return flContacts
    }

    func getCompanyOfContact() -> [(key : String, value : [CNContact])]? {
        var flContacts = [CNContact]()
        let request = CNContactFetchRequest(keysToFetch: allContactKey())
        do {
            try addressBookStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
                let company = contact.organizationName
                if company.count > 0 {
                    flContacts.append(contact)
                }
            })
            
            var groups : [String : [CNContact]] = [String : [CNContact]]()
            for item in flContacts {
                var contacts = [CNContact]()
                if let segregatedContact = groups[item.organizationName] {
                    contacts = segregatedContact
                }
                contacts.append(item)
                groups[item.organizationName] = contacts
            }
            let temp = groups.sorted(by: { (c1, c2) -> Bool in
                return c1.key <= c2.key
            })
            return temp
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        return nil
    }

    func getJobTitleOfContact() -> [(key : String, value : [CNContact])]? {
        var flContacts = [CNContact]()
        let request = CNContactFetchRequest(keysToFetch: allContactKey())
        do {
            try addressBookStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
                let company = contact.jobTitle
                if company.count > 0 {
                    flContacts.append(contact)
                }
            })
            var groups : [String : [CNContact]] = [String : [CNContact]]()
            for item in flContacts {
                var contacts = [CNContact]()
                if let segregatedContact = groups[item.jobTitle] {
                    contacts = segregatedContact
                }
                contacts.append(item)
                groups[item.jobTitle] = contacts
            }
            let temp = groups.sorted(by: { (c1, c2) -> Bool in
                return c1.key <= c2.key
            })
            return temp
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        return nil
    }

    func getInfoOfContact(contactID : String, keysToFetch : Array<Any>) -> CNContact? {
        do {
            return try addressBookStore.unifiedContact(withIdentifier: contactID, keysToFetch: keysToFetch as! [CNKeyDescriptor])
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        return nil
    }

    func  getAllInfoContact(contactID : String, keysToFetch : CNKeyDescriptor) -> CNContact? {
        do {
            return try addressBookStore.unifiedContact(withIdentifier: contactID, keysToFetch: [keysToFetch])
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func searchContactWithKeyword(keyword : String, arrContacts:[CNContact]) -> [CNContact] {
        var results = [CNContact]()
        for contact in arrContacts {
            var sTuThayThe = ""
            if contact.phoneNumbers.count > 0 {
                let phoneNumber = contact.phoneNumbers[0].value 
                sTuThayThe = phoneNumber.value(forKey: "digits") as! String
            }
            else if contact.emailAddresses.count > 0{
                let emailItem = contact.emailAddresses[0].label
                sTuThayThe = emailItem!
            }
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? sTuThayThe
            if fullName.contains(keyword) {
                results.append(contact)
            }
        }
        return results
    }
    
    func getRecentlyContactAdded() -> Void {
        var flContacts = [CNContact]()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactDatesKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        do {
            try addressBookStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
                if contact.isKeyAvailable(CNContactDatesKey) {
                    flContacts.append(contact)
                }
            })
            print("\(#function) - flContacts : \(flContacts.count)")
            for item in flContacts {
                if item.isKeyAvailable(CNContactDatesKey) {
                    print("\(#function) - date : \(item.dates.count)")
                    for date in item.dates {
                        print("\(#function) - date : \(date)")
                    }
                }
            }
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }

    }
    
    func getContactsWithBirthday() -> [(key : String, value : [CNContact])]? {
        var flContacts = [CNContact]()
        let request = CNContactFetchRequest(keysToFetch: allContactKey())
        do {
            try addressBookStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
                if contact.birthday != nil {
                    flContacts.append(contact)
                }
            })
            var groups : [String : [CNContact]] = [String : [CNContact]]()
            for item in flContacts {
                var contacts = [CNContact]()
                
                let key = "\(String(format: "%02d", item.birthday?.day ?? 0))/\(String(format: "%02d", item.birthday?.month ?? 0))"
//                print("\(#function) - key : \(key)")
                if let segregatedContact = groups[key] {
                    contacts = segregatedContact
                }
                contacts.append(item)
                groups[key] = contacts
            }
            let temp = groups.sorted(by: { (c1, c2) -> Bool in
                let arrC1 = c1.key.components(separatedBy: "/")
                let arrC2 = c2.key.components(separatedBy: "/")
                if Int(arrC1[1]) == Int(arrC2[1]) {
                    return Int(arrC1[0])! <= Int(arrC2[0])!
                }
                else {
                    return Int(arrC1[1])! < Int(arrC2[1])!
                }
            })
            return temp
        } catch let error {
            print("\(#function) - error: \(error.localizedDescription)")
        }
        return nil
    }

    func xoaMaVungDienThoai(phoneNumber : String) -> String {
        var numbers = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if numbers.contains("+84") {
            numbers = numbers.replacingOccurrences(of: "+84", with: "0")
        }
        numbers = numbers.trimmingCharacters(in: CharacterSet.whitespaces)
        return numbers
    }

    //MARK: Duplicate

    func getDuplicateName(contacts : [CNContact]) -> [(key : String, value : [CNContact])]? {
        var groups = [String : [CNContact]]()

        for index1 in 0..<contacts.count {
            let contact1 = contacts[index1]
            let fullName = CNContactFormatter.string(from: contact1, style: .fullName)
            if fullName != nil {
                if !groups.keys.contains(fullName!) {
                    let arrContactSplit = contacts[(index1+1)..<contacts.count]
                    var temps = arrContactSplit.filter({ (temp) -> Bool in
                        let fullName2 = CNContactFormatter.string(from: temp, style: .fullName)
                        return fullName == fullName2
                    })
                    if temps.count > 0 {
                        let arrValue = groups[fullName!]
                        if arrValue == nil || arrValue?.count == 0 {
//                            print("\(#function) - temps.count : \(temps.count) - fullName : \(fullName)")
                            temps.insert(contact1, at: 0)
//                            print("\(#function) ===> temps.count : \(temps.count) - fullName : \(fullName)")
                            groups[fullName!] = temps
                        }
                    }
                }
            }
        }
        let arrpSort = groups.sorted(by: { (c1, c2) -> Bool in
            return c1.key.lowercased() <= c2.key.lowercased()
        })
        return arrpSort
    }

    func getDuplicatePhone(contacts : [CNContact]) -> [(key : String, value : [CNContact])]? {
        var groups = [String : [CNContact]]()
        for index1 in 0..<contacts.count {
            let contact = contacts[index1]
            let fullName = CNContactFormatter.string(from: contact, style: .fullName)
            if fullName != nil {
                var bCheck = false
                for item in groups {
                    for itemContact in item.value {
                        if itemContact.identifier == contact.identifier {
                            bCheck = true
                            break
                        }
                    }
                    if bCheck {
                        break
                    }
                }
                if !bCheck {
                    let arrContactSplit = contacts[(index1+1)..<contacts.count]
                    var temps = arrContactSplit.filter({ (temp) -> Bool in
                        let fullName2 = CNContactFormatter.string(from: temp, style: .fullName)
                        var bTimThay = false
                        for phoneNumber1 in contact.phoneNumbers {
                            let phone1 = xoaMaVungDienThoai(phoneNumber: phoneNumber1.value.stringValue)
                            for phoneNumber2 in temp.phoneNumbers {
                                let phone2 = xoaMaVungDienThoai(phoneNumber: phoneNumber2.value.stringValue)
                                if phone1 == phone2 && fullName?.lowercased() != fullName2?.lowercased() {
                                    print("\(#function) - name1 : \(fullName) - name2 : \(fullName2)")
                                    bTimThay = true
                                    break
                                }
                            }
                            if bTimThay {
                                break
                            }
                        }
                        return bTimThay
                    })
                    if temps.count > 0 {
                        let arrValue = groups[fullName!]
                        if arrValue == nil || arrValue?.count == 0 {
                            temps.insert(contact, at: 0)
                            groups[fullName!] = temps
                        }
                    }
                    }
            }
        }
        let arrpSort = groups.sorted(by: { (c1, c2) -> Bool in
            return c1.key.lowercased() <= c2.key.lowercased()
        })
        return arrpSort
    }

    //MARK: MERGE
    func mergeContacts(contacts : [CNContact]) -> CNMutableContact? {
        if contacts.count > 0 {
            let contact = CNMutableContact()
            let contactTemp = contacts[0]
            contact.givenName = contactTemp.givenName
            contact.namePrefix = contactTemp.namePrefix
            contact.middleName = contactTemp.middleName
            contact.familyName = contactTemp.familyName
            contact.previousFamilyName = contactTemp.previousFamilyName
            contact.nameSuffix = contactTemp.nameSuffix
            contact.nickname = contactTemp.nickname
            for item in contacts {
                if contact.organizationName.isEmpty, !item.organizationName.isEmpty {
                    contact.organizationName = item.organizationName
                }
                if contact.departmentName.isEmpty, !item.departmentName.isEmpty {
                    contact.departmentName = item.departmentName
                }
                if contact.jobTitle.isEmpty, !item.jobTitle.isEmpty {
                    contact.jobTitle = item.jobTitle
                }
                if contact.phoneticGivenName.isEmpty, !item.phoneticGivenName.isEmpty {
                    contact.phoneticGivenName = item.phoneticGivenName
                }
                if contact.phoneticMiddleName.isEmpty, !item.phoneticMiddleName.isEmpty {
                    contact.phoneticMiddleName = item.phoneticMiddleName
                }
                if contact.phoneticFamilyName.isEmpty, !item.phoneticFamilyName.isEmpty {
                    contact.phoneticFamilyName = item.phoneticFamilyName
                }
                if !item.note.isEmpty {
                    var note = contact.note
                    if note.isEmpty {
                        note = item.note
                    }
                    else {
                        note += "|\(item.note)"
                    }
                    contact.note = note
                }
                if (contact.imageData == nil),let imageData = item.imageData {
                    contact.imageData = imageData
                }
                var arrPhone = contact.phoneNumbers
                for phoneItem in item.phoneNumbers {
                    print("\(#function) - phoneItem : \(phoneItem)")
                    let phone1 = xoaMaVungDienThoai(phoneNumber: phoneItem.value.stringValue)
                    var bTimThay = false
                    for phoneContact in arrPhone {
                        let phone2 = xoaMaVungDienThoai(phoneNumber: phoneContact.value.stringValue)
                        if phone1 == phone2 {
                            bTimThay = true
                            break
                        }
                        
                    }
                    if !bTimThay {
                        let homePhone_1 = CNLabeledValue(label: phoneItem.label ?? CNLabelOther,
                                                         value: CNPhoneNumber(stringValue: phoneItem.value.stringValue))
                        arrPhone.append(homePhone_1)
                    }
                }
                print("\(#function) - arrPhone : \(arrPhone)")
//                let homePhone_1 = CNLabeledValue(label: CNLabelHome,
//                                                 value: CNPhoneNumber(stringValue: "123456789"))
                contact.phoneNumbers = arrPhone
                print("\(#function) - contact.phoneNumbers : \(contact.phoneNumbers)")
                var arrEmail = contact.emailAddresses
                for mailItem in item.emailAddresses {
                    let mailTemp1 = mailItem.value
                    var bTimThay = false
                    
                    for mail in arrEmail {
                        let mailTemp2 = mail.value
                        if mailTemp1 == mailTemp2 {
                            bTimThay = true
                            break
                        }
                    }
                    if !bTimThay {
                        let homePhone_1 = CNLabeledValue(label: mailItem.label ?? CNLabelOther,
                                                         value: mailItem.value)
                        arrEmail.append(homePhone_1)
                    }
                }
                contact.emailAddresses = arrEmail
                
                var postalAddresses = contact.postalAddresses
                for postItem in item.postalAddresses {
                    let item1 = postItem.value
                    var bTimThay = false
                    for postContact in postalAddresses {
                        let item2 = postContact.value
                        if item1.street == item2.street, item1.city == item2.city {
                            bTimThay = true
                            break
                        }
                    }
                    if !bTimThay {
                        let postal = CNMutablePostalAddress()
                        postal.street = postItem.value.street
                        postal.city = postItem.value.city
                        postal.state = postItem.value.state
                        postal.postalCode = postItem.value.postalCode
                        postalAddresses.append(CNLabeledValue(label: postItem.label ?? CNLabelOther, value: postal))
                    }
                }
                contact.postalAddresses = postalAddresses
                
//                open var urlAddresses: [CNLabeledValue<NSString>]
//                
//                open var contactRelations: [CNLabeledValue<CNContactRelation>]
//                
//                open var socialProfiles: [CNLabeledValue<CNSocialProfile>]
//                
//                open var instantMessageAddresses: [CNLabeledValue<CNInstantMessageAddress>]
                var urlAddresses = contact.urlAddresses
                for mailItem in item.urlAddresses {
                    let mailTemp1 = mailItem.value
                    var bTimThay = false
                    
                    for mail in urlAddresses {
                        let mailTemp2 = mail.value
                        if mailTemp1 == mailTemp2 {
                            bTimThay = true
                            break
                        }
                    }
                    if !bTimThay {
                        let homePhone_1 = CNLabeledValue(label: mailItem.label ?? CNLabelOther,
                                                         value: mailItem.value)
                        urlAddresses.append(homePhone_1)
                    }
                }
                contact.urlAddresses = urlAddresses
                
                var socialProfiles = contact.socialProfiles
                for mailItem in item.socialProfiles {
                    let mailTemp1 = mailItem.value
                    var bTimThay = false
                    
                    for mail in socialProfiles {
                        let mailTemp2 = mail.value
                        if mailTemp1.userIdentifier == mailTemp2.userIdentifier {
                            bTimThay = true
                            break
                        }
                    }
                    if !bTimThay {
                        let social = CNLabeledValue(label: mailItem.label ?? CNLabelOther, value: CNSocialProfile(urlString: mailTemp1.urlString, username: mailTemp1.username, userIdentifier: mailTemp1.userIdentifier, service: mailTemp1.service))
                        socialProfiles.append(social)
                    }
                }
                contact.urlAddresses = urlAddresses

                var instant = contact.instantMessageAddresses
                for instantItem in item.instantMessageAddresses {
                    let isValue1 = instantItem.value
                    var bTimThay = false
                    for isItem in instant {
                        let isValue2 = isItem.value
                        if (isValue1.username == isValue2.username) && (isValue1.service == isValue2.service) {
                            bTimThay = true
                            break
                        }
                    }
                    if !bTimThay {
                        let it = CNLabeledValue(label: instantItem.label ?? CNLabelOther, value: CNInstantMessageAddress(username: isValue1.username, service: isValue1.service))
                        instant.append(it)
                    }
                }
                contact.instantMessageAddresses = instant

                var dates = contact.dates
                for datesItem in item.dates {
                    let dtValue1 = datesItem.value
                    var bTimThay = false
                    for dt in dates {
                        let dtValue2 = dt.value
                        if dtValue1 == dtValue2 {
                            bTimThay = true
                            break
                        }
                    }
                    if !bTimThay {
                        let dt = CNLabeledValue(label: datesItem.label ?? CNLabelDateAnniversary, value: dtValue1)
                        dates.append(dt)
                    }
                }
                contact.dates = dates


                var date = contact.birthday
                if (item.birthday != nil) && (date == nil) {
                    date = item.birthday
                }
                contact.birthday = date
            }
            return contact
        }
        return nil
    }

    //MARK: - Create and delete contact
    func createNewContact(contact:CNMutableContact) -> Bool {
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        do {
            try addressBookStore.execute(saveRequest)
            return true
        } catch  {
            print("NVContacts : \(#function) - error : \(error)")
        }
        return false
    }

    func  deleteContact(contact : CNContact) -> Bool {
        let saveRequest = CNSaveRequest()
        saveRequest.delete(contact.mutableCopy() as! CNMutableContact)
        do {
            try addressBookStore.execute(saveRequest)
            return true
        } catch  {

        }
        return false
    }

    //MARK: - Backup
    func backupContactToVCF(pathFile:String, contacts:[CNContact]) -> Void {
        do {
            let data = try CNContactVCardSerialization.data(with: contacts)
            try data.write(to: URL(string: pathFile)!, options: .atomicWrite)

        } catch let error {
            print("\(#function) - error : \(error.localizedDescription)")
        }
    }
}







