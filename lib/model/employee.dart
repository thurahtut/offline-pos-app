class Employee {
  String? active;
  int? activityCalendarEventId;
  String? activityDateDeadline;
  String? activityExceptionDecoration;
  String? activityExceptionIcon;
  String? activityIds;
  String? activityState;
  String? activitySummary;
  String? activityTypeIcon;
  int? activityTypeId;
  int? activityUserId;
  String? additionalNote;
  int? addressHomeId;
  int? addressId;
  String? avatar1024;
  String? avatar128;
  String? avatar1920;
  String? avatar256;
  String? avatar512;
  int? bankAccountId;
  String? barcode;
  String? birthday;
  String? calendarMismatch;
  String? categoryIds;
  String? certificate;
  int? childAllCount;
  String? childIds;
  String? children;
  int? coachId;
  String? color;
  String? companyCountryCode;
  int? companyCountryId;
  int? companyId;
  int? contractId;
  String? contractIds;
  int? contractsCount;
  String? contractWarning;
  int? countryId;
  String? countryOfBirth;
  String? createDate;
  int? createUid;
  int? departmentId;
  String? departureDate;
  String? departureDescription;
  int? departureReasonId;
  int? destinationLocationId;
  String? displayName;
  int? documentCount;
  String? drivingLicense;
  String? emergencyContact;
  String? emergencyPhone;
  String? employeeType;
  String? firstContractDate;
  String? gender;
  bool? hasMessage;
  bool? hasWorkPermit;
  String? hrIconDisplay;
  String? hrPresenceState;
  int? employeeId;
  String? idCard;
  int? identificationId;
  String? image1024;
  String? image128;
  String? image1920;
  String? image256;
  String? image512;
  bool? isAddressHomeACompany;
  int? jobId;
  String? jobTitle;
  String? kmHomeWork;
  String? lang;
  String? lastActivity;
  String? lastActivityTime;
  String? lastUpdate;
  String? marital;
  int? messageAttachmentCount;
  String? messageFollowerIds;
  bool? messageHasError;
  bool? messageHasErrorCounter;
  bool? messageHasSmsError;
  String? messageIds;
  String? messageIsFollower;
  int? messageMainAttachmentId;
  String? messageNeedaction;
  String? messageNeedactionCounter;
  String? messagePartnerIds;
  String? messageUnread;
  String? messageUnreadCounter;
  String? mobilePhone;
  String? myActivityDateDeadline;
  String? name;
  String? notes;
  int? parentId;
  int? passportId;
  String? permitNo;
  String? phone;
  int? pickingTypeId;
  String? pin;
  String? placeOfBirth;
  String? privateEmail;
  int? resourceCalendarId;
  int? resourceId;
  int? signRequestCount;
  int? sinid;
  String? spouseBirthdate;
  String? spouseCompleteName;
  int? ssnid;
  String? studyField;
  String? studySchool;
  String? subordinateIds;
  String? tz;
  int? userId;
  int? userPartnerId;
  String? vehicle;
  String? visaExpire;
  String? visaNo;
  String? websiteMessageIds;
  String? workEmail;
  int? workLocationId;
  String? workPermitExpirationDate;
  String? workPermitScheduledActivity;
  String? workPhone;
  String? writeDate;
  int? writeUid;

  Employee(
      {this.active,
      this.activityCalendarEventId,
      this.activityDateDeadline,
      this.activityExceptionDecoration,
      this.activityExceptionIcon,
      this.activityIds,
      this.activityState,
      this.activitySummary,
      this.activityTypeIcon,
      this.activityTypeId,
      this.activityUserId,
      this.additionalNote,
      this.addressHomeId,
      this.addressId,
      this.avatar1024,
      this.avatar128,
      this.avatar1920,
      this.avatar256,
      this.avatar512,
      this.bankAccountId,
      this.barcode,
      this.birthday,
      this.calendarMismatch,
      this.categoryIds,
      this.certificate,
      this.childAllCount,
      this.childIds,
      this.children,
      this.coachId,
      this.color,
      this.companyCountryCode,
      this.companyCountryId,
      this.companyId,
      this.contractId,
      this.contractIds,
      this.contractsCount,
      this.contractWarning,
      this.countryId,
      this.countryOfBirth,
      this.createDate,
      this.createUid,
      this.departmentId,
      this.departureDate,
      this.departureDescription,
      this.departureReasonId,
      this.destinationLocationId,
      this.displayName,
      this.documentCount,
      this.drivingLicense,
      this.emergencyContact,
      this.emergencyPhone,
      this.employeeType,
      this.firstContractDate,
      this.gender,
      this.hasMessage,
      this.hasWorkPermit,
      this.hrIconDisplay,
      this.hrPresenceState,
      this.employeeId,
      this.idCard,
      this.identificationId,
      this.image1024,
      this.image128,
      this.image1920,
      this.image256,
      this.image512,
      this.isAddressHomeACompany,
      this.jobId,
      this.jobTitle,
      this.kmHomeWork,
      this.lang,
      this.lastActivity,
      this.lastActivityTime,
      this.lastUpdate,
      this.marital,
      this.messageAttachmentCount,
      this.messageFollowerIds,
      this.messageHasError,
      this.messageHasErrorCounter,
      this.messageHasSmsError,
      this.messageIds,
      this.messageIsFollower,
      this.messageMainAttachmentId,
      this.messageNeedaction,
      this.messageNeedactionCounter,
      this.messagePartnerIds,
      this.messageUnread,
      this.messageUnreadCounter,
      this.mobilePhone,
      this.myActivityDateDeadline,
      this.name,
      this.notes,
      this.parentId,
      this.passportId,
      this.permitNo,
      this.phone,
      this.pickingTypeId,
      this.pin,
      this.placeOfBirth,
      this.privateEmail,
      this.resourceCalendarId,
      this.resourceId,
      this.signRequestCount,
      this.sinid,
      this.spouseBirthdate,
      this.spouseCompleteName,
      this.ssnid,
      this.studyField,
      this.studySchool,
      this.subordinateIds,
      this.tz,
      this.userId,
      this.userPartnerId,
      this.vehicle,
      this.visaExpire,
      this.visaNo,
      this.websiteMessageIds,
      this.workEmail,
      this.workLocationId,
      this.workPermitExpirationDate,
      this.workPermitScheduledActivity,
      this.workPhone,
      this.writeDate,
      this.writeUid});

  Employee.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    activityCalendarEventId =
        int.tryParse(json['activity_calendar_event_id'].toString());
    activityDateDeadline = json['activity_date_deadline'];
    activityExceptionDecoration = json['activity_exception_decoration'];
    activityExceptionIcon = json['activity_exception_icon'];
    activityIds = json['activity_ids'];
    activityState = json['activity_state'];
    activitySummary = json['activity_summary'];
    activityTypeIcon = json['activity_type_icon'];
    activityTypeId = int.tryParse(json['activity_type_id'].toString());
    activityUserId = int.tryParse(json['activity_user_id'].toString());
    additionalNote = json['additional_note'];
    addressHomeId = int.tryParse(json['address_home_id'].toString());
    addressId = int.tryParse(json['address_id'].toString());
    avatar1024 = json['avatar_1024'];
    avatar128 = json['avatar_128'];
    avatar1920 = json['avatar_1920'];
    avatar256 = json['avatar_256'];
    avatar512 = json['avatar_512'];
    bankAccountId = int.tryParse(json['bank_account_id'].toString());
    barcode = json['barcode'];
    birthday = json['birthday'];
    calendarMismatch = json['calendar_mismatch'];
    categoryIds = json['category_ids'];
    certificate = json['certificate'];
    childAllCount = int.tryParse(json['child_all_count'].toString());
    childIds = json['child_ids'];
    children = json['children'];
    coachId = int.tryParse(json['coach_id'].toString());
    color = json['color'];
    companyCountryCode = json['company_country_code'];
    companyCountryId = int.tryParse(json['company_country_id'].toString());
    companyId = int.tryParse(json['company_id'].toString());
    contractId = int.tryParse(json['contract_id'].toString());
    contractIds = json['contract_ids'];
    contractsCount = int.tryParse(json['contracts_count'].toString());
    contractWarning = json['contract_warning'];
    countryId = int.tryParse(json['country_id'].toString());
    countryOfBirth = json['country_of_birth'];
    createDate = json['create_date'];
    createUid = int.tryParse(json['create_uid'].toString());
    departmentId = int.tryParse(json['department_id'].toString());
    departureDate = json['departure_date'];
    departureDescription = json['departure_description'];
    departureReasonId = int.tryParse(json['departure_reason_id'].toString());
    destinationLocationId =
        int.tryParse(json['destination_location_id'].toString());
    displayName = json['display_name'];
    documentCount = int.tryParse(json['document_count'].toString());
    drivingLicense = json['driving_license'];
    emergencyContact = json['emergency_contact'];
    emergencyPhone = json['emergency_phone'];
    employeeType = json['employee_type'];
    firstContractDate = json['first_contract_date'];
    gender = json['gender'];
    hasMessage = bool.tryParse(json['has_message']);
    hasWorkPermit = bool.tryParse(json['has_work_permit']);
    hrIconDisplay = json['hr_icon_display'];
    hrPresenceState = json['hr_presence_state'].toString();
    employeeId = int.tryParse(json['employee_id'].toString());
    idCard = json['id_card'];
    identificationId = int.tryParse(json['identification_id'].toString());
    image1024 = json['image_1024'];
    image128 = json['image_128'];
    image1920 = json['image_1920'];
    image256 = json['image_256'];
    image512 = json['image_512'];
    isAddressHomeACompany =
        bool.tryParse(json['is_address_home_a_company'].toString());
    jobId = int.tryParse(json['job_id'].toString());
    jobTitle = json['job_title'];
    kmHomeWork = json['km_home_work'];
    lang = json['lang'];
    lastActivity = json['last_activity'];
    lastActivityTime = json['last_activity_time'];
    lastUpdate = json['last_update'];
    marital = json['marital'];
    messageAttachmentCount =
        int.tryParse(json['message_attachment_count'].toString());
    messageFollowerIds = json['message_follower_ids'];
    messageHasError = bool.tryParse(json['message_has_error']);
    messageHasErrorCounter = bool.tryParse(json['message_has_error_counter']);
    messageHasSmsError = bool.tryParse(json['message_has_sms_error']);
    messageIds = json['message_ids'];
    messageIsFollower = json['message_is_follower'];
    messageMainAttachmentId =
        int.tryParse(json['message_main_attachment_id'].toString());
    messageNeedaction = json['message_needaction'];
    messageNeedactionCounter = json['message_needaction_counter'];
    messagePartnerIds = json['message_partner_ids'];
    messageUnread = json['message_unread'];
    messageUnreadCounter = json['message_unread_counter'];
    mobilePhone = json['mobile_phone'];
    myActivityDateDeadline = json['my_activity_date_deadline'];
    name = json['name'];
    notes = json['notes'];
    parentId = int.tryParse(json['parent_id'].toString());
    passportId = int.tryParse(json['passport_id'].toString());
    permitNo = json['permit_no'];
    phone = json['phone'];
    pickingTypeId = int.tryParse(json['picking_type_id'].toString());
    pin = json['pin'];
    placeOfBirth = json['place_of_birth'];
    privateEmail = json['private_email'];
    resourceCalendarId = int.tryParse(json['resource_calendar_id'].toString());
    resourceId = int.tryParse(json['resource_id'].toString());
    signRequestCount = int.tryParse(json['sign_request_count'].toString());
    sinid = int.tryParse(json['sinid'].toString());
    spouseBirthdate = json['spouse_birthdate'];
    spouseCompleteName = json['spouse_complete_name'];
    ssnid = int.tryParse(json['ssnid'].toString());
    studyField = json['study_field'];
    studySchool = json['study_school'];
    subordinateIds = json['subordinate_ids'];
    tz = json['tz'];
    userId = int.tryParse(json['user_id'].toString());
    userPartnerId = int.tryParse(json['user_partner_id'].toString().toString());
    vehicle = json['vehicle'];
    visaExpire = json['visa_expire'];
    visaNo = json['visa_no'];
    websiteMessageIds = json['website_message_ids'];
    workEmail = json['work_email'];
    workLocationId = int.tryParse(json['work_location_id'].toString());
    workPermitExpirationDate = json['work_permit_expiration_date'];
    workPermitScheduledActivity = json['work_permit_scheduled_activity'];
    workPhone = json['work_phone'];
    writeDate = json['write_date'];
    writeUid = int.tryParse(json['write_uid'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['activity_calendar_event_id'] = activityCalendarEventId;
    data['activity_date_deadline'] = activityDateDeadline;
    data['activity_exception_decoration'] = activityExceptionDecoration;
    data['activity_exception_icon'] = activityExceptionIcon;
    data['activity_ids'] = activityIds;
    data['activity_state'] = activityState;
    data['activity_summary'] = activitySummary;
    data['activity_type_icon'] = activityTypeIcon;
    data['activity_type_id'] = activityTypeId;
    data['activity_user_id'] = activityUserId;
    data['additional_note'] = additionalNote;
    data['address_home_id'] = addressHomeId;
    data['address_id'] = addressId;
    data['avatar_1024'] = avatar1024;
    data['avatar_128'] = avatar128;
    data['avatar_1920'] = avatar1920;
    data['avatar_256'] = avatar256;
    data['avatar_512'] = avatar512;
    data['bank_account_id'] = bankAccountId;
    data['barcode'] = barcode;
    data['birthday'] = birthday;
    data['calendar_mismatch'] = calendarMismatch;
    data['category_ids'] = categoryIds;
    data['certificate'] = certificate;
    data['child_all_count'] = childAllCount;
    data['child_ids'] = childIds;
    data['children'] = children;
    data['coach_id'] = coachId;
    data['color'] = color;
    data['company_country_code'] = companyCountryCode;
    data['company_country_id'] = companyCountryId;
    data['company_id'] = companyId;
    data['contract_id'] = contractId;
    data['contract_ids'] = contractIds;
    data['contracts_count'] = contractsCount;
    data['contract_warning'] = contractWarning;
    data['country_id'] = countryId;
    data['country_of_birth'] = countryOfBirth;
    data['create_date'] = createDate;
    data['create_uid'] = createUid;
    data['department_id'] = departmentId;
    data['departure_date'] = departureDate;
    data['departure_description'] = departureDescription;
    data['departure_reason_id'] = departureReasonId;
    data['destination_location_id'] = destinationLocationId;
    data['display_name'] = displayName;
    data['document_count'] = documentCount;
    data['driving_license'] = drivingLicense;
    data['emergency_contact'] = emergencyContact;
    data['emergency_phone'] = emergencyPhone;
    data['employee_type'] = employeeType;
    data['first_contract_date'] = firstContractDate;
    data['gender'] = gender;
    data['has_message'] = hasMessage.toString();
    data['has_work_permit'] = hasWorkPermit.toString();
    data['hr_icon_display'] = hrIconDisplay;
    data['hr_presence_state'] = hrPresenceState;
    data['employee_id'] = employeeId;
    data['id_card'] = idCard;
    data['identification_id'] = identificationId;
    data['image_1024'] = image1024;
    data['image_128'] = image128;
    data['image_1920'] = image1920;
    data['image_256'] = image256;
    data['image_512'] = image512;
    data['is_address_home_a_company'] = isAddressHomeACompany.toString();
    data['job_id'] = jobId;
    data['job_title'] = jobTitle;
    data['km_home_work'] = kmHomeWork;
    data['lang'] = lang;
    data['last_activity'] = lastActivity;
    data['last_activity_time'] = lastActivityTime;
    data['last_update'] = lastUpdate;
    data['marital'] = marital;
    data['message_attachment_count'] = messageAttachmentCount;
    data['message_follower_ids'] = messageFollowerIds;
    data['message_has_error'] = messageHasError.toString();
    data['message_has_error_counter'] = messageHasErrorCounter.toString();
    data['message_has_sms_error'] = messageHasSmsError.toString();
    data['message_ids'] = messageIds;
    data['message_is_follower'] = messageIsFollower;
    data['message_main_attachment_id'] = messageMainAttachmentId;
    data['message_needaction'] = messageNeedaction;
    data['message_needaction_counter'] = messageNeedactionCounter;
    data['message_partner_ids'] = messagePartnerIds;
    data['message_unread'] = messageUnread;
    data['message_unread_counter'] = messageUnreadCounter;
    data['mobile_phone'] = mobilePhone;
    data['my_activity_date_deadline'] = myActivityDateDeadline;
    data['name'] = name;
    data['notes'] = notes;
    data['parent_id'] = parentId;
    data['passport_id'] = passportId;
    data['permit_no'] = permitNo;
    data['phone'] = phone;
    data['picking_type_id'] = pickingTypeId;
    data['pin'] = pin;
    data['place_of_birth'] = placeOfBirth;
    data['private_email'] = privateEmail;
    data['resource_calendar_id'] = resourceCalendarId;
    data['resource_id'] = resourceId;
    data['sign_request_count'] = signRequestCount;
    data['sinid'] = sinid;
    data['spouse_birthdate'] = spouseBirthdate;
    data['spouse_complete_name'] = spouseCompleteName;
    data['ssnid'] = ssnid;
    data['study_field'] = studyField;
    data['study_school'] = studySchool;
    data['subordinate_ids'] = subordinateIds;
    data['tz'] = tz;
    data['user_id'] = userId;
    data['user_partner_id'] = userPartnerId;
    data['vehicle'] = vehicle;
    data['visa_expire'] = visaExpire;
    data['visa_no'] = visaNo;
    data['website_message_ids'] = websiteMessageIds;
    data['work_email'] = workEmail;
    data['work_location_id'] = workLocationId;
    data['work_permit_expiration_date'] = workPermitExpirationDate;
    data['work_permit_scheduled_activity'] = workPermitScheduledActivity;
    data['work_phone'] = workPhone;
    data['write_date'] = writeDate;
    data['write_uid'] = writeUid;
    return data;
  }
}
