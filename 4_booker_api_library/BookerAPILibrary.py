from functools import partialmethod
from typing import Dict

from requests import Response, Session
from robot.api.deco import keyword


class BookerAPILibrary(object):
    base_url: str
    session: Session
    response: Response
    response_body: Dict
    token: str

    def __init__(self, base_url: str, login_credentials: Dict = None):
        self.base_url = base_url
        self.session = Session()

        if login_credentials:
            self.log_in(login_credentials)

    def _send_request(self, *args, **kwargs):
        self.response = self.session.request(*args, **kwargs)
        self.response.raise_for_status()
        self.response_body = self.response.json

        return self.response_body

    def send_request(self, method: str, endpoint: str, *args, **kwargs):
        if not endpoint.startswith("/"):
            endpoint = "/" + endpoint

        return self._send_request(method, f"{self.base_url}{endpoint}", *args, **kwargs)

    @keyword("Send GET Request")
    def send_get_request(self, *args, **kwargs):
        return self.send_request("GET", *args, **kwargs)

    send_get_request = partialmethod(send_request, "GET")
    send_post_request = partialmethod(send_request, "POST")
    send_put_request = partialmethod(send_request, "PUT")
    send_patch_request = partialmethod(send_request, "PATCH")

    def try_log_in(self, payload: Dict):
        return self.send_post_request("auth", json=payload)

    def log_in(self, payload: Dict):
        self.try_log_in(payload)

        assert "token" in self.response_body, self.response_body["reason"]
        self.token = self.response_body["token"]
        self.session.headers.update({"Cookie", f"token={self.token}"})

        return self.response_body


BookerAPILibrary.send_get_request.robot_name = "test"
