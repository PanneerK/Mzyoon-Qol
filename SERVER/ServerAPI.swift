//
//  LoginViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import Foundation
import UIKit
import AlamofireDomain
import Reachability

class ServerAPI : NSObject
{
    
    var delegate: ServerAPIDelegate?
    
    var resultDict:NSDictionary = NSDictionary()
    
  //  var baseURL:String = "http://192.168.0.21/TailorAPI"
    
    var baseURL:String = "http://appsapi.mzyoon.com"
 
    let deviceId = UIDevice.current.identifierForVendor
    
    func API_LoginUser(CountryCode : String, PhoneNo : String, delegate:ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Login Page")
            
            let parameters = ["CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "DeviceId" : "\(String(describing: deviceId!))"] as [String : Any]
            
            print("LOGIN PARAMETERS", parameters)
            
            let urlString:String = String(format: "%@/API/Login/GenerateOTP", arguments: [baseURL])
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_Login!(loginResult: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 1, errorMessage: "Login Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_ValidateOTP(CountryCode : String, PhoneNo : String, otp : String, type : String, delegate:ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Validate OTP Page")
            
            let parameters = ["CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "DeviceId" : "\(deviceId!)", "OTP" : otp, "Type" : type] as [String : Any]
            
            print("LOGIN PARAMETERS", parameters)
            
            let urlString:String = String(format: "%@/API/Login/ValidateOTP", arguments: [baseURL])
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_ValidateOTP!(loginResult: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 1, errorMessage: "Validate OTP Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_CountryCode(delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Country Code Page")
            
            let parameters = [:] as [String : Any]
            
            
            let urlString:String = String(format: "%@/API/login/getallcountries", arguments: [baseURL])
            
            print("URL COUNRTY", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_CountryCode!(countryCodes: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 2, errorMessage: "Country Code Failed")
                }
                
                
            }
            
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_FlagImages(imageName : String, delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Flag Images Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/images/flags/\(imageName)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_FlagImages!(flagImages: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 3, errorMessage: "Flag Images Failed")
                }
            }
            
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Gender(delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Gender Page")
            
            let parameters = [:] as [String : Any]
            
            
            let urlString:String = String(format: "%@/API/Order/GetGenders", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_Gender!(gender: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 4, errorMessage: "Genders Failed")
                }
            }
            
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_GenderImage(imageName : String, delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Gender Image Page")
            
            let parameters = [:] as [String : Any]
            
            
            let urlString:String = String(format: "%@/images/\(imageName)", arguments: [baseURL])
            
            /*request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
             
             if response.result.value != nil
             {
             self.resultDict = response.result.value as! NSDictionary // method in apidelegate
             delegate.API_CALLBACK_GenderImage!(genderImage: self.resultDict)
             }
             else
             {
             delegate.API_CALLBACK_Error(errorNumber: 4, errorMessage: "Genders Image Failed")
             }
             }*/
            
            request(urlString).responseData { (response) in
                if response.data != nil {
                    print(response.result)
                    // Show the downloaded image:
                    if let data = response.data {
                        delegate.API_CALLBACK_GenderImage!(genderImage: data)
                    }
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_DressType(genderId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Dress Type Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetDressTypeByGender?genderId=\(genderId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_DressType!(dressType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Dress Type Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    class Customization: NSObject {
        
        var Id: Int?
        
        init(Id: Int) {
            self.Id = Id
        }
        
        func getDictFormat() -> [String: Int]{
            return ["Id" : Id!]
        }
    }
    
    func MakeRequest(season : [Int], origin : [Int]) -> ([String : Any])
    {
        var array = [Customization]()
        
        for i in 0..<origin.count
        {
            array.append(Customization(Id: origin[i]))
        }
        
//        array.append(Customization(Id: 1))
//
//        array.append(Customization(Id: 2))
        
        var List = [[String: Int]]()
        
        for item in array {
            
            List.append(item.getDictFormat())
            
        }
    
        var array1 = [Customization]()
        
//        array1.append(Customization(Id: 0))
        
        for i in 0..<season.count
        {
            array1.append(Customization(Id: season[i]))
        }
        
        
        var List1 = [[String: Int]]()
        
        for item in array1 {
            
            List1.append(item.getDictFormat())
            
        }
        
        let parameters = [
            
            "SeasonId": List1,
            
            "PlaceofOrginId": List
            
            ] as [String : Any]
        
        
        print("PARAMETERS OF SUPER", parameters)
        
        return parameters
    }
    
    func API_Customization1(originId : [[String: Int]], seasonId : [[String: Int]], delegate : ServerAPIDelegate)
    {
        print("IN FIRST STEP", originId)
        print("IN SECOND STEP", seasonId)

        var season = String()
        var origin = String()
        
        var convertedSeason = String()
        var convertedOrigin = String()
        
        for i in 0..<originId.count
        {
            if i == 0
            {
                origin.append("\(originId[i])")
            }
            else
            {
                origin.append(",\(originId[i])")
            }
        }
        
        for i in 0..<seasonId.count
        {
            if i == 0
            {
                season.append("\(seasonId[i])")
            }
            else
            {
                season.append(",\(seasonId[i])")
            }
        }
        
        print("DICT NEW", origin)
        print("DICT NEW SEASON", season)

                
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Customization 1 Page")
            
            let parameters = ["PlaceofOrginId" : originId, "seasonId" : seasonId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomization1", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    print("SELF RESULT DICT", self.resultDict)
                    
                    delegate.API_CALLBACK_Customization1!(custom1: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Customization 1 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Customization2(brandId : [[String: Int]], materialId : [[String: Int]], ColorId : [[String: Int]], delegate : ServerAPIDelegate)
    {
        var materials = String()
        var colors = String()
        
        for i in 0..<materialId.count
        {
            if i == 0
            {
                materials.append("\(materialId[i])")
            }
            else
            {
                materials.append(",\(materialId[i])")
            }
        }
        
        for i in 0..<ColorId.count
        {
            if i == 0
            {
                colors.append("\(ColorId[i])")
            }
            else
            {
                colors.append(",\(ColorId[i])")
            }
        }
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Customization 2 Page")
            
            let parameters = ["BrandId" : brandId, "MaterialTypeId" : materialId, "ColorId" : ColorId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomization2", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_Customization2!(custom2: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Customization 2 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Profile(delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Customization 1 Page")
            
            let parameters = ["Tailorid" : "6", "ShopNameInEnglish" : "Test English", "ShopNameInArabic" : "Test Arabic",  "CountryId" : "1",  "CityId" : "1",  "Latitude" : "13.005412",  "Longitude" : "80.021254",  "AddressInEnglish" : "Address English",  "AddressinArabic" : "Address Arabic",  "ShopOwnerImageURL" : "albert.png",] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/InsertUpdateShopProfile", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_Profile!(profile: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Customization 1 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_OrderType(delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - OrderType Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/DisplayOrderType", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_OrderType!(orderType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 10, errorMessage: "Order Type Failed")
                }
            }
            
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Measurement1(delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Measurement1 Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/DisplayMeasurement1", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_Measurement1!(measure1: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 13, errorMessage: "Measurement1 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Customization3(DressTypeId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Customization 3 Page")
            
            let parameters = ["DressTypeId" : "\(DressTypeId)"] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomization3", arguments: [baseURL])
            
            print("Custom 3", urlString)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_Customization3!(custom3: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 14, errorMessage: "Customization 3 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_Customization3Attr(AttributeId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Dress Type Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetAttributesByAttributeId?AttributeId=\(AttributeId)", arguments: [baseURL])
            
            print("ATTRIBUTES WITH IMAGE ID", urlString)
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_Customization3Attr!(custom3Attr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 14, errorMessage: "Customization 3 Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_IntroProfile(Id : String, Name : String, profilePic : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Intro Profile Page")
            
            let parameters = ["Id" : Id, "Name" : Name, "ProfilePicture" : profilePic] as [String : Any]
            
            let urlString:String = String(format: "%@/Api/Shop/InsertBuyerName", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_IntroProfile!(introProf:self.resultDict )
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 11, errorMessage: "Intro Profile Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_ExistingUserProfile(Id : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Existing User Profile Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/Api/Order/GetExistingUserProfile?Id=\(Id)", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_ExistingUserProfile!(userProfile: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 11, errorMessage: "Existing User Profile Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Profile Update
    func API_ProfileUpdate(Id : String, Email : String, Dob : String, Gender : String, ModifiedBy : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Intro Profile Page")
            
            let parameters = ["Id" : Id, "Email" : Email, "Dob" : Dob, "Gender" : Gender, "ModifiedBy" : ModifiedBy] as [String : Any]
            
            let urlString:String = String(format: "%@/Api/Shop/InsertBuyerDetails", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_ProfileUpdate!(profUpdate: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 12, errorMessage: "Profile Update Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Insert Buyer Address..
    func API_InsertAddress(BuyerId : String, FirstName : String, LastName : String, CountryId : Int, StateId : Int, Area : String, Floor : String, LandMark : String, LocationType : String, ShippingNotes : String, IsDefault : String, CountryCode : String, PhoneNo : String, Longitude : Float, Latitude : Float, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Address Page")
            
            let parameters = ["BuyerId" : "\(BuyerId)", "FirstName" : "\(FirstName)", "LastName" : LastName, "CountryId" : CountryId, "StateId" : StateId, "Area" : Area, "Floor" : Floor, "LandMark" : LandMark, "LocationType" : LocationType, "ShippingNotes" : ShippingNotes, "IsDefault" : IsDefault, "CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "Longitude" : Longitude, "Lattitude" : Latitude] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/InsertBuyerAddress", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertAddress!(insertAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Save Address Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Update Buyer Address..
    func API_UpdateAddress(Id : Int ,BuyerId : String, FirstName : String, LastName : String, CountryId : Int, StateId : Int, Area : String, Floor : String, LandMark : String, LocationType : String, ShippingNotes : String, IsDefault : String, CountryCode : String, PhoneNo : String, Longitude : Float, Latitude : Float, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Address Page")
            
            let parameters = ["Id" : Id, "BuyerId" : BuyerId, "FirstName" : FirstName, "LastName" : LastName, "CountryId" : CountryId, "StateId" : StateId, "Area" : Area, "Floor" : Floor, "LandMark" : LandMark, "LocationType" : LocationType, "ShippingNotes" : ShippingNotes, "IsDefault" : IsDefault, "CountryCode" : CountryCode, "PhoneNo" : PhoneNo, "Longitude" : Longitude, "Lattitude" : Latitude] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/UpdateBuyerAddress", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    print("UPDATE RESPONSE", self.resultDict)
                    delegate.API_CALLBACK_UpdateAddress!(updateAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Address Update Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //Delete Buyer Address..
    func API_DeleteAddress(AddressId : Int, userId : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Address Page")
            
            let parameters = [:] as [String : Any]

            let urlString:String = String(format: "%@/API/Shop/DeleteBuyerAddress?BuyerId=\(userId)&Id=\(AddressId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_DeleteAddress!(deleteAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Address Delete Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //GEt Buyer Address..
    func API_GetBuyerAddress(BuyerAddressId : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Address Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Shop/GetBuyerAddressByBuyerId?BuyerId=\(BuyerAddressId)", arguments: [baseURL])
            
            print("URL STRING", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_GetBuyerAddress!(getBuyerAddr: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Get Buyer Address Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //Dress Sub-type..
    func API_DressSubType(DressSubTypeId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Dress SubType")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/DisplayDressSubType?Id=\(DressSubTypeId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", urlString)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_DressSubType!(dressSubType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Dress SubType Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Measurement-2 full body pics...
    func API_GetMeasurement1(Measurement1Value : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Measurement2 Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetMeasurement2?Id=\(Measurement1Value)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_GetMeasurement1Value!(GetMeasurement1val: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Get Measurement-1 Value Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Measurement-1 Manually list show of existing user..
    func API_ExistingUserMeasurement(DressTypeId : String, UserId : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Existing User Measurement Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetExistingUserMeasurement?DressTypeId=\(DressTypeId)&UserId=\(UserId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    
                    delegate.API_CALLBACK_ExistingUserMeasurement!(getExistUserMeasurement: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Profile User Type Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Measurement-2 Parts after selection..
    func API_GetMeasurementParts(MeasurementParts : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Measurement Parts Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetMeasurementParts?Id=\(MeasurementParts)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", urlString)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_GetMeasurementParts!(getParts: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Get Measurement parts Value Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Measurement-2 Parts Tab..
    func API_GetMeasurement2(Measurement2Value : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Measurement2 Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/DisplayMeasurementBySubTypeId?Id=\(Measurement2Value)", arguments: [baseURL])
            
            print("MEASUREMENT", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_GetMeasurement2Value!(GetMeasurement2val: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Get Measurement-2 Value Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Profile User Type..
    func API_IsProfileUserType(UserType : String , UserId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Profile User Type")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Login/IsProfileCreated?UserType=\(UserType)&Id=\(UserId)", arguments: [baseURL])
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_ProfileUserType!(userType: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Profile User Type Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Mesurement-2 values Insert..
    func API_InsertUserMeasurementValues(UserId : Int, DressTypeId : Int, MeasurementValueId : [Int], MeasurementValue : [Int], MeasurementBy : String, CreatedBy : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Measurement Values Page")
            
            let parameters = ["UserId" : UserId, "DressTypeId" : DressTypeId, "MeasurementValue[0][MeasurementId]" : "\(MeasurementValueId)", "MeasurementValue[0][Value]" : "\(MeasurementValue)", "MeasurementBy" : MeasurementBy, "CreatedBy" : CreatedBy] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertUserMeasurementValues", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertUserMeasurement!(insUsrMeasurementVal: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "User Measurement Values Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //Device Details..
    func API_InsertDeviceDetails(DeviceId : String, Os : String, Manufacturer : String, CountryCode : String, PhoneNumber : String, Model : String, AppVersion : String, Type : String,delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            let parameters = ["DeviceId" : DeviceId, "Os" : Os, "Manufacturer" : Manufacturer, "CountryCode" : CountryCode, "PhoneNumber" : PhoneNumber, "Model" : Model, "AppVersion" : AppVersion, "Type" : Type] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Login/InsertUpdateDeviceDetails", arguments: [baseURL])
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_DeviceDetails!(deviceDet: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Insert Device Details Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Image Upload.. profile
    func API_ProfileImageUpload(buyerImages : UIImage, delegate : ServerAPIDelegate)
    {
        let date = Date().timeIntervalSince1970
        print("DATE", date)
        
        let dateInt = Int(date)
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Image Upload Page")
            
            let parameters = ["BuyerImages" : buyerImages] as [String : UIImage]
            
            let urlString:String = String(format: "%@/API/FileUpload/UploadFile", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                "Content-type": "multipart/form-data",
                "Accept":"*/*"
            ]
            
            upload(multipartFormData: {(multipartFormData:MultipartFormData) in
                for (key,value) in parameters
                {
                    multipartFormData.append(value.jpegData(compressionQuality: 0.5)!, withName: key, fileName: "Profile_\(dateInt).png", mimeType: "image/jpeg")
                };
                
            }, usingThreshold: UInt64.init(), to:  urlString, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult
                {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        print("SUCCESS IMAGE", response)
                        
                        if response.result.value != nil{
                            self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                            delegate.API_CALLBACK_ProfileImageUpload!(ImageUpload: self.resultDict)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    print("FAILURE IMAGE", encodingError)
                    delegate.API_CALLBACK_Error(errorNumber: 13, errorMessage: "Image Upload Page Failed")
                }
            })
        }
        else
        {
            print("no internet")
        }
    }
    
    // Tailor List View..
    func API_GetTailorList(delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Tailor List Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTailorlist", arguments: [baseURL])
            
            print("URL STRING FOR Tailor List", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_GetTailorList!(TailorList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 13, errorMessage: "Tailor List Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Device error...
    func API_InsertErrorDevice(DeviceId : String, PageName : String, MethodName : String, Error : String, ApiVersion : String, Type : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            let parameters = ["DeviceId" : DeviceId, "PageName" : PageName, "MethodName" : MethodName, "Error" : Error, "ApiVersion" : ApiVersion, "Type" : Type] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Login/InsertError", arguments: [baseURL])
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertErrorDevice!(deviceError: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Insert Error Device Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    
    // Order Summary... 19/12/2018..
    func API_InsertOrderSummary(dressType : Int, CustomerId : Int, AddressId : Int, PatternId : Int, Ordertype : Int, MeasurementId : Int, MaterialImage : [UIImage], ReferenceImage : [UIImage], OrderCustomization : [[String : Any]], TailorId : [Int], MeasurementBy : String, CreatedBy : Int, MeasurementName : String, UserMeasurement : [[String : Any]], DeliveryTypeId : Int, units : String, measurementType : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Order Summary Page")
            
            let parameters = ["dressType" : dressType, "CustomerId" : CustomerId, "AddressId" : AddressId, "PatternId" : PatternId, "Ordertype" : Ordertype, "MeasurementId" : MeasurementId, "MaterialImage[0][Image]" : "\(MaterialImage)", "ReferenceImage[0][Image]" : "\(ReferenceImage)" , "OrderCustomization" : OrderCustomization, "TailorId[0][Id]" : "\(TailorId)", "MeasurementBy" : MeasurementBy, "CreatedBy" : CreatedBy, "MeasurementName" : MeasurementName, "UserMeasurement" : UserMeasurement, "DeliveryTypeId" : DeliveryTypeId, "Units" : units, "MeasurementType" : measurementType] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertOrder", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertOrderSummary!(insertOrder: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Insert Order Summary Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_GetStateListByCountry(countryId : String, delegate : ServerAPIDelegate)
    {
        
        if (Reachability()?.isReachable)!
        {
            
            print("Server Reached - State List Page")
            
            let parameters = ["Id" : countryId] as [String : Any]
            
            let urlString:String = String(format: "%@/api/Shop/DisplayStatebyCountry", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_GetStateListByCountry!(stateList: self.resultDict)
                    print("response", self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "State List Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Order Approval .. 21/12/2018..
    func API_OrderApprovalPrice(TailorResponseId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached -  Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTailorResponseList?TailorResponseId=\(TailorResponseId)", arguments: [baseURL])
            
            print("Order Approval Pricing: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_OrderApprovalPrice!(orderApprovalPrice: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Order Approval Pricing Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_OrderApprovalDelivery(TailorResponseId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached -  Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTailorResponseList2?TailorResponseId=\(TailorResponseId)", arguments: [baseURL])
            
            print("Order Approval Delivery: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_OrderApprovalDelivery!(orderApprovalDelivery: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 5, errorMessage: "Order Approval Delivery Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // 27-12-2018..
    
    func API_GetQuotationList(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached -  Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetQuotationList?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Tailor Quotation List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_GetQuotationList!(quotationList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 20, errorMessage: "Get Quotation List Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_GetOrderRequest(RequestId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached -  Value")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetOrderRequest?Id=\(RequestId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_GetOrderRequest!(requestList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 22, errorMessage: "Get Order Request Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //Book an Appointment Material..
    func API_InsertAppoinmentMaterial(OrderId : Int, AppointmentType : Int, AppointmentTime : String, From : String, To : String, Type : String, CreatedBy : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Book an Appointment Page")
            
            let parameters = ["OrderId" : OrderId, "AppointmentType" : AppointmentType, "AppointmentTime" : AppointmentTime, "From" : From, "To" : To, "Type" : Type, "CreatedBy" : CreatedBy] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertAppointforMaterial", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertAppointmentMaterial!(insertAppointmentMaterial: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 15, errorMessage: "Insert Appoinment Material Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //Book an Appointment Measurement..
    func API_InsertAppoinmentMeasurement(OrderId : Int, AppointmentType : Int, AppointmentTime : String, From : String, To : String, Type : String, CreatedBy : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Book an Appointment Page")
            
            let parameters = ["OrderId" : OrderId, "AppointmentType" : AppointmentType, "AppointmentTime" : AppointmentTime, "From" : From, "To" : To, "Type" : Type, "CreatedBy" : CreatedBy] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertAppointforMeasurement", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertAppointmentMeasurement!(insertAppointmentMeasure: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 16, errorMessage: "Insert Appoinment Measurement Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_SortAscending(delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Sort Ascending Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetAscendingDressType", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_SortAscending!(ascending: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 16, errorMessage: "Sort Ascending Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_SortDescending(delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Sort Descending Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetDescendingDressType", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_SortDescending!(descending: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 16, errorMessage: "Sort Descending Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    
    // Order Approval - Qty update..
    func API_UpdateQtyOrderApproval(OrderId : Int, Qty : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Order Approval Page")
            
            let parameters = ["OrderId" : OrderId, "Qty" : Qty] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/UPdateQtyInOrderApproval", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_UpdateQtyOrderApproval!(updateQtyOA: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 21, errorMessage: "Order Approval Qty Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Book an Appointment Get Material..
    func API_GetAppointmentMaterial(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Book an Appointemnt Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomerInAppoinmentMeaterial?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("response", self.resultDict)
                    delegate.API_CALLBACK_GetAppointmentMaterial!(getAppointmentMaterial: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 24, errorMessage: "Get Appointment Material Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Book an Appointment Get Measurement..
    func API_GetAppointmentMeasurement(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached -  Book an Appointemnt Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetCustomerInAppoinmentMeasurement?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("resultDict", self.resultDict)
                    delegate.API_CALLBACK_GetAppointmentMeasurement!(getAppointmentMeasure: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 25, errorMessage: "Get Appointment Measurement Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Book an Appointment IsApprove Material..
    func API_IsApproveAppointmentMaterial(AppointmentId : Int, IsApproved : Int, Reason:String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Book an Appointemnt Page")
            
            let parameters = ["AppointmentId" : AppointmentId, "IsApproved" : IsApproved, "Reason" : Reason] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/BuyerOrderApprovalMaterial", arguments: [baseURL])
            
            print("Appointment IsApprove: ", urlString)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_IsApproveAptMaterial!(IsApproveMaterial: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 26, errorMessage: "IsApprove Material Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Book an Appointment IsApprove Measurement..
    func API_IsApproveAppointmentMeasurement(AppointmentId : Int, IsApproved : Int, Reason:String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached -  Book an Appointemnt Page")
            
            let parameters = ["AppointmentId" : AppointmentId, "IsApproved" : IsApproved, "Reason" : Reason] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/BuyerOrderApprovalMeasurement", arguments: [baseURL])
            
            print("Appointment IsApprove: ", urlString)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_IsApproveAptMeasurement!(IsApproveMeasure: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 27, errorMessage: "IsApprove Measurement Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    
    // Payment Status....
    func API_updatePaymentStatus(PaymentStatus : Int, OrderId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached -  Payment Page")
            
            let parameters = ["PaymentStatus" : PaymentStatus, "OrderId" : OrderId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/UpatePaymentStatus", arguments: [baseURL])
            
            print("Update Payment Status: ", urlString)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_UpdatePaymentStatus!(updatePaymentStatus: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 28, errorMessage: "Payment Status Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Buyer Order Approval....
    func API_BuyerOrderApproval(OrderId : Int, ApprovedTailorId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached -  Payment Page")
            
            let parameters = ["OrderId" : OrderId, "ApprovedTailorId" : ApprovedTailorId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/BuyerOrderApproval", arguments: [baseURL])
            
            print("Buyer Order Approval: ", urlString)
            
            request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("response", self.resultDict)
                    delegate.API_CALLBACK_BuyerOrderApproval!(buyerOrderApproval: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 29, errorMessage: "Payment Status Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Get Appointments List..
    func API_GetAppointmentList(BuyerId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Appointment List Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetAppoinmentList?BuyerId=\(BuyerId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("resultDict", self.resultDict)
                    delegate.API_CALLBACK_GetAppointmentList!(getAppointmentList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 30, errorMessage: "Appointment List Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Total Appointment List.. Approve and reject List..
    func API_ApproveRejectAppointmentList(BuyerId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Appointment List Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTotelAppoinmentList?BuyerId=\(BuyerId)", arguments: [baseURL])
            
            print("Order Request List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("resultDict", self.resultDict)
                    delegate.API_CALLBACK_ApproveRejectAppointmentList!(getTotalAppointmentList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 31, errorMessage: "Appointment List Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_ServiceRequest(delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Service Request Page")
            
            let urlString:String = String(format: "%@/API/Shop/GetServiceType", arguments: [baseURL])
            
            print("URL STRING FOR Service Request", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    
                    delegate.API_CALLBACK_ServiceRequest!(service: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 10, errorMessage: "Service Request Failed")
                }
            }
        }
        
    }
    
    // Get Ratings..
    func API_GetRatings(TailorId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Reviews and Ratings Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetRating?TailorId=\(TailorId)", arguments: [baseURL])
            
            print("Get Ratings List: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("resultDict", self.resultDict)
                    delegate.API_CALLBACK_GetRatings!(getRatings: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 32, errorMessage: "Get Ratings Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    
    
    func API_DirectionRequest(origin : String, destination : String, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Direction Page")
            
            let urlString:String = String(format: "%@https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving", arguments: [])
            
            print("URL STRING", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                
                print("REQUEST", request)
                //                let json = JSON(data: response.data!)
                //                let routes = json["routes"].arrayValue
                
                print("ROUTES", response.data)
                
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_DirectionRequest!(direction: self.resultDict)
                    print("response", self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 6, errorMessage: "Direction Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    // Insert Ratings...
    func API_InsertRatings(OrderId : Int, CategoryId : Int, Review : String, Rating : Int, TailorId : Int, delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Reviews And Ratings Page")
            
            let parameters = ["OrderId" : OrderId, "CategoryId" : CategoryId, "Review" : Review, "Rating" : Rating, "TailorId" : TailorId] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/InsertRating", arguments: [baseURL])
            
            print("URL STRING", urlString)
            print("PARAMETERS", parameters)
            
            request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
                print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    delegate.API_CALLBACK_InsertRating!(insertRating: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 33, errorMessage: "Insert Ratings Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //  List Of Orders(Pending)..
    func API_ListOfOrdersPending(BuyerId : String , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - List Of Orders Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/ListOfOrderPending?BuyerId=\(BuyerId)", arguments: [baseURL])
            
            print("List of Orders(Pending): ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    //print("resultDict", self.resultDict)
                    
                    delegate.API_CALLBACK_ListOfPendOrders!(PendingOrdersList: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 34, errorMessage: "List Of Orders Failed")
                    
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    
    //  ORder Details..
    func API_GetOrderDetails(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - List Of Orders Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetOrderDetails?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Order Details: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    // print("resultDict", self.resultDict)
                    
                    delegate.API_CALLBACK_GetOrderDetails!(getOrderDetails: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 35, errorMessage: "Order Details Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    //  Tracking Details..
    func API_GetTrackingDetails(OrderId : Int , delegate : ServerAPIDelegate)
    {
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - List Of Orders Page")
            
            let parameters = [:] as [String : Any]
            
            let urlString:String = String(format: "%@/API/Order/GetTrackingDetails?OrderId=\(OrderId)", arguments: [baseURL])
            
            print("Tracking Details: ", urlString)
            
            request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {response in
                // print("REQUEST", request)
                if response.result.value != nil
                {
                    self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                    print("resultDict", self.resultDict)
                    
                    delegate.API_CALLBACK_GetTrackingDetails!(getTrackingDetails: self.resultDict)
                }
                else
                {
                    delegate.API_CALLBACK_Error(errorNumber: 36, errorMessage: "Tracking Details Failed")
                }
            }
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_ReferenceImageUpload(referenceImages : [UIImage], delegate : ServerAPIDelegate)
    {
        let date = Date().timeIntervalSince1970
        print("DATE", date)
        
        let dateInt = Int(date)
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Reference Image Upload Page")
            
            let parameters = ["ReferenceImages" : referenceImages] as [String : [UIImage]]
            
            let urlString:String = String(format: "%@/API/FileUpload/UploadFile", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                "Content-type": "multipart/form-data",
                "Accept":"*/*"
            ]
            
            upload(multipartFormData: {(multipartFormData:MultipartFormData) in
                
                for i in 0..<referenceImages.count
                {
                    multipartFormData.append(referenceImages[i].jpegData(compressionQuality: 0.5)!, withName: "ReferenceImages", fileName: "Reference_\(dateInt).png", mimeType: "image/jpeg")
                };
                
//                for (key,value) in parameters
//                {
//                    multipartFormData.append(value.jpegData(compressionQuality: 0.5)!, withName: key, fileName: "Profile_\(dateInt).png", mimeType: "image/jpeg")
//                };
                
            }, usingThreshold: UInt64.init(), to:  urlString, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult
                {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        print("SUCCESS IMAGE", response)
                        
                        if response.result.value != nil{
                            self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                            delegate.API_CALLBACK_ReferenceImageUpload!(reference: self.resultDict)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    print("FAILURE IMAGE", encodingError)
                    delegate.API_CALLBACK_Error(errorNumber: 13, errorMessage: "REFERENCE Image Upload Page Failed")
                }
            })
        }
        else
        {
            print("no internet")
        }
    }
    
    func API_MaterialImageUpload(materialImages : [String : UIImage], delegate : ServerAPIDelegate)
    {
        let date = Date().timeIntervalSince1970
        print("DATE", date)
        
        let dateInt = Int(date)
        
        if (Reachability()?.isReachable)!
        {
            print("Server Reached - Material Image Upload Page", materialImages.count)
            
            let parameters = ["MaterialImages" : materialImages] as [String : Any]
            
            let urlString:String = String(format: "%@/API/FileUpload/UploadFile", arguments: [baseURL])
            
            print("URL STRING FOR OrderType", urlString)
            
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                "Content-type": "multipart/form-data",
                "Accept":"*/*"
            ]
            
            upload(multipartFormData: {(multipartFormData:MultipartFormData) in
                
                for (key,value) in parameters
                {
//                    multipartFormData.append((value as AnyObject).jpegData(compressionQuality: 0.5)!, withName: key, fileName: "Profile_\(dateInt).png", mimeType: "image/jpeg")
                };
                
            }, usingThreshold: UInt64.init(), to:  urlString, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult
                {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        print("SUCCESS IMAGE", response)
                        
                        if response.result.value != nil{
                            self.resultDict = response.result.value as! NSDictionary // method in apidelegate
                            delegate.API_CALLBACK_MaterialImageUpload!(material: self.resultDict)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    print("FAILURE IMAGE", encodingError)
                    delegate.API_CALLBACK_Error(errorNumber: 13, errorMessage: "Material Image Upload Page Failed")
                }
            })
        }
        else
        {
            print("no internet")
        }
    }

}
