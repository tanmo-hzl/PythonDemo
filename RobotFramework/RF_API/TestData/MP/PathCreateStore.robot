*** Variables ***

# create store application, approve, input store information to completed registration
${check-email}                      /usr/user/check-email-existed
${seller-pre-application}           /seller/pre-application
${mik-seller-query}                 /seller/query
${mik-seller-approve}               /seller/approve-application
${mik-seller-application}           /seller/application-by-id
${mik-user-create}                  /user/create
${mik-company-name}                 /cms/content/text
${mik-seller-bank-account}          /fin/seller/bank-account/validate
${mik-store-registration}           /store/registration

# input store profile, service time, shipping rate, fulfillment and return option
${mik-store-id-by-user-id}          /store/store-id
${mik-store-profile}                /store/profile-v2
${mik-new-customer-service}         /store/new-customer-service
${mik-shipping-rate-add}            /shipping-rate/add
${mik-store-fulfillment}            /store/fulfillment
${mik-store-return-option}          /store/return-option

# check the store status and get complete information of store
${mik-store-isEA-seller}            /store/isEASeller
${mik-storefront-preview}           /storefront/preview
${mik-store-onboarding-verify}      /store/onboarding/verify
${mik-store-seller-info}            /store/getSellerStoreInfo
${mik-storefront-seller-info}       /storefront/getSellerStoreInfo?storeId=5897674474681262080
${mik-store-info-by-store-id}       /store/store-info/5897674474681262080


