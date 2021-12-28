*** Settings ***
Library             ../../Libraries/API_Portal/tools.py
Library             ../../Libraries/API_Portal/listing_data.py
Library             ../../Libraries/API_Portal/update_listing.py


*** Variables ***

${base_url}    https://mda.tst02.platform.michaels.com/api
${api_key}     32c72a25f068bd51f7b087b090baabe4bf0ad4ae26c1a10b4946587ff6d24f3fcb95ec9b3f7d2f0c
${read_api_key}     9cb7d2dc50cecf2a1413e4c3d0b4ced82616b7fef742210aa6668a9649e7f5b1f7efc6b651ca076b

${tst02_api_key2}   e779ccaffcc8ee51271fc1ad2e3d839deda02c68dcd445300c821f312f46883ffe496c30c2cc5559
${dev_api_key2}     ec49dda37c35ed4236b5e8b0ea62f3ef2eda95fd25ac830c19b26b6d5b79fa1508560e5606ff505b
${tst03_api_key}    38db91f8c09485d87bbc8bf16829fe86414763c62ca1fdbc223154bd51667558a5563e002ba8a9eb
${aps_api_key}     0d6153caf84e253f296f27eb98faa11862394f1ad1508c3602d6a87b6168a46d8e4b8d3acb9c2311

${sandbox_api_key}     91d12621f060e2c6cd977b5ad25ff0bead7c67e5e884b86a61d663013fa1a25d3c9baf654966a641
${tst02_api_key}     e5e3cbb27c3bef36e73a05d1c2f8b717f53b8933f0e3e3fe93cafa2567a34c54cdbd4eee144987d4
${tst_api_key}     662f9c043af6b1e85cf33372d02044c8c72e2e28c12d05cabae1839d6f0416b0fb5b9ed3433b83df
${dev_api_key}      7635c2056ba716211ce530de615f43c34bb5b0d6844a0b2c9fb325271063bc5b533388f5eccf6456

${sandbox_read_api_key}        9cb7d2dc50cecf2a1413e4c3d0b4ced82616b7fef742210aa6668a9649e7f5b1f7efc6b651ca076b
${tst02_read_api_key}         4ae144a0696ac75a9f7aa0fe1b705787f753f7226b44a96b1420cb851f60ae52f8290c238b89c94f

${sandbox_base_url}    https://mda.aps.platform.michaels.com/api
${tst02_base_url}    https://mda.tst02.platform.michaels.com/api


${create_listing}    /developer/api/v1/listing
${get_one_lisiting}   /developer/api/v1/listing/
${get_bantch_lisiting}   /developer/api/v1/listing/batch-get
${get_lisiting_by_seller_sku}   /developer/api/v1/listing/seller-sku-number/batch-get
${query_listing}    /developer/api/v1/listing/query
${activate_listing}   /developer/api/v1/listing/activate
${deactivate_listing}   /developer/api/v1/listing/deactivate
${update_listing}       /developer/api/v1/listing/
${download_template}    /developer/api/v1/listing/download-excel-template
${create_template_listing}      /developer/api/v1/listing/upload-excel
${export_template_listing}      /developer/api/v1/listing/export-excel
${upload_media}    /developer/api/v1/listing/media

${get_sku_inventory}    /developer/api/v1/listing/inventory/
${update_inventory}    /developer/api/v1/listing/inventory/update-inventory
${get_batch_inventory}     /developer/api/v1/listing/inventory/sku-number/batch-get
${get_inventory_by_sellerSKU}       /developer/api/v1/listing/inventory/seller-sku-number/batch-get
${update_inventory_by_sellerSKU}       /developer/api/v1/listing/inventory/update-inventory-by-seller-sku-number

${get_sku_price}        /developer/api/v1/listing/price
${get_batch_price}      /developer/api/v1/listing/price/sku-number/batch-get
${update_sku_price}        /developer/api/v1/listing/price/publish
${get_price_by_sellerSKU}       /developer/api/v1/listing/price/seller-sku-number/batch-get
${update_price_by_sellerSKU}       /developer/api/v1/listing/price/publish-by-seller-sku-number

${get_taxonomy_list}        /developer/api/v1/listing/taxonomy
${get_taxonomy_attr}        /developer/api/v1/listing/taxonomy/get-taxonomy-attributes


${query_order}      /developer/api/order/query
${get_order}      /developer/api/order/
${ready_order}     /developer/api/order/ready-to-ship
${add_shipment_item}        /developer/api/order/shipped
${cancel_order}     /developer/api/order/cancel-order


${get_retun_by_return_num}     /developer/api/v1/order/returns/return-order-number
${get_retun_by_order_num}     /developer/api/v1/order/returns/order-number/
${query_return}     /developer/api/v1/order/returns/list
${approve_refund}     /developer/api/v1/order/returns/approve-refund
${reject_refund}     /developer/api/v1/order/returns/reject-refund




