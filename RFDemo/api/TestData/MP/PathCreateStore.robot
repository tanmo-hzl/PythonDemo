*** Variables ***

# create store application, approve, input store information to completed registration
${check-email}                      /usr/user/check-email-existed
${seller-pre-application}           /mda/seller/pre-application
${mik-seller-query}                 /mda/seller/query
${mik-seller-approve}               /mda/seller/approve-application
${mik-seller-application}           /mda/seller/application-by-id
${mik-user-create}                  /user/create
${mik-company-name}                 /cms/content/text
${mik-seller-bank-account}          /fin/seller/bank-account/validate
${mik-store-registration}           /mda/store/registration

# input store profile, service time, shipping rate, fulfillment and return option
${mik-store-id-by-user-id}          /mda/store/store-id
${mik-store-profile}                /mda/store/profile-v2
${mik-new-customer-service}         /mda/store/new-customer-service
${mik-shipping-rate-add}            /mda/shipping-rate/add
${mik-store-fulfillment}            /mda/store/fulfillment
${mik-store-return-option}          /mda/store/return-option

# check the store status and get complete information of store
${mik-store-isEA-seller}            /mda/store/isEASeller
${mik-storefront-preview}           /mda/storefront/preview
${mik-store-onboarding-verify}      /mda/store/onboarding/verify
${mik-store-seller-info}            /mda/store/getSellerStoreInfo
${mik-storefront-seller-info}       /storefront/getSellerStoreInfo?storeId=5897674474681262080
${mik-store-info-by-store-id}       /store/store-info/5897674474681262080


