# supabase_client.py
# کلاینت سبک برای ارتباط با Supabase از طریق REST API (PostgREST)
# نیازمند کتابخانه urequests (باید از قبل روی دستگاه نصب/کپی شده باشد).

import urequests as requests
import config


def _headers(extra=None):
    headers = {
        "apikey": config.SUPABASE_KEY,
        "Authorization": "Bearer " + config.SUPABASE_KEY,
        "Content-Type": "application/json",
    }
    if extra:
        headers.update(extra)
    return headers


def insert(table: str, data: dict) -> bool:
    """درج یک رکورد جدید در جدول مشخص‌شده."""
    url = "{}/rest/v1/{}".format(config.SUPABASE_URL, table)
    try:
        resp = requests.post(
            url,
            json=data,
            headers=_headers({"Prefer": "return=minimal"}),
        )
        ok = resp.status_code in (200, 201, 204)
        resp.close()
        return ok
    except Exception as e:
        print("[supabase_client] خطا در insert:", e)
        return False


def select(table: str, query: str = "", limit: int = None) -> list:
    """
    خواندن رکوردها از جدول.
    query نمونه: "device_id=eq.goldoonban-01&executed=eq.false&order=created_at.desc"
    """
    url = "{}/rest/v1/{}?{}".format(config.SUPABASE_URL, table, query)
    if limit:
        url += "&limit={}".format(limit)
    try:
        resp = requests.get(url, headers=_headers())
        data = resp.json()
        resp.close()
        return data if isinstance(data, list) else []
    except Exception as e:
        print("[supabase_client] خطا در select:", e)
        return []


def update(table: str, query: str, data: dict) -> bool:
    """به‌روزرسانی رکوردهایی که با query فیلتر می‌شوند."""
    url = "{}/rest/v1/{}?{}".format(config.SUPABASE_URL, table, query)
    try:
        resp = requests.patch(
            url,
            json=data,
            headers=_headers({"Prefer": "return=minimal"}),
        )
        ok = resp.status_code in (200, 204)
        resp.close()
        return ok
    except Exception as e:
        print("[supabase_client] خطا در update:", e)
        return False


def log_action(action: str, status: str, message: str = ""):
    """
    ثبت گزارش هر عملیات در جدول logs.
    این تابع در تمام بخش‌های برنامه بعد از هر اقدام مهم صدا زده می‌شود.
    """
    payload = {
        "device_id": config.DEVICE_ID,
        "action": action,
        "status": status,
        "message": message,
    }
    ok = insert(config.TABLE_LOGS, payload)
    if not ok:
        print("[supabase_client] ثبت گزارش ناموفق بود:", action, status, message)
