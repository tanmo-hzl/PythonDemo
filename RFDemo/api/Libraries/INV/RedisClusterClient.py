import itertools

import rediscluster


class RedisClusterClient:
    def __init__(self):
        startup_nodes = [
            {"host": "10.16.13.206", "port": 6379},
            {"host": "10.16.13.207", "port": 6379},
            {"host": "10.16.13.203", "port": 6379}
        ]

        password = "SRgYtMnKNk9yQa2h"

        self.key_templates = [
            "SKU_MIK_INVENTORY:B:{}--1",
            "MIK_SKU_PRICE:{}--1"
        ]

        self.r = rediscluster.RedisCluster(startup_nodes=startup_nodes, password=password)

    def _get_key_names(self, *sku_list):
        key_list = map(lambda x: [t.format(x) for t in self.key_templates], sku_list)
        return list(itertools.chain(*key_list))

    def clear_sku(self, *sku_list):
        self.r.delete(*self._get_key_names(*sku_list))

    def query(self, *sku_list):
        ret = {}
        for sku in sku_list:
            for k in self._get_key_names(sku):
                ret[k] = self.r.get(k)
        return ret


if __name__ == "__main__":
    rc = RedisClusterClient()
    test_sku_list = ["10619990", "10619992"]
    original = rc.query(*test_sku_list)
    rc.clear_sku(*test_sku_list)
    cleared = rc.query(*test_sku_list)
    print(original)
    print("============")
    print(cleared)
