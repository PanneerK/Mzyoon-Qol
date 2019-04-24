//
//  LoginViewController.swift
//  Mzyoon
//
//  Created by QOL on 16/10/18.
//  Copyright © 2018 QOL. All rights reserved.
//

import Foundation

@objc protocol ServerAPIDelegate
{
    func API_CALLBACK_Error(errorNumber:Int,errorMessage:String)
    
    @objc optional func API_CALLBACK_Login(loginResult : NSDictionary)
    @objc optional func API_CALLBACK_ResendOTP(otpResult : NSDictionary)
    @objc optional func API_CALLBACK_ValidateOTP(loginResult : NSDictionary)
    @objc optional func API_CALLBACK_CountryCode(countryCodes : NSDictionary)
    @objc optional func API_CALLBACK_FlagImages(flagImages : NSDictionary)
    @objc optional func API_CALLBACK_AllLanguages(languages : NSDictionary)
    
    @objc optional func API_CALLBACK_Gender(gender : NSDictionary)
    @objc optional func API_CALLBACK_GenderImage(genderImage : Data)
    @objc optional func API_CALLBACK_DressType(dressType : NSDictionary)
    @objc optional func API_CALLBACK_DressSubType(dressSubType : NSDictionary)
    @objc optional func API_CALLBACK_OrderType(orderType : NSDictionary)
    
    @objc optional func API_CALLBACK_Customization1(custom1 : NSDictionary)
    @objc optional func API_CALLBACK_Customization2(custom2 : NSDictionary)
    @objc optional func API_CALLBACK_Customization3(custom3 : NSDictionary)
    @objc optional func API_CALLBACK_Customization3Attr(custom3Attr : NSDictionary)
    
    @objc optional func API_CALLBACK_InsertAddress(insertAddr : NSDictionary)
    @objc optional func API_CALLBACK_UpdateAddress(updateAddr : NSDictionary)
    @objc optional func API_CALLBACK_DeleteAddress(deleteAddr : NSDictionary)
    @objc optional func API_CALLBACK_GetBuyerAddress(getBuyerAddr : NSDictionary)
    @objc optional func API_CALLBACK_GetBuyerIndividualAddressByAddressId(getAddress : NSDictionary)
    
    @objc optional func API_CALLBACK_Profile(profile : NSDictionary)
    @objc optional func API_CALLBACK_IntroProfile(introProf : NSDictionary)
    @objc optional func API_CALLBACK_ProfileImageUpload(ImageUpload : NSDictionary)
    @objc optional func API_CALLBACK_ProfileUpdate(profUpdate : NSDictionary)
    @objc optional func API_CALLBACK_ProfileUserType(userType : NSDictionary)
    @objc optional func API_CALLBACK_ExistingUserProfile(userProfile : NSDictionary)
    
    @objc optional func API_CALLBACK_Measurement1(measure1 : NSDictionary)
    @objc optional func API_CALLBACK_GetMeasurement2(GetMeasurement1val : NSDictionary)
    @objc optional func API_CALLBACK_DisplayMeasurement(GetMeasurement2val : NSDictionary)
    @objc optional func API_CALLBACK_GetMeasurementParts(getParts : NSDictionary)
    @objc optional func API_CALLBACK_InsertUserMeasurement(insUsrMeasurementVal : NSDictionary)
    @objc optional func API_CALLBACK_ExistingUserMeasurement(getExistUserMeasurement : NSDictionary)
    
    @objc optional func API_CALLBACK_GetTailorList(TailorList : NSDictionary)
    
    @objc optional func API_CALLBACK_DeviceDetails(deviceDet : NSDictionary)
    @objc optional func API_CALLBACK_InsertErrorDevice(deviceError : NSDictionary)
    
    // 19-12-2018..
    @objc optional func API_CALLBACK_InsertOrderSummary(insertOrder : NSDictionary)
    
    //21.12.2018
    @objc optional func API_CALLBACK_GetStateListByCountry(stateList : NSDictionary)
    
    // 20-12-2018
    @objc optional func API_CALLBACK_OrderApprovalPrice(orderApprovalPrice : NSDictionary)
    @objc optional func API_CALLBACK_OrderApprovalDelivery(orderApprovalDelivery : NSDictionary)
    
    // 27-12-2018
    @objc optional func API_CALLBACK_GetQuotationList(quotationList : NSDictionary)
    
    // 2-1-2019
    @objc optional func API_CALLBACK_GetOrderRequest(requestList : NSDictionary)
    
    // 8-1-2019
    @objc optional func API_CALLBACK_InsertAppointmentMaterial(insertAppointmentMaterial : NSDictionary)
    @objc optional func API_CALLBACK_InsertAppointmentMeasurement(insertAppointmentMeasure : NSDictionary)
    
    //9-1-2019
    @objc optional func API_CALLBACK_SortAscending(ascending : NSDictionary)
    @objc optional func API_CALLBACK_SortDescending(descending : NSDictionary)
    @objc optional func API_CALLBACK_UpdateQtyOrderApproval(updateQtyOA : NSDictionary)
    
    // 11-1-2019
    @objc optional func API_CALLBACK_GetAppointmentMaterial(getAppointmentMaterial : NSDictionary)
    @objc optional func API_CALLBACK_GetAppointmentMeasurement(getAppointmentMeasure : NSDictionary)
    
    // 18-1-2019
    @objc optional func API_CALLBACK_IsApproveAptMaterial(IsApproveMaterial : NSDictionary)
    @objc optional func API_CALLBACK_IsApproveAptMeasurement(IsApproveMeasure : NSDictionary)
    
    // 25-1-2019
    @objc optional func API_CALLBACK_UpdatePaymentStatus(updatePaymentStatus : NSDictionary)
    @objc optional func API_CALLBACK_BuyerOrderApproval(buyerOrderApproval : NSDictionary)
    
    @objc optional func API_CALLBACK_GetAppointmentList(getAppointmentList : NSDictionary)
    @objc optional func API_CALLBACK_ApproveRejectAppointmentList(getTotalAppointmentList : NSDictionary)
    
    //29.01.2019
    @objc optional func API_CALLBACK_ServiceRequest(service : NSDictionary)
    
    //01.02.2019
    @objc optional func API_CALLBACK_DirectionRequest(direction : NSDictionary)
    
    // 29-1-2019
    @objc optional func API_CALLBACK_GetRatings(getRatings : NSDictionary)
    @objc optional func API_CALLBACK_InsertRating(insertRating : NSDictionary)
    @objc optional func API_CALLBACK_ListOfPendOrders(PendingOrdersList : NSDictionary)
    
    //31-1-2019
    @objc optional func API_CALLBACK_GetOrderDetails(getOrderDetails : NSDictionary)
    @objc optional func API_CALLBACK_GetTrackingDetails(getTrackingDetails : NSDictionary)
    
    //07.02.2019
    @objc optional func API_CALLBACK_ReferenceImageUpload(reference : NSDictionary)
    @objc optional func API_CALLBACK_MaterialImageUpload(material : NSDictionary)
    
    //15.02.2019
    @objc optional func API_CALLBACK_InsertPaymentStatus(status : NSDictionary)
    
    //19.02.2019
    @objc optional func API_CALLBACK_GetAreaByState(area : NSDictionary)
    
    // 20.02.2019
    @objc optional func API_CALLBACK_GetPaymentStore(StoreDetails : NSDictionary)
    @objc optional func API_CALLBACK_GetAppointmentDateForMaterail(MaterialDate : NSDictionary)
    @objc optional func API_CALLBACK_GetAppointmentDateForMeasurement(MeasurementDate : NSDictionary)
    
    // 22.02.2019
    @objc optional func API_CALLBACK_ListOfDeliverOrders(DeliverOrdersList : NSDictionary)
    
    // 05.03.2019
    @objc optional func API_CALLBACK_GetPaymentAddress(getAddress : NSDictionary)
    @objc optional func API_CALLBACK_GetShopDetails(getShopDetails : NSDictionary)
    
    //17.04.2019
    @objc optional func API_CALLBACK_ViewDetails(details : NSDictionary)
    
    //
    
}
