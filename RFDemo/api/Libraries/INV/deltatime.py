from datetime import datetime, timedelta


def get_delta_timestamp(timestamp: str = None, **kwargs):
    """
    :param timestamp: 13 digits number
    :param kwargs: keys includes weeks, days, hours, minutes, seconds
    :return: 13 digits int
    """
    if not timestamp:
        dt = datetime.now()
    else:
        dt = datetime.fromtimestamp(int(timestamp)/1000)

    if kwargs:
        kwargs = dict(map(lambda item: (item[0], float(item[1])), kwargs.items()))
        dt += timedelta(**kwargs)

    return int(dt.timestamp() * 1000)
