*** Variables ***
${ENV}          dev
#${mpe_new_host}    https://mpe.${ENV}.platform.michaels.com/api   # dev.platform.michaels.com      %{TEST_HOST}
${mpe_new_host}                https://mik.${ENV}.platform.michaels.com/api/mpe
&{default_headers}    Content-Type=application/json
...                   accept=*/*
...                   User-Agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36 Edg/96.0.1054.43
@{retry_status}       ${502}               ${503}
&{path}    activity_add=activity/add
...        promotion_add=promotion/add
...        promotion_distribute=promotion/distribute
...        apply_coupon=api/coupon/apply
...        activity_update=activity/update
...        activity_check=activity/get
...        activity_list=activity/list
...        activity_remove=activity/remove
...        activity_stop=activity/stop
...        promotion_update=promotion/update
...        promotion_bundle=promotion/bundle/add
...        promotion_get=promotion/get
...        promotion_remove=promotion/remove
...        promotion_sync=promotion/syncPromotion
...        promotion_clear_expired=promotion/clearExpiredPromotion
...        promotion_list=promotion/list
...        promotion_status=promotion
...        coupon_get=coupon/get
...        coupon_disable=coupon/disable
...        coupon_list=coupon/list
...        coupon_log=couponlog/list
...        coupon_disable=coupon/disable
...        group_add_specified=group/addSpecified
...        group_add_defined=group/addSelfDefined
...        group_get=group/get
...        group_list=group/getGroupList
...        group_remove_item=group/removeGroupItem
...        group_remove_group=group/removeGroup
...        group_clear_all_items=group/clearItems
...        apply_match=api/coupon/match
...        apply_and_match=api/coupon/matchApply
...        get_pro_store=api/promotion/store
...        get_pro_id=api/promotion/id
...        get_pro_code=api/promotion/code
...        get_cp_sub=api/coupon/suborder
...        get_cp_sub_recall=coupon/suborder/recall
...        get_cp_id=api/coupon/id
...        get_cp_code=api/coupon/code
...        get_cp_buyer=api/coupon/buyer
...        set_global=global/set
...        all_global_setting=global/setting
...        global_get=global/get
...        fresh_ppa=ppa/scheduledLockFtp
...        health_check=healthcheck
...        apply_coupon1=apply/coupon
...        save_promotion_loadobject=ppa/savePromotionByUploadObject
...        save_group_loadobject=ppa/saveGroupMappingByUpload

