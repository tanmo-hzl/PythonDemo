import time


WORKER_ID_BITS = 5
SEQUENCE_BITS = 12

MAX_WORKER_ID = -1 ^ (-1 << WORKER_ID_BITS)

WORKER_ID_SHIFT = SEQUENCE_BITS
TIMESTAMP_LEFT_SHIFT = SEQUENCE_BITS + WORKER_ID_BITS

SEQUENCE_MASK = -1 ^ (-1 << SEQUENCE_BITS)
TWEPOCH = 1594977661913


class SnowflakeId(object):
    def __init__(self, worker_id=1, sequence=0):
        if worker_id > MAX_WORKER_ID or worker_id < 0:
            raise ValueError('worker_id cross the line')

        self.worker_id = worker_id
        self.sequence = sequence
        self.last_timestamp = -1

    @staticmethod
    def _get_timestamp():
        return int(time.time() * 1000)

    def _wait_next_millis(self, last_timestamp):
        timestamp = self._get_timestamp()
        while timestamp <= last_timestamp:
            timestamp = self._get_timestamp()
        return timestamp

    def generate_id(self):
        timestamp = self._get_timestamp()
        if timestamp == self.last_timestamp:
            self.sequence = (self.sequence + 1) & SEQUENCE_MASK
            if self.sequence == 0:
                timestamp = self._wait_next_millis(self.last_timestamp)
        else:
            self.sequence = 0
        self.last_timestamp = timestamp
        new_id = ((timestamp - TWEPOCH) << TIMESTAMP_LEFT_SHIFT) | (self.worker_id << WORKER_ID_SHIFT) | self.sequence
        return new_id

    def generate_bulk_id(self, num):
        return [self.generate_id() for i in range(int(num))]


if __name__ == '__main__':
    worker = SnowflakeId(worker_id=1, sequence=0)
    new_id = worker.generate_id()
    print(new_id)




