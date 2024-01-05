// ignore_for_file: constant_identifier_names

import 'package:offline_pos/components/export_files.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const CUSTOMER_TABLE_NAME = "customer_table";
const CUSTOMER_ID_IN_CT = "customer_id";
const ACCOUNT_REPRESENTED_COMPANY_IDS = "account_represented_company_ids";
const ACTIVE_IN_CT = "active";
const ACTIVE_LANG_COUNT = "active_lang_count";
const ACTIVE_LIMIT = "active_limit";
const ACTIVITY_CALENDAR_EVENT_ID_IN_CT = "activity_calendar_event_id";
const ACTIVITY_DATE_DEADLINE_IN_CT = "activity_date_deadline";
const ACTIVITY_EXCEPTION_DECORATION_IN_CT = "activity_exception_decoration";
const ACTIVITY_EXCEPTION_ICON_IN_CT = "activity_exception_icon";
const ACTIVITY_IDS = "activity_ids";
const ACTIVITY_STATE_IN_CT = "activity_state";
const ACTIVITY_SUMMARY_IN_CT = "activity_summary";
const ACTIVITY_TYPE_ICON_IN_CT = "activity_type_icon";
const ACTIVITY_TYPE_ID_IN_CT = "activity_type_id";
const ACTIVITY_USER_ID_IN_CT = "activity_user_id";
const APP_CUSTOMER = "app_customer";
const AVATAR_1024_IN_CT = "avatar_1024";
const AVATAR_128_IN_CT = "avatar_128";
const AVATAR_1920_IN_CT = "avatar_1920";
const AVATAR_256_IN_CT = "avatar_256";
const AVATAR_512_IN_CT = "avatar_512";
const BANK_ACCOUNT_COUNT = "bank_account_count";
const BANK_IDS = "bank_ids";
const BANNER_IMAGE = "banner_image";
const BARCODE_IN_CT = "barcode";
const BLOCKING_STAGE = "blocking_stage";
const CALENDAR_LAST_NOTIF_ACK = "calendar_last_notif_ack";
const CAN_PUBLISH = "can_publish";
const CATEGORY_ID = "category_id";
const CHANNEL_IDS = "channel_ids";
const CHILD_IDS_IN_CT = "child_ids";
const CITY = "city";
const CITY_ID = "city_id";
const COLOR_IN_CT = "color";
const COMMENT = "comment";
const COMMERCIAL_COMPANY_NAME = "commercial_company_name";
const COMMERCIAL_PARTNER_ID = "commercial_partner_id";
const COMPANY_ID = "company_id";
const COMPANY_NAME = "company_name";
const COMPANY_TYPE = "company_type";
const CONTACT_ADDRESS = "contact_address";
const CONTACT_ADDRESS_COMPLETE = "contact_address_complete";
const CONTRACT_IDS_IN_CT = "contract_ids";
const COUNTRY_CODE_IN_CT = "country_code";
const COUNTRY_ID_IN_CT = "country_id";
const CREATE_DATE_IN_CT = "create_date";
const CREATE_UID = "create_uid";
const CREDIT = "credit";
const CREDIT_LIMIT = "credit_limit";
const CURRENCY_ID_IN_CT = "currency_id";
const CUSTOMER_CODE = "customer_code";
const CUSTOMER_RANK = "customer_rank";
const CVS = "cvs";
const DATE = "date";
const DATE_LOCALIZATION = "date_localization";
const DEBIT = "debit";
const DEBIT_LIMIT = "debit_limit";
const DEFAULT_SHIPPING_ADDRESS_ID = "default_shipping_address_id";
const DEFAULT_SUPPLIERINFO_DISCOUNT = "default_supplierinfo_discount";
const DELIVERY_CHARGE = "delivery_charge";
const DEVICE_TOKEN = "device_token";
const DICA_REG = "dica_reg";
const DISCOUNT = "discount";
const DISPLAY_NAME_IN_CT = "display_name";
const DOB = "dob";
const DOCUMENT_COUNT_IN_CT = "document_count";
const DUE_AMOUNT = "due_amount";
const EASY = "easy";
const EASY_A = "easy_a";
const EASY_B = "easy_b";
const EASY_C = "easy_c";
const ECOM = "ecom";
const EMAIL = "email";
const EMAIL_FORMATTED = "email_formatted";
const EMAIL_NORMALIZED = "email_normalized";
const EMPLOYEE = "employee";
const CUSTOMER_IDS = "CUSTOMER_IDs";
const EMPLOYEE_REF = "employee_ref";
const EMPLOYEES_COUNT = "employees_count";
const FOLLOWUP_LEVEL = "followup_level";
const FOLLOWUP_STATUS = "followup_status";
const FUNCTION = "function";
const GENDER_IN_CT = "gender";
const HAS_MESSAGE_IN_CT = "has_message";
const HAS_UNRECONCILED_ENTRIES = "has_unreconciled_entries";
const IAP_ENRICH_INFO = "iap_enrich_info";
const IAP_SEARCH_DOMAIN = "iap_search_domain";
const IMAGE_1024_IN_CT = "image_1024";
const IMAGE_128_IN_CT = "image_128";
const IMAGE_1920_IN_CT = "image_1920";
const IMAGE_256_IN_CT = "image_256";
const IMAGE_512_IN_CT = "image_512";
const IMAGE_MEDIUM = "image_medium";
const IM_STATUS = "im_status";
const INDUSTRY_ID = "industry_id";
const INVOICE_IDS = "invoice_ids";
const INVOICE_WARN = "invoice_warn";
const INVOICE_WARN_MSG = "invoice_warn_msg";
const IS_BLACKLISTED = "is_blacklisted";
const IS_COMPANY = "is_company";
const IS_PUBLISHED = "is_published";
const IS_SEO_OPTIMIZED = "is_seo_optimized";
const IS_SUPPLIER = "is_supplier";
const JOURNAL_ITEM_COUNT = "journal_item_count";
const LANG_IN_CT = "lang";
const LAST_MOBIKUL_SO_ID = "last_mobikul_so_id";
const LAST_TIME_ENTRIES_CHECKED = "last_time_entries_checked";
const LAST_UPDATE_IN_CT = "last_update";
const LAST_WEBSITE_SO_ID = "last_website_so_id";
const LOYALTY_POINTS_IN_CT = "loyalty_points";
const MAXI = "maxi";
const MEETING_COUNT = "meeting_count";
const MEETING_IDS = "meeting_ids";
const MEMBER_TYPE = "member_type";
const MESSAGE_ATTACHMENT_COUNT_IN_CT = "message_attachment_count";
const MESSAGE_BOUNCE = "message_bounce";
const MESSAGE_FOLLOWER_IDS_IN_CT = "message_follower_ids";
const MESSAGE_HAS_ERROR_IN_CT = "message_has_error";
const MESSAGE_HAS_ERROR_COUNTER_IN_CT = "message_has_error_counter";
const MESSAGE_HAS_SMS_ERROR_IN_CT = "message_has_sms_error";
const MESSAGE_IDS_IN_CT = "message_ids";
const MESSAGE_IS_FOLLOWER_IN_CT = "message_is_follower";
const MESSAGE_MAIN_ATTACHMENT_ID_IN_CT = "message_main_attachment_id";
const MESSAGE_NEEDACTION_IN_CT = "message_needaction";
const MESSAGE_NEEDACTION_COUNTER_IN_CT = "message_needaction_counter";
const MESSAGE_PARTNER_IDS_IN_CT = "message_partner_ids";
const MESSAGE_UNREAD_IN_CT = "message_unread";
const MESSAGE_UNREAD_COUNTER_IN_CT = "message_unread_counter";
const MOBILE = "mobile";
const MOBILE_BLACKLISTED = "mobile_blacklisted";
const MOBILE_USER = "mobile_user";
const MY_ACTIVITY_DATE_DEADLINE_IN_CT = "my_activity_date_deadline";
const NAME_IN_CT = "name";
const NRC = "nrc";
const OCN_TOKEN = "ocn_token";
const ONLINE_PARTNER_INFORMATION = "online_partner_information";
const ON_TIME_RATE = "on_time_rate";
const OPPORTUNITY_COUNT = "opportunity_count";
const OPPORTUNITY_IDS = "opportunity_ids";
const OVER_CREDIT = "over_credit";
const PARENT_ID_IN_CT = "parent_id";
const PARENT_NAME = "parent_name";
const PARTNER_GENDER = "partner_gender";
const PARTNER_LATITUDE = "partner_latitude";
const PARTNER_LONGITUDE = "partner_longitude";
const PARTNER_SHARE = "partner_share";
const PAYMENT_NEXT_ACTION_DATE = "payment_next_action_date";
const PAYMENT_RESPONSIBLE_ID = "payment_responsible_id";
const PAYMENT_TOKEN_COUNT = "payment_token_count";
const PAYMENT_TOKEN_IDS = "payment_token_ids";
const PHONE_IN_CT = "phone";
const PHONE_BLACKLISTED = "phone_blacklisted";
const PHONE_MOBILE_SEARCH = "phone_mobile_search";
const PHONE_SANITIZED = "phone_sanitized";
const PHONE_SANITIZED_BLACKLISTED = "phone_sanitized_blacklisted";
const PICKING_TYPE = "picking_type";
const PICKING_WARN = "picking_warn";
const PICKING_WARN_MSG = "picking_warn_msg";
const POS_ORDER_COUNT = "pos_order_count";
const POS_ORDER_IDS = "pos_order_ids";
const PROPERTY_ACCOUNT_PAYABLE_ID = "property_account_payable_id";
const PROPERTY_ACCOUNT_POSITION_ID = "property_account_position_id";
const PROPERTY_ACCOUNT_RECEIVABLE_ID = "property_account_receivable_id";
const PROPERTY_DELIVERY_CARRIER_ID = "property_delivery_carrier_id";
const PROPERTY_PAYMENT_TERM_ID = "property_payment_term_id";
const PROPERTY_PRODUCT_PRICELIST = "property_product_pricelist";
const PROPERTY_PURCHASE_CURRENCY_ID = "property_purchase_currency_id";
const PROPERTY_STOCK_CUSTOMER = "property_stock_customer";
const PROPERTY_STOCK_SUPPLIER = "property_stock_supplier";
const PROPERTY_SUPPLIER_PAYMENT_TERM_ID = "property_supplier_payment_term_id";
const PURCHASE_LINE_IDS = "purchase_line_ids";
const PURCHASE_ORDER_COUNT = "purchase_order_count";
const PURCHASE_WARN = "purchase_warn";
const PURCHASE_WARN_MSG = "purchase_warn_msg";
const QR_CODE = "qr_code";
const RANKING = "ranking";
const REBATE_CHARGE = "rebate_charge";
const RECEIPT_REMINDER_EMAIL = "receipt_reminder_email";
const REF = "ref";
const REF_COMPANY_IDS = "ref_company_ids";
const REGION_ID = "region_id";
const REMINDER_DATE_BEFORE_RECEIPT = "reminder_date_before_receipt";
const SALE_ORDER_COUNT = "sale_order_count";
const SALE_ORDER_IDS = "sale_order_ids";
const SALE_WARN = "sale_warn";
const SALE_WARN_MSG = "sale_warn_msg";
const SAME_VAT_PARTNER_ID = "same_vat_partner_id";
const SELF = "self";
const SEO_NAME = "seo_name";
const SH_CID = "sh_cid";
const SH_CUSTOMER_DISCOUNT = "sh_customer_discount";
const SH_EXPIRY_DATE = "sh_expiry_date";
const SH_LOYALTY_CARD_NO = "sh_loyalty_card_no";
const SH_OWN_CUSTOMER = "sh_own_customer";
const SH_USER_POINT = "sh_user_point";
const SH_USER_POINT_AMOUNT = "sh_user_point_amount";
const SIGNATURE_COUNT = "signature_count";
const SIGNUP_EXPIRATION = "signup_expiration";
const SIGNUP_TOKEN = "signup_token";
const SIGNUP_TYPE = "signup_type";
const SIGNUP_URL = "signup_url";
const SIGNUP_VALID = "signup_valid";
const STATE_ID = "state_id";
const STREET = "street";
const STREET2 = "street2";
const SUPPLIER_INVOICE_COUNT = "supplier_invoice_count";
const SUPPLIER_RANK = "supplier_rank";
const SYNC_MOBILE = "sync_mobile";
const TEAM_ID = "team_id";
const TITLE = "title";
const TOKEN_IDS = "token_ids";
const TOTAL_DUE = "total_due";
const TOTAL_INVOICED = "total_invoiced";
const TOTAL_OVERDUE = "total_overdue";
const TOTAL_SALE_AMOUNT = "total_sale_amount";
const TOWNSHIP_ID = "township_id";
const TRUST = "trust";
const TYPE = "type";
const TZ_IN_CT = "tz";
const TZ_OFFSET = "tz_offset";
const UNPAID_INVOICES = "unpaid_invoices";
const UNRECONCILED_AML_IDS = "unreconciled_aml_ids";
const USER_ID = "user_id";
const USER_IDS = "user_ids";
const VAT = "vat";
const VENDOR_CODE = "vendor_code";
const VENDOR_REG = "vendor_reg";
const VISITOR_IDS = "visitor_ids";
const WALLET_BALANCE = "wallet_balance";
const WALLET_COUNTS = "wallet_counts";
const WALLET_CREDITS = "wallet_credits";
const WALLET_ID = "wallet_id";
const WARNING_STAGE = "warning_stage";
const WEBSITE = "website";
const WEBSITE_DESCRIPTION = "website_description";
const WEBSITE_ID = "website_id";
const WEBSITE_MESSAGE_IDS_IN_CT = "website_message_ids";
const WEBSITE_META_DESCRIPTION = "website_meta_description";
const WEBSITE_META_KEYWORDS = "website_meta_keywords";
const WEBSITE_META_OG_IMG = "website_meta_og_img";
const WEBSITE_META_TITLE = "website_meta_title";
const WEBSITE_PUBLISHED = "website_published";
const WEBSITE_SHORT_DESCRIPTION = "website_short_description";
const WEBSITE_URL = "website_url";
const WISHLIST_IDS = "wishlist_ids";
const WRITE_DATE = "write_date";
const WRITE_UID = "write_uid";
const X_STUDIO_BUSINESS_INDUSTRY = "x_studio_business_industry";
const X_STUDIO_CUSTOMER_GROUP = "x_studio_customer_group";
const X_STUDIO_EXTRA_BANK_INFORMATION = "x_studio_extra_bank_information";
const X_STUDIO_EXTRA_INFO = "x_studio_extra_info";
const X_STUDIO_SELECTION_FIELD_EDYMZ = "x_studio_selection_field_edymz";
const X_STUDIO_TRADER = "x_studio_trader";
const X_STUDIO_TRADER_DISPLAY_NAME = "x_studio_trader_display_name";
const ZIP = "zip";

class CustomerTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $CUSTOMER_TABLE_NAME("
        "$CUSTOMER_ID_IN_CT INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$ACCOUNT_REPRESENTED_COMPANY_IDS TEXT,"
        "$ACTIVE_IN_CT TEXT,"
        "$ACTIVE_LANG_COUNT TEXT,"
        "$ACTIVE_LIMIT TEXT,"
        "$ACTIVITY_CALENDAR_EVENT_ID_IN_CT TEXT,"
        "$ACTIVITY_DATE_DEADLINE_IN_CT TEXT,"
        "$ACTIVITY_EXCEPTION_DECORATION_IN_CT TEXT,"
        "$ACTIVITY_EXCEPTION_ICON_IN_CT TEXT,"
        "$ACTIVITY_IDS TEXT,"
        "$ACTIVITY_STATE_IN_CT TEXT,"
        "$ACTIVITY_SUMMARY_IN_CT TEXT,"
        "$ACTIVITY_TYPE_ICON_IN_CT TEXT,"
        "$ACTIVITY_TYPE_ID_IN_CT TEXT,"
        "$ACTIVITY_USER_ID_IN_CT TEXT,"
        "$APP_CUSTOMER TEXT,"
        "$AVATAR_1024_IN_CT TEXT,"
        "$AVATAR_128_IN_CT TEXT,"
        "$AVATAR_1920_IN_CT TEXT,"
        "$AVATAR_256_IN_CT TEXT,"
        "$AVATAR_512_IN_CT TEXT,"
        "$BANK_ACCOUNT_COUNT TEXT,"
        "$BANK_IDS TEXT,"
        "$BANNER_IMAGE TEXT,"
        "$BARCODE_IN_CT TEXT,"
        "$BLOCKING_STAGE TEXT,"
        "$CALENDAR_LAST_NOTIF_ACK TEXT,"
        "$CAN_PUBLISH TEXT,"
        "$CATEGORY_ID TEXT,"
        "$CHANNEL_IDS TEXT,"
        "$CHILD_IDS_IN_CT TEXT,"
        "$CITY TEXT,"
        "$CITY_ID TEXT,"
        "$COLOR_IN_CT TEXT,"
        "$COMMENT TEXT,"
        "$COMMERCIAL_COMPANY_NAME TEXT,"
        "$COMMERCIAL_PARTNER_ID TEXT,"
        "$COMPANY_ID TEXT,"
        "$COMPANY_NAME TEXT,"
        "$COMPANY_TYPE TEXT,"
        "$CONTACT_ADDRESS TEXT,"
        "$CONTACT_ADDRESS_COMPLETE TEXT,"
        "$CONTRACT_IDS_IN_CT TEXT,"
        "$COUNTRY_CODE_IN_CT TEXT,"
        "$COUNTRY_ID_IN_CT TEXT,"
        "$CREATE_DATE_IN_CT TEXT,"
        "$CREATE_UID TEXT,"
        "$CREDIT TEXT,"
        "$CREDIT_LIMIT TEXT,"
        "$CURRENCY_ID_IN_CT TEXT,"
        "$CUSTOMER_CODE TEXT,"
        "$CUSTOMER_RANK TEXT,"
        "$CVS TEXT,"
        "$DATE TEXT,"
        "$DATE_LOCALIZATION TEXT,"
        "$DEBIT TEXT,"
        "$DEBIT_LIMIT TEXT,"
        "$DEFAULT_SHIPPING_ADDRESS_ID TEXT,"
        "$DEFAULT_SUPPLIERINFO_DISCOUNT TEXT,"
        "$DELIVERY_CHARGE TEXT,"
        "$DEVICE_TOKEN TEXT,"
        "$DICA_REG TEXT,"
        "$DISCOUNT TEXT,"
        "$DISPLAY_NAME_IN_CT TEXT,"
        "$DOB TEXT,"
        "$DOCUMENT_COUNT_IN_CT TEXT,"
        "$DUE_AMOUNT TEXT,"
        "$EASY TEXT,"
        "$EASY_A TEXT,"
        "$EASY_B TEXT,"
        "$EASY_C TEXT,"
        "$ECOM TEXT,"
        "$EMAIL TEXT,"
        "$EMAIL_FORMATTED TEXT,"
        "$EMAIL_NORMALIZED TEXT,"
        "$EMPLOYEE TEXT,"
        "$CUSTOMER_IDS TEXT,"
        "$EMPLOYEE_REF TEXT,"
        "$EMPLOYEES_COUNT TEXT,"
        "$FOLLOWUP_LEVEL TEXT,"
        "$FOLLOWUP_STATUS TEXT,"
        "$FUNCTION TEXT,"
        "$GENDER_IN_CT TEXT,"
        "$HAS_MESSAGE_IN_CT TEXT,"
        "$HAS_UNRECONCILED_ENTRIES TEXT,"
        "$IAP_ENRICH_INFO TEXT,"
        "$IAP_SEARCH_DOMAIN TEXT,"
        "$IMAGE_1024_IN_CT TEXT,"
        "$IMAGE_128_IN_CT TEXT,"
        "$IMAGE_1920_IN_CT TEXT,"
        "$IMAGE_256_IN_CT TEXT,"
        "$IMAGE_512_IN_CT TEXT,"
        "$IMAGE_MEDIUM TEXT,"
        "$IM_STATUS TEXT,"
        "$INDUSTRY_ID TEXT,"
        "$INVOICE_IDS TEXT,"
        "$INVOICE_WARN TEXT,"
        "$INVOICE_WARN_MSG TEXT,"
        "$IS_BLACKLISTED TEXT,"
        "$IS_COMPANY TEXT,"
        "$IS_PUBLISHED TEXT,"
        "$IS_SEO_OPTIMIZED TEXT,"
        "$IS_SUPPLIER TEXT,"
        "$JOURNAL_ITEM_COUNT TEXT,"
        "$LANG_IN_CT TEXT,"
        "$LAST_MOBIKUL_SO_ID TEXT,"
        "$LAST_TIME_ENTRIES_CHECKED TEXT,"
        "$LAST_UPDATE_IN_CT TEXT,"
        "$LAST_WEBSITE_SO_ID TEXT,"
        "$LOYALTY_POINTS_IN_CT TEXT,"
        "$MAXI TEXT,"
        "$MEETING_COUNT TEXT,"
        "$MEETING_IDS TEXT,"
        "$MEMBER_TYPE TEXT,"
        "$MESSAGE_ATTACHMENT_COUNT_IN_CT TEXT,"
        "$MESSAGE_BOUNCE TEXT,"
        "$MESSAGE_FOLLOWER_IDS_IN_CT TEXT,"
        "$MESSAGE_HAS_ERROR_IN_CT TEXT,"
        "$MESSAGE_HAS_ERROR_COUNTER_IN_CT TEXT,"
        "$MESSAGE_HAS_SMS_ERROR_IN_CT TEXT,"
        "$MESSAGE_IDS_IN_CT TEXT,"
        "$MESSAGE_IS_FOLLOWER_IN_CT TEXT,"
        "$MESSAGE_MAIN_ATTACHMENT_ID_IN_CT TEXT,"
        "$MESSAGE_NEEDACTION_IN_CT TEXT,"
        "$MESSAGE_NEEDACTION_COUNTER_IN_CT TEXT,"
        "$MESSAGE_PARTNER_IDS_IN_CT TEXT,"
        "$MESSAGE_UNREAD_IN_CT TEXT,"
        "$MESSAGE_UNREAD_COUNTER_IN_CT TEXT,"
        "$MOBILE TEXT,"
        "$MOBILE_BLACKLISTED TEXT,"
        "$MOBILE_USER TEXT,"
        "$MY_ACTIVITY_DATE_DEADLINE_IN_CT TEXT,"
        "$NAME_IN_CT TEXT,"
        "$NRC TEXT,"
        "$OCN_TOKEN TEXT,"
        "$ONLINE_PARTNER_INFORMATION TEXT,"
        "$ON_TIME_RATE TEXT,"
        "$OPPORTUNITY_COUNT TEXT,"
        "$OPPORTUNITY_IDS TEXT,"
        "$OVER_CREDIT TEXT,"
        "$PARENT_ID_IN_CT TEXT,"
        "$PARENT_NAME TEXT,"
        "$PARTNER_GENDER TEXT,"
        "$PARTNER_LATITUDE TEXT,"
        "$PARTNER_LONGITUDE TEXT,"
        "$PARTNER_SHARE TEXT,"
        "$PAYMENT_NEXT_ACTION_DATE TEXT,"
        "$PAYMENT_RESPONSIBLE_ID TEXT,"
        "$PAYMENT_TOKEN_COUNT TEXT,"
        "$PAYMENT_TOKEN_IDS TEXT,"
        "$PHONE_IN_CT TEXT,"
        "$PHONE_BLACKLISTED TEXT,"
        "$PHONE_MOBILE_SEARCH TEXT,"
        "$PHONE_SANITIZED TEXT,"
        "$PHONE_SANITIZED_BLACKLISTED TEXT,"
        "$PICKING_TYPE TEXT,"
        "$PICKING_WARN TEXT,"
        "$PICKING_WARN_MSG TEXT,"
        "$POS_ORDER_COUNT TEXT,"
        "$POS_ORDER_IDS TEXT,"
        "$PROPERTY_ACCOUNT_PAYABLE_ID TEXT,"
        "$PROPERTY_ACCOUNT_POSITION_ID TEXT,"
        "$PROPERTY_ACCOUNT_RECEIVABLE_ID TEXT,"
        "$PROPERTY_DELIVERY_CARRIER_ID TEXT,"
        "$PROPERTY_PAYMENT_TERM_ID TEXT,"
        "$PROPERTY_PRODUCT_PRICELIST TEXT,"
        "$PROPERTY_PURCHASE_CURRENCY_ID TEXT,"
        "$PROPERTY_STOCK_CUSTOMER TEXT,"
        "$PROPERTY_STOCK_SUPPLIER TEXT,"
        "$PROPERTY_SUPPLIER_PAYMENT_TERM_ID TEXT,"
        "$PURCHASE_LINE_IDS TEXT,"
        "$PURCHASE_ORDER_COUNT TEXT,"
        "$PURCHASE_WARN TEXT,"
        "$PURCHASE_WARN_MSG TEXT,"
        "$QR_CODE TEXT,"
        "$RANKING TEXT,"
        "$REBATE_CHARGE TEXT,"
        "$RECEIPT_REMINDER_EMAIL TEXT,"
        "$REF TEXT,"
        "$REF_COMPANY_IDS TEXT,"
        "$REGION_ID TEXT,"
        "$REMINDER_DATE_BEFORE_RECEIPT TEXT,"
        "$SALE_ORDER_COUNT TEXT,"
        "$SALE_ORDER_IDS TEXT,"
        "$SALE_WARN TEXT,"
        "$SALE_WARN_MSG TEXT,"
        "$SAME_VAT_PARTNER_ID TEXT,"
        "$SELF TEXT,"
        "$SEO_NAME TEXT,"
        "$SH_CID TEXT,"
        "$SH_CUSTOMER_DISCOUNT TEXT,"
        "$SH_EXPIRY_DATE TEXT,"
        "$SH_LOYALTY_CARD_NO TEXT,"
        "$SH_OWN_CUSTOMER TEXT,"
        "$SH_USER_POINT TEXT,"
        "$SH_USER_POINT_AMOUNT TEXT,"
        "$SIGNATURE_COUNT TEXT,"
        "$SIGNUP_EXPIRATION TEXT,"
        "$SIGNUP_TOKEN TEXT,"
        "$SIGNUP_TYPE TEXT,"
        "$SIGNUP_URL TEXT,"
        "$SIGNUP_VALID TEXT,"
        "$STATE_ID TEXT,"
        "$STREET TEXT,"
        "$STREET2 TEXT,"
        "$SUPPLIER_INVOICE_COUNT TEXT,"
        "$SUPPLIER_RANK TEXT,"
        "$SYNC_MOBILE TEXT,"
        "$TEAM_ID TEXT,"
        "$TITLE TEXT,"
        "$TOKEN_IDS TEXT,"
        "$TOTAL_DUE TEXT,"
        "$TOTAL_INVOICED TEXT,"
        "$TOTAL_OVERDUE TEXT,"
        "$TOTAL_SALE_AMOUNT TEXT,"
        "$TOWNSHIP_ID TEXT,"
        "$TRUST TEXT,"
        "$TYPE TEXT,"
        "$TZ_IN_CT TEXT,"
        "$TZ_OFFSET TEXT,"
        "$UNPAID_INVOICES TEXT,"
        "$UNRECONCILED_AML_IDS TEXT,"
        "$USER_ID TEXT,"
        "$USER_IDS TEXT,"
        "$VAT TEXT,"
        "$VENDOR_CODE TEXT,"
        "$VENDOR_REG TEXT,"
        "$VISITOR_IDS TEXT,"
        "$WALLET_BALANCE TEXT,"
        "$WALLET_COUNTS TEXT,"
        "$WALLET_CREDITS TEXT,"
        "$WALLET_ID TEXT,"
        "$WARNING_STAGE TEXT,"
        "$WEBSITE TEXT,"
        "$WEBSITE_DESCRIPTION TEXT,"
        "$WEBSITE_ID TEXT,"
        "$WEBSITE_MESSAGE_IDS_IN_CT TEXT,"
        "$WEBSITE_META_DESCRIPTION TEXT,"
        "$WEBSITE_META_KEYWORDS TEXT,"
        "$WEBSITE_META_OG_IMG TEXT,"
        "$WEBSITE_META_TITLE TEXT,"
        "$WEBSITE_PUBLISHED TEXT,"
        "$WEBSITE_SHORT_DESCRIPTION TEXT,"
        "$WEBSITE_URL TEXT,"
        "$WISHLIST_IDS TEXT,"
        "$WRITE_DATE TEXT,"
        "$WRITE_UID TEXT,"
        "$X_STUDIO_BUSINESS_INDUSTRY TEXT,"
        "$X_STUDIO_CUSTOMER_GROUP TEXT,"
        "$X_STUDIO_EXTRA_BANK_INFORMATION TEXT,"
        "$X_STUDIO_EXTRA_INFO TEXT,"
        "$X_STUDIO_SELECTION_FIELD_EDYMZ TEXT,"
        "$X_STUDIO_TRADER TEXT,"
        "$X_STUDIO_TRADER_DISPLAY_NAME TEXT,"
        "$ZIP TEXT"
        ")");
  }

  static Future<int> insert(Customer customer) async {
    final Database db = await DatabaseHelper().db;
    String sql = "INSERT INTO $CUSTOMER_TABLE_NAME("
        // "$ACCOUNT_REPRESENTED_COMPANY_IDS,"
        // "$ACTIVE_IN_CT,"
        // "$ACTIVE_LANG_COUNT,"
        // "$ACTIVE_LIMIT,"
        // "$ACTIVITY_CALENDAR_EVENT_ID_IN_CT,"
        // "$ACTIVITY_DATE_DEADLINE_IN_CT,"
        // "$ACTIVITY_EXCEPTION_DECORATION_IN_CT,"
        // "$ACTIVITY_EXCEPTION_ICON_IN_CT,"
        // "$ACTIVITY_IDS,"
        // "$ACTIVITY_STATE_IN_CT,"
        // "$ACTIVITY_SUMMARY_IN_CT,"
        // "$ACTIVITY_TYPE_ICON_IN_CT,"
        // "$ACTIVITY_TYPE_ID_IN_CT,"
        // "$ACTIVITY_USER_ID_IN_CT,"
        // "$APP_CUSTOMER,"
        // "$AVATAR_1024_IN_CT,"
        // "$AVATAR_128_IN_CT,"
        // "$AVATAR_1920_IN_CT,"
        // "$AVATAR_256_IN_CT,"
        // "$AVATAR_512_IN_CT,"
        // "$BANK_ACCOUNT_COUNT,"
        // "$BANK_IDS,"
        // "$BANNER_IMAGE,"
        // "$BARCODE_IN_CT,"
        // "$BLOCKING_STAGE,"
        // "$CALENDAR_LAST_NOTIF_ACK,"
        // "$CAN_PUBLISH,"
        // "$CATEGORY_ID,"
        // "$CHANNEL_IDS,"
        // "$CHILD_IDS_IN_CT,"
        // "$CITY,"
        // "$CITY_ID,"
        // "$COLOR_IN_CT,"
        // "$COMMENT,"
        // "$COMMERCIAL_COMPANY_NAME,"
        // "$COMMERCIAL_PARTNER_ID,"
        // "$COMPANY_ID,"
        // "$COMPANY_NAME,"
        // "$COMPANY_TYPE,"
        "$CONTACT_ADDRESS,"
        // "$CONTACT_ADDRESS_COMPLETE,"
        // "$CONTRACT_IDS_IN_CT,"
        // "$COUNTRY_CODE_IN_CT,"
        // "$COUNTRY_ID_IN_CT,"
        // "$CREATE_DATE_IN_CT,"
        // "$CREATE_UID,"
        // "$CREDIT,"
        // "$CREDIT_LIMIT,"
        // "$CURRENCY_ID_IN_CT,"
        // "$CUSTOMER_CODE,"
        // "$CUSTOMER_RANK,"
        // "$CVS,"
        // "$DATE,"
        // "$DATE_LOCALIZATION,"
        // "$DEBIT,"
        // "$DEBIT_LIMIT,"
        // "$DEFAULT_SHIPPING_ADDRESS_ID,"
        // "$DEFAULT_SUPPLIERINFO_DISCOUNT,"
        // "$DELIVERY_CHARGE,"
        // "$DEVICE_TOKEN,"
        // "$DICA_REG,"
        // "$DISCOUNT,"
        // "$DISPLAY_NAME_IN_CT,"
        "$DOB,"
        // "$DOCUMENT_COUNT_IN_CT,"
        // "$DUE_AMOUNT,"
        // "$EASY,"
        // "$EASY_A,"
        // "$EASY_B,"
        // "$EASY_C,"
        // "$ECOM,"
        "$EMAIL,"
        // "$EMAIL_FORMATTED,"
        // "$EMAIL_NORMALIZED,"
        // "$EMPLOYEE,"
        // "$CUSTOMER_IDS,"
        // "$EMPLOYEE_REF,"
        // "$EMPLOYEES_COUNT,"
        // "$FOLLOWUP_LEVEL,"
        // "$FOLLOWUP_STATUS,"
        // "$FUNCTION,"
        // "$GENDER_IN_CT,"
        // "$HAS_MESSAGE_IN_CT,"
        // "$HAS_UNRECONCILED_ENTRIES,"
        // "$IAP_ENRICH_INFO,"
        // "$IAP_SEARCH_DOMAIN,"
        // "$IMAGE_1024_IN_CT,"
        // "$IMAGE_128_IN_CT,"
        // "$IMAGE_1920_IN_CT,"
        // "$IMAGE_256_IN_CT,"
        // "$IMAGE_512_IN_CT,"
        // "$IMAGE_MEDIUM,"
        // "$IM_STATUS,"
        // "$INDUSTRY_ID,"
        // "$INVOICE_IDS,"
        // "$INVOICE_WARN,"
        // "$INVOICE_WARN_MSG,"
        // "$IS_BLACKLISTED,"
        // "$IS_COMPANY,"
        // "$IS_PUBLISHED,"
        // "$IS_SEO_OPTIMIZED,"
        // "$IS_SUPPLIER,"
        // "$JOURNAL_ITEM_COUNT,"
        // "$LANG_IN_CT,"
        // "$LAST_MOBIKUL_SO_ID,"
        // "$LAST_TIME_ENTRIES_CHECKED,"
        // "$LAST_UPDATE_IN_CT,"
        // "$LAST_WEBSITE_SO_ID,"
        // "$LOYALTY_POINTS_IN_CT,"
        // "$MAXI,"
        // "$MEETING_COUNT,"
        // "$MEETING_IDS,"
        // "$MEMBER_TYPE,"
        // "$MESSAGE_ATTACHMENT_COUNT_IN_CT,"
        // "$MESSAGE_BOUNCE,"
        // "$MESSAGE_FOLLOWER_IDS_IN_CT,"
        // "$MESSAGE_HAS_ERROR_IN_CT,"
        // "$MESSAGE_HAS_ERROR_COUNTER_IN_CT,"
        // "$MESSAGE_HAS_SMS_ERROR_IN_CT,"
        // "$MESSAGE_IDS_IN_CT,"
        // "$MESSAGE_IS_FOLLOWER_IN_CT,"
        // "$MESSAGE_MAIN_ATTACHMENT_ID_IN_CT,"
        // "$MESSAGE_NEEDACTION_IN_CT,"
        // "$MESSAGE_NEEDACTION_COUNTER_IN_CT,"
        // "$MESSAGE_PARTNER_IDS_IN_CT,"
        // "$MESSAGE_UNREAD_IN_CT,"
        // "$MESSAGE_UNREAD_COUNTER_IN_CT,"
        // "$MOBILE,"
        // "$MOBILE_BLACKLISTED,"
        // "$MOBILE_USER,"
        // "$MY_ACTIVITY_DATE_DEADLINE_IN_CT,"
        "$NAME_IN_CT,"
        "$NRC,"
        "$OCN_TOKEN,"
        // "$ONLINE_PARTNER_INFORMATION,"
        // "$ON_TIME_RATE,"
        // "$OPPORTUNITY_COUNT,"
        // "$OPPORTUNITY_IDS,"
        // "$OVER_CREDIT,"
        // "$PARENT_ID_IN_CT,"
        // "$PARENT_NAME,"
        // "$PARTNER_GENDER,"
        // "$PARTNER_LATITUDE,"
        // "$PARTNER_LONGITUDE,"
        // "$PARTNER_SHARE,"
        // "$PAYMENT_NEXT_ACTION_DATE,"
        // "$PAYMENT_RESPONSIBLE_ID,"
        // "$PAYMENT_TOKEN_COUNT,"
        // "$PAYMENT_TOKEN_IDS,"
        "$PHONE_IN_CT"
        // "$PHONE_BLACKLISTED,"
        // "$PHONE_MOBILE_SEARCH,"
        // "$PHONE_SANITIZED,"
        // "$PHONE_SANITIZED_BLACKLISTED,"
        // "$PICKING_TYPE,"
        // "$PICKING_WARN,"
        // "$PICKING_WARN_MSG,"
        // "$POS_ORDER_COUNT,"
        // "$POS_ORDER_IDS,"
        // "$PROPERTY_ACCOUNT_PAYABLE_ID,"
        // "$PROPERTY_ACCOUNT_POSITION_ID,"
        // "$PROPERTY_ACCOUNT_RECEIVABLE_ID,"
        // "$PROPERTY_DELIVERY_CARRIER_ID,"
        // "$PROPERTY_PAYMENT_TERM_ID,"
        // "$PROPERTY_PRODUCT_PRICELIST,"
        // "$PROPERTY_PURCHASE_CURRENCY_ID,"
        // "$PROPERTY_STOCK_CUSTOMER,"
        // "$PROPERTY_STOCK_SUPPLIER,"
        // "$PROPERTY_SUPPLIER_PAYMENT_TERM_ID,"
        // "$PURCHASE_LINE_IDS,"
        // "$PURCHASE_ORDER_COUNT,"
        // "$PURCHASE_WARN,"
        // "$PURCHASE_WARN_MSG,"
        // "$QR_CODE,"
        // "$RANKING,"
        // "$REBATE_CHARGE,"
        // "$RECEIPT_REMINDER_EMAIL,"
        // "$REF,"
        // "$REF_COMPANY_IDS,"
        // "$REGION_ID,"
        // "$REMINDER_DATE_BEFORE_RECEIPT,"
        // "$SALE_ORDER_COUNT,"
        // "$SALE_ORDER_IDS,"
        // "$SALE_WARN,"
        // "$SALE_WARN_MSG,"
        // "$SAME_VAT_PARTNER_ID,"
        // "$SELF,"
        // "$SEO_NAME,"
        // "$SH_CID,"
        // "$SH_CUSTOMER_DISCOUNT,"
        // "$SH_EXPIRY_DATE,"
        // "$SH_LOYALTY_CARD_NO,"
        // "$SH_OWN_CUSTOMER,"
        // "$SH_USER_POINT,"
        // "$SH_USER_POINT_AMOUNT,"
        // "$SIGNATURE_COUNT,"
        // "$SIGNUP_EXPIRATION,"
        // "$SIGNUP_TOKEN,"
        // "$SIGNUP_TYPE,"
        // "$SIGNUP_URL,"
        // "$SIGNUP_VALID,"
        // "$STATE_ID,"
        // "$STREET,"
        // "$STREET2,"
        // "$SUPPLIER_INVOICE_COUNT,"
        // "$SUPPLIER_RANK,"
        // "$SYNC_MOBILE,"
        // "$TEAM_ID,"
        // "$TITLE,"
        // "$TOKEN_IDS,"
        // "$TOTAL_DUE,"
        // "$TOTAL_INVOICED,"
        // "$TOTAL_OVERDUE,"
        // "$TOTAL_SALE_AMOUNT,"
        // "$TOWNSHIP_ID,"
        // "$TRUST,"
        // "$TYPE,"
        // "$TZ_IN_CT,"
        // "$TZ_OFFSET,"
        // "$UNPAID_INVOICES,"
        // "$UNRECONCILED_AML_IDS,"
        // "$USER_ID,"
        // "$USER_IDS,"
        // "$VAT,"
        // "$VENDOR_CODE,"
        // "$VENDOR_REG,"
        // "$VISITOR_IDS,"
        // "$WALLET_BALANCE,"
        // "$WALLET_COUNTS,"
        // "$WALLET_CREDITS,"
        // "$WALLET_ID,"
        // "$WARNING_STAGE,"
        // "$WEBSITE,"
        // "$WEBSITE_DESCRIPTION,"
        // "$WEBSITE_ID,"
        // "$WEBSITE_MESSAGE_IDS_IN_CT,"
        // "$WEBSITE_META_DESCRIPTION,"
        // "$WEBSITE_META_KEYWORDS,"
        // "$WEBSITE_META_OG_IMG,"
        // "$WEBSITE_META_TITLE,"
        // "$WEBSITE_PUBLISHED,"
        // "$WEBSITE_SHORT_DESCRIPTION,"
        // "$WEBSITE_URL,"
        // "$WISHLIST_IDS,"
        // "$WRITE_DATE,"
        // "$WRITE_UID,"
        // "$X_STUDIO_BUSINESS_INDUSTRY,"
        // "$X_STUDIO_CUSTOMER_GROUP,"
        // "$X_STUDIO_EXTRA_BANK_INFORMATION,"
        // "$X_STUDIO_EXTRA_INFO,"
        // "$X_STUDIO_SELECTION_FIELD_EDYMZ,"
        // "$X_STUDIO_TRADER,"
        // "$X_STUDIO_TRADER_DISPLAY_NAME,"
        // "$ZIP"
        ")"
        " VALUES("
        "'${customer.contactAddress}',"
        "'${customer.dob}',"
        "'${customer.email}',"
        "'${customer.name}',"
        "'${customer.nrc}',"
        "'${customer.ocnToken}',"
        "'${customer.phone}'"
        ")";

    return db.rawInsert(sql);
  }

  static Future<List<Customer>> getAll() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      CUSTOMER_TABLE_NAME,
      orderBy: '$CUSTOMER_ID_IN_CT DESC',
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Customer.fromJson(maps[i]);
    });
  }

  static Future<List<Customer>> getEmployeeWithFilter(String filter) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("select * from $CUSTOMER_TABLE_NAME "
            "where $NAME_IN_CT like '%$filter%' "
            "or $BARCODE_IN_CT like '%$filter%'");

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Customer.fromJson(maps[i]);
    });
  }

  static Future<Customer?> getCustomerByCustomerId(int customerId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      CUSTOMER_TABLE_NAME,
      where: "$CUSTOMER_ID_IN_CT=?",
      whereArgs: [customerId],
      limit: 1,
    );

    return Customer.fromJson(maps.first);
  }

  static Future<Customer?> checkCustomerWithIdAndPassword(
      int customerId, String password) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("select * from $CUSTOMER_TABLE_NAME "
            "where $CUSTOMER_ID_IN_CT='$customerId' "
            "and $PIN='$password'");

    return maps.isEmpty ? null : Customer.fromJson(maps.first);
  }

  static Future<int> delete(int customerId) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(
      CUSTOMER_TABLE_NAME,
      where: "$CUSTOMER_ID_IN_CT=?",
      whereArgs: [customerId],
    );
  }

  static Future<int> update(Customer customer) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      CUSTOMER_TABLE_NAME,
      customer.toJson(),
      where: "$CUSTOMER_ID_IN_CT=?",
      whereArgs: [customer.customerId],
    );
  }
}
