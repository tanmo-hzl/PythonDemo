import datetime
import random
import time
from typing import Optional


class RequestBodyReporter(object):
    def __init__(self):
        pass

    @staticmethod
    def search_users_of_organization_body(
        roles=None, statuses: Optional[str] = "ACTIVE"
    ):
        roles = roles if roles else ["BUYER", "ADMIN", "VIEWER"]
        body = {
            "searchTerm": "",
            "roles": roles,
            "statuses": [statuses],
        }
        return body

    @staticmethod
    def get_random_period_time():
        time_period = random.choice(
            ["month", "quarter", "year", "previous-year", "all-time"]
        )
        now = datetime.datetime.now()
        if time_period == "month":
            time_obj = datetime.datetime(now.year, now.month, 1)
            start_time = int(
                time_obj.replace(tzinfo=datetime.timezone.utc).timestamp() * 1000
            )
            end_time = int(time.time() * 1000)
        elif time_period == "quarter":
            month = (now.month - 1) - (now.month - 1) % 3 + 1
            this_month_start = datetime.datetime(now.year, month, 1)
            start_time = int(
                this_month_start.replace(tzinfo=datetime.timezone.utc).timestamp()
                * 1000
            )
            end_time = int(time.time() * 1000)
        elif time_period == "year":
            this_year_start = datetime.datetime(now.year, 1, 1)
            start_time = int(
                this_year_start.replace(tzinfo=datetime.timezone.utc).timestamp() * 1000
            )
            end_time = int(time.time() * 1000)
        elif time_period == "previous-year":
            start_time = int(
                datetime.datetime(now.year - 1, 1, 1)
                .replace(tzinfo=datetime.timezone.utc)
                .timestamp()
                * 1000
            )
            end_time = int(
                datetime.datetime(now.year, 1, 1)
                .replace(tzinfo=datetime.timezone.utc)
                .timestamp()
                * 1000
            )
        else:
            start_time = int(
                datetime.datetime(now.year - 20, 1, 1)
                .replace(tzinfo=datetime.timezone.utc)
                .timestamp()
                * 1000
            )
            end_time = int(
                datetime.datetime.now()
                .replace(tzinfo=datetime.timezone.utc)
                .timestamp()
                * 1000
            )
        return start_time, end_time

    @staticmethod
    def get_random_period_data():
        time_period = random.choice(
            ["month", "quarter", "year", "previous-year", "all-time"]
        )
        now = datetime.datetime.now()
        if time_period == "month":
            start_data = datetime.datetime(now.year, now.month, 1).strftime(
                "%Y-%m-%dT16:00:00.000Z"
            )
            end_data = datetime.datetime.now().strftime("%Y-%m-%dT15:59:59.288Z")
        elif time_period == "quarter":
            month = (now.month - 1) - (now.month - 1) % 3 + 1
            start_data = datetime.datetime(now.year, month, 1).strftime(
                "%Y-%m-%dT16:00:00.000Z"
            )
            end_data = datetime.datetime.now().strftime("%Y-%m-%dT15:59:59.288Z")
        elif time_period == "year":
            start_data = datetime.datetime(now.year, 1, 1).strftime(
                "%Y-%m-%dT16:00:00.000Z"
            )
            end_data = datetime.datetime.now().strftime("%Y-%m-%dT15:59:59.288Z")
        elif time_period == "previous-year":
            start_data = datetime.datetime(now.year - 2, 12, 31).strftime(
                "%Y-%m-%dT16:00:00.000Z"
            )
            end_data = datetime.datetime(now.year - 1, 12, 31).strftime(
                "%Y-%m-%dT16:00:00.000Z"
            )
        else:
            start_data = datetime.datetime(now.year - 20, 1, 1).strftime(
                "%Y-%m-%dT16:00:00.000Z"
            )
            end_data = now.strftime("%Y-%m-%dT16:00:00.000Z")
        return start_data, end_data

    def get_sale_summary_report_body(self, user_ids, organization_ids):
        start_time, end_time = self.get_random_period_time()
        body = {
            "userIds": random.choices(user_ids, k=random.randint(1, len(user_ids))),
            "organizationIds": [organization_ids],
            "startTime": start_time,
            "endTime": end_time,
            "summarizeBy": random.choice(["1", "2", "4"]),
        }
        return body

    def get_save_report_body(self, user_ids, organization_ids):
        start_data, end_data = self.get_random_period_data()
        body = {
            "reportName": f"automation_reporter_{int(time.time())}",
            "startDate": start_data,
            "endDate": end_data,
            "compareToPrevious": False,
            "organizationIds": [organization_ids],
            "buyerIds": random.choices(user_ids, k=random.randint(1, len(user_ids))),
            "orderType": "ALL",
            "summarizeBy": random.choice(["ACCOUNT", "BUYER", "NONE"]),
        }
        return body

    def get_sales_report_body(self, user_ids, organization_ids):
        start_time, end_time = self.get_random_period_time()
        body = {
            "userIds": random.choices(user_ids, k=random.randint(1, len(user_ids))),
            "organizationIds": [organization_ids],
            "startTime": start_time,
            "endTime": end_time,
            "pageNumber": 1,
            "pageSize": 50,
        }
        return body


if __name__ == "__main__":
    print(int(time.time()))

